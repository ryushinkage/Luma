namespace Luma.Api.Models;

public class JournalEntry
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid UserId { get; set; }  // позже привяжем к реальному юзеру
    public string Content { get; set; } = string.Empty;

    // mood: -5..+5 (удобно для аналитики)
    public int Mood { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAtUtc { get; set; }
}