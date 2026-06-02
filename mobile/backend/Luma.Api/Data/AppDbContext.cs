using Luma.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Luma.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<JournalEntry> JournalEntries => Set<JournalEntry>();
    public DbSet<SleepRecord> SleepRecords => Set<SleepRecord>();
    public DbSet<UserProfile> UserProfiles => Set<UserProfile>();
    public DbSet<SleepFactor> SleepFactors => Set<SleepFactor>();
    public DbSet<SleepMetric> SleepMetrics => Set<SleepMetric>();
    public DbSet<NotificationSettings> NotificationSettings => Set<NotificationSettings>();
    public DbSet<Subscription> Subscriptions => Set<Subscription>();
    public DbSet<AIReport> AIReports => Set<AIReport>();
    public DbSet<Recommendation> Recommendations => Set<Recommendation>();
    public DbSet<RiskIndicator> RiskIndicators => Set<RiskIndicator>();

    // ОСТАННЯ ТАБЛИЦЯ
    public DbSet<RecommendationRule> RecommendationRules => Set<RecommendationRule>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>(e =>
        {
            e.HasKey(x => x.Id);
            e.HasIndex(x => x.Email).IsUnique();
            e.Property(x => x.Email).IsRequired().HasMaxLength(320);
            e.Property(x => x.DisplayName).IsRequired().HasMaxLength(200);
            e.Property(x => x.Role).IsRequired().HasMaxLength(50);

            e.HasMany(x => x.SleepRecords).WithOne(s => s.User).HasForeignKey(s => s.UserId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(x => x.Profile).WithOne(p => p.User).HasForeignKey<UserProfile>(p => p.UserId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(x => x.NotificationSettings).WithOne(n => n.User).HasForeignKey<NotificationSettings>(n => n.UserId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(x => x.Subscription).WithOne(s => s.User).HasForeignKey<Subscription>(s => s.UserId).OnDelete(DeleteBehavior.Cascade);
            e.HasMany(x => x.AIReports).WithOne(r => r.User).HasForeignKey(r => r.UserId).OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<JournalEntry>(e =>
        {
            e.HasKey(x => x.Id);
            e.Property(x => x.Content).IsRequired().HasMaxLength(10000);
            e.Property(x => x.Mood).IsRequired();
            e.HasIndex(x => new { x.UserId, x.CreatedAtUtc });
        });

        modelBuilder.Entity<SleepRecord>(e =>
        {
            e.HasKey(x => x.Id);
            e.Property(x => x.SleepDate).IsRequired();
            e.HasMany(x => x.SleepFactors).WithOne(f => f.SleepRecord).HasForeignKey(f => f.SleepRecordId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(x => x.Metric).WithOne(m => m.SleepRecord).HasForeignKey<SleepMetric>(m => m.SleepRecordId).OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<UserProfile>(e => { e.HasKey(x => x.Id); e.Property(x => x.SleepGoal).HasMaxLength(300); });
        modelBuilder.Entity<SleepFactor>(e => { e.HasKey(x => x.Id); e.Property(x => x.Notes).HasMaxLength(500); });
        modelBuilder.Entity<SleepMetric>(e => { e.HasKey(x => x.Id); });
        modelBuilder.Entity<NotificationSettings>(e => { e.HasKey(x => x.Id); });

        modelBuilder.Entity<Subscription>(e =>
        {
            e.HasKey(x => x.Id);
            e.Property(x => x.PlanType).HasConversion<string>();
            e.Property(x => x.Status).HasConversion<string>();
        });

        modelBuilder.Entity<AIReport>(e =>
        {
            e.HasKey(x => x.Id);
            e.HasMany(x => x.Recommendations).WithOne(r => r.Report).HasForeignKey(r => r.ReportId).OnDelete(DeleteBehavior.Cascade);
            e.HasMany(x => x.RiskIndicators).WithOne(ri => ri.Report).HasForeignKey(ri => ri.ReportId).OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<Recommendation>(e => { e.HasKey(x => x.Id); e.Property(x => x.Type).HasConversion<string>(); });
        modelBuilder.Entity<RiskIndicator>(e => { e.HasKey(x => x.Id); e.Property(x => x.Level).HasConversion<string>(); });

        // Налаштування останньої таблиці
        modelBuilder.Entity<RecommendationRule>(e => { e.HasKey(x => x.Id); });
    }
}