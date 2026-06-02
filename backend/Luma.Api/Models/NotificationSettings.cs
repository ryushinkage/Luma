using System;

namespace Luma.Api.Models
{
    public class NotificationSettings
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public User User { get; set; }
        public bool PushEnabled { get; set; }
        public TimeSpan ReminderTime { get; set; }
        public bool SmartRemindersEnabled { get; set; }
    }
}