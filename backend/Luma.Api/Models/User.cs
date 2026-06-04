using System;
using System.Collections.Generic; 
namespace Luma.Api.Models 
{
    public class User
    {
        public Guid Id { get; set; }
        public string Email { get; set; }
        public string DisplayName { get; set; }
        public string PasswordHash { get; set; }
        public DateTime CreatedAtUtc { get; set; }
        public string Role { get; set; } = "User";
        public ICollection<SleepRecord> SleepRecords { get; set; } = new List<SleepRecord>();
        public UserProfile Profile { get; set; }
        public NotificationSettings NotificationSettings { get; set; }
        public Subscription Subscription { get; set; }
        public ICollection<AIReport> AIReports { get; set; } = new List<AIReport>();
    }
}