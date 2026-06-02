namespace Luma.Api.Models
{
    public enum PlanType
    {
        Free,
        Premium
    }

    public enum SubscriptionStatus
    {
        Active,
        Expired,
        Cancelled
    }

    public enum RiskLevel
    {
        Low,
        Medium,
        High
    }

    public enum RecommendationType
    {
        SleepMode,
        Habit,
        Stress,
        Activity
    }
}