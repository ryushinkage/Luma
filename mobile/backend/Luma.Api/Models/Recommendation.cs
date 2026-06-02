using System;

namespace Luma.Api.Models
{
    public class Recommendation
    {
        public Guid Id { get; set; }

        // Зв'язок зі звітом ШІ
        public Guid ReportId { get; set; }
        public AIReport Report { get; set; }

        // Поля з діаграми
        public string Title { get; set; }
        public string Description { get; set; }
        public RecommendationType Type { get; set; } // Наш Enum
        public int Priority { get; set; }
    }
}