using System;

namespace Luma.Api.Models
{
    public class Recommendation
    {
        public Guid Id { get; set; }

        public Guid ReportId { get; set; }
        public AIReport Report { get; set; }

        public string Title { get; set; }
        public string Description { get; set; }
        public RecommendationType Type { get; set; } 
        public int Priority { get; set; }
    }
}