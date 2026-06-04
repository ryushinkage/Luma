using System;

namespace Luma.Api.Models
{
    public class UserProfile
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public User User { get; set; }
        public string SleepGoal { get; set; }
        public TimeSpan PreferredSleepTime { get; set; }
        public TimeSpan PreferredWakeTime { get; set; }
    }
}