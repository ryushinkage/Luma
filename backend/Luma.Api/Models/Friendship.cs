using System;

namespace Luma.Api.Models;

public class Friendship
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }       
    public Guid FriendUserId { get; set; } 
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
}