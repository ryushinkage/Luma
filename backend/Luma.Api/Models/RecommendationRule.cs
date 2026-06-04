using System;

namespace Luma.Api.Models
{
    public class RecommendationRule
    {
        public Guid Id { get; set; }
        public string Condition { get; set; }
        public string Action { get; set; }
        public bool Active { get; set; }
    }
}