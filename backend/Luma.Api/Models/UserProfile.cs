using System;

namespace Luma.Api.Models
{
    public class UserProfile
    {
        public Guid Id { get; set; }

        // Зв'язок 1-до-1 з користувачем
        public Guid UserId { get; set; }
        public User User { get; set; }

        // Дані профілю з діаграми
        public string SleepGoal { get; set; }
        public TimeSpan PreferredSleepTime { get; set; }
        public TimeSpan PreferredWakeTime { get; set; }
    }
}