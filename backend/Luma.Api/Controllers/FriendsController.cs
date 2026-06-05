using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Luma.Api.Data;
using Luma.Api.Models;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Luma.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FriendsController : ControllerBase
{
    private readonly AppDbContext _context;

    public FriendsController(AppDbContext context)
    {
        _context = context;
    }

    public class CreateRequestDto
    {
        public string ReceiverEmail { get; set; } = string.Empty;
        public string RequesterId { get; set; } = string.Empty; 
    }

    [HttpGet("me")]
    public async Task<IActionResult> GetMyFriends([FromQuery] Guid userId)
    {
        if (userId == Guid.Empty) return BadRequest("UserId обов'язковий.");

        var friendsIds = await _context.Friendships
            .Where(f => f.UserId == userId || f.FriendUserId == userId)
            .Select(f => f.UserId == userId ? f.FriendUserId : f.UserId)
            .ToListAsync();

        var friends = await _context.Users
            .Where(u => friendsIds.Contains(u.Id))
            .Select(u => new { u.Id, u.Email, u.DisplayName })
            .ToListAsync();

        var incoming = await _context.FriendshipRequests
            .Where(r => r.ReceiverId == userId && r.Status == RequestStatus.Pending)
            .ToListAsync();

        var outgoing = await _context.FriendshipRequests
            .Where(r => r.RequesterId == userId && r.Status == RequestStatus.Pending)
            .ToListAsync();

        return Ok(new
        {
            friends = friends,
            incomingRequests = incoming,
            outgoingRequests = outgoing
        });
    }

    [HttpPost("requests")]
    public async Task<IActionResult> SendFriendRequest([FromBody] CreateRequestDto dto)
    {
        if (!Guid.TryParse(dto.RequesterId, out Guid requesterGuid))
            return BadRequest("Некоректний або порожній RequesterId.");

        var receiver = await _context.Users
            .FirstOrDefaultAsync(u => u.Email.ToLower() == dto.ReceiverEmail.ToLower());

        if (receiver == null) return NotFound("Користувача з таким Email не знайдено.");
        if (receiver.Id == requesterGuid) return BadRequest("Ви не можете додати у друзі самого себе.");

        var existingRequest = await _context.FriendshipRequests
            .FirstOrDefaultAsync(r => ((r.RequesterId == requesterGuid && r.ReceiverId == receiver.Id) ||
                                       (r.RequesterId == receiver.Id && r.ReceiverId == requesterGuid))
                                      && r.Status == RequestStatus.Pending);

        if (existingRequest != null) return BadRequest("Заявка вже надіслана або очікує підтвердження.");

        var request = new FriendshipRequest
        {
            Id = Guid.NewGuid(),
            RequesterId = requesterGuid,
            ReceiverId = receiver.Id,
            Status = RequestStatus.Pending
        };

        _context.FriendshipRequests.Add(request);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Заявку в друзі успішно надіслано!" });
    }

    [HttpPost("requests/{requestId}/accept")]
    public async Task<IActionResult> AcceptRequest(Guid requestId)
    {
        var request = await _context.FriendshipRequests.FindAsync(requestId);
        if (request == null || request.Status != RequestStatus.Pending)
            return NotFound("Активну заявку не знайдено.");

        request.Status = RequestStatus.Accepted;
        request.RespondedAtUtc = DateTime.UtcNow;

        var friendship = new Friendship
        {
            Id = Guid.NewGuid(),
            UserId = request.RequesterId,
            FriendUserId = request.ReceiverId
        };

        _context.Friendships.Add(friendship);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Заявку прийнято! Тепер ви друзі." });
    }

    [HttpPost("requests/{requestId}/decline")]
    public async Task<IActionResult> DeclineRequest(Guid requestId)
    {
        var request = await _context.FriendshipRequests.FindAsync(requestId);
        if (request == null || request.Status != RequestStatus.Pending)
            return NotFound("Активну заявку не знайдено.");

        request.Status = RequestStatus.Declined;
        request.RespondedAtUtc = DateTime.UtcNow;

        await _context.SaveChangesAsync();
        return Ok(new { message = "Заявку відхилено." });
    }

    [HttpPost("requests/{requestId}/cancel")]
    public async Task<IActionResult> CancelRequest(Guid requestId)
    {
        var request = await _context.FriendshipRequests.FindAsync(requestId);
        if (request == null || request.Status != RequestStatus.Pending)
            return NotFound("Активну заявку не знайдено.");

        _context.FriendshipRequests.Remove(request);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Заявку скасовано." });
    }
}