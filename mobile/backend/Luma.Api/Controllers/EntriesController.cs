using Luma.Api.Data;
using Luma.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Luma.Api.Controllers;

[ApiController]
[Route("api/v1/entries")] 
public class EntriesController : ControllerBase
{
    private readonly AppDbContext _db;

    public EntriesController(AppDbContext db) => _db = db;
    private Guid GetUserId()
    {
        if (Request.Headers.TryGetValue("X-User-Id", out var values) &&
            Guid.TryParse(values.FirstOrDefault(), out var userId))
            return userId;
        return Guid.Parse("11111111-1111-1111-1111-111111111111");
    }

    [HttpPost]
    public async Task<ActionResult> Create(JournalEntry entry)
    {
        entry.UserId = GetUserId();
        entry.Id = Guid.NewGuid();
        entry.CreatedAtUtc = DateTime.UtcNow;

        _db.JournalEntries.Add(entry);
        await _db.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = entry.Id }, entry);
    }

    [HttpGet]
    public async Task<ActionResult> GetAll()
    {
        var userId = GetUserId();
        var items = await _db.JournalEntries
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAtUtc)
            .Take(50)
            .ToListAsync();
        return Ok(items);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult> GetById(Guid id)
    {
        var item = await _db.JournalEntries.FirstOrDefaultAsync(x => x.Id == id && x.UserId == GetUserId());
        return item is null ? NotFound() : Ok(item);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult> Update(Guid id, JournalEntry updated)
    {
        var item = await _db.JournalEntries.FirstOrDefaultAsync(x => x.Id == id && x.UserId == GetUserId());
        if (item is null) return NotFound();

        item.Content = updated.Content;
        item.Mood = updated.Mood;
        item.UpdatedAtUtc = DateTime.UtcNow;

        await _db.SaveChangesAsync();
        return Ok(item);
    }

    [HttpDelete("{id:guid}")]
    public async Task<ActionResult> Delete(Guid id)
    {
        var item = await _db.JournalEntries.FirstOrDefaultAsync(x => x.Id == id && x.UserId == GetUserId());
        if (item is null) return NotFound();

        _db.JournalEntries.Remove(item);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
