using System;

namespace Luma.Api.Models
{
    public class RiskIndicator
    {
        public Guid Id { get; set; }

        public Guid ReportId { get; set; }
        public AIReport Report { get; set; }

        public string RiskType { get; set; }
        public string Description { get; set; }
        public RiskLevel Level { get; set; } // Наш Enum
    }
}