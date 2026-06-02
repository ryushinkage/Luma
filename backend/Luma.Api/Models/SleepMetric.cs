using System;

namespace Luma.Api.Models
{
    public class SleepMetric
    {
        public Guid Id { get; set; }
        public Guid SleepRecordId { get; set; }
        public SleepRecord SleepRecord { get; set; }
        public float RegularityScore { get; set; }
        public int SleepDebtMinutes { get; set; }
        public float QualityScore { get; set; }
        public float EfficiencyScore { get; set; }
    }
}