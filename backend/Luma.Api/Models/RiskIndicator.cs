using System;

namespace Luma.Api.Models
{
    public class RiskIndicator
    {
        public Guid Id { get; set; }

        // Зв'язок зі звітом ШІ
        public Guid ReportId { get; set; }
        public AIReport Report { get; set; }

        // Поля з діаграми
        public string RiskType { get; set; }
        public string Description { get; set; }
        public RiskLevel Level { get; set; } // Наш Enum
    }
}