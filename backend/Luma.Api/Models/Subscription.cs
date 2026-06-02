using System;

namespace Luma.Api.Models
{
    public class Subscription
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public User User { get; set; }

        public PlanType PlanType { get; set; }
        public SubscriptionStatus Status { get; set; }
        public DateTime ExpiresAt { get; set; }
        public bool IsPremium()
        {
            return PlanType == PlanType.Premium &&
                   Status == SubscriptionStatus.Active &&
                   ExpiresAt > DateTime.UtcNow;
        }
    }
}