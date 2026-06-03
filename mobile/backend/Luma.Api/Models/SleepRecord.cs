using System;
using System.Collections.Generic;

namespace Luma.Api.Models
{
    public class SleepRecord
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public User User { get; set; }
        public DateTime SleepDate { get; set; }
        public DateTime SleepStart { get; set; }
        public DateTime SleepEnd { get; set; }
        public int DurationMinutes { get; set; }
        public float SleepEfficiency { get; set; }
        public ICollection<SleepFactor> SleepFactors { get; set; } = new List<SleepFactor>();
        public SleepMetric Metric { get; set; }
    }
}
   