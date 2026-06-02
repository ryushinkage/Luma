using System;
using System.Collections.Generic;

namespace Luma.Api.Models
{
    public class AIReport
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public User User { get; set; }
        public DateTime PeriodStart { get; set; }
        public DateTime PeriodEnd { get; set; }
        public string Summary { get; set; }
        public string Insights { get; set; }
        public DateTime GeneratedAt { get; set; }
        public ICollection<Recommendation> Recommendations { get; set; } = new List<Recommendation>();
        public ICollection<RiskIndicator> RiskIndicators { get; set; } = new List<RiskIndicator>();
    }
}