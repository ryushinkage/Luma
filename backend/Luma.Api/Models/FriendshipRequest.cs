using System;

namespace Luma.Api.Models;

public enum RequestStatus
{
    Pending,
    Accepted,
    Declined
}

public class FriendshipRequest
{
    public Guid Id { get; set; }
    public Guid RequesterId { get; set; } 
    public Guid ReceiverId { get; set; }  
    public RequestStatus Status { get; set; } = RequestStatus.Pending;
    public DateTime RequestedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? RespondedAtUtc { get; set; }
}