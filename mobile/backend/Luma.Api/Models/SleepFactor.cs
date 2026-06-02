using System;

namespace Luma.Api.Models
{
    public class SleepFactor
    {
        public Guid Id { get; set; }
        public Guid SleepRecordId { get; set; }
        public SleepRecord SleepRecord { get; set; }
        public bool Caffeine { get; set; }
        public int StressLevel { get; set; }
        public int ScreenTimeMinutes { get; set; }
        public int PhysicalActivityMinutes { get; set; }
        public string Notes { get; set; }
    }
}