using Luma.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Luma.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<JournalEntry> JournalEntries => Set<JournalEntry>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>(e =>
        {
            e.HasKey(x => x.Id);
            e.HasIndex(x => x.Email).IsUnique();
            e.Property(x => x.Email).IsRequired().HasMaxLength(320);
            e.Property(x => x.DisplayName).IsRequired().HasMaxLength(200);
        });

        modelBuilder.Entity<JournalEntry>(e =>
        {
            e.HasKey(x => x.Id);
            e.Property(x => x.Content).IsRequired().HasMaxLength(10000);
            e.Property(x => x.Mood).IsRequired();
            e.HasIndex(x => new { x.UserId, x.CreatedAtUtc });
        });
    }
}