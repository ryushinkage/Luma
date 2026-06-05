using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Luma.Api.Data;
using Luma.Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace Luma.Api.Controllers;

[ApiController]
[Route("api/ai-coach")]
public class AiCoachController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly HttpClient _httpClient;
    private readonly string _apiKey;

    public class AiCoachRequestDto
    {
        public Guid UserId { get; set; }
        public string Message { get; set; } = string.Empty;
        public DateTime PeriodStart { get; set; }
        public DateTime PeriodEnd { get; set; }
        public bool SaveReport { get; set; }
    }

    private class GeminiResponseShape
    {
        public string assistantMessage { get; set; } = string.Empty;
        public string summary { get; set; } = string.Empty;
        public string insights { get; set; } = string.Empty;
        public List<RecommendationDto> recommendations { get; set; } = new();
        public List<RiskIndicatorDto> riskIndicators { get; set; } = new();
    }

    private class RecommendationDto
    {
        public string title { get; set; } = string.Empty;
        public string description { get; set; } = string.Empty;
        public string type { get; set; } = "SleepMode";
        public int priority { get; set; }
    }

    private class RiskIndicatorDto
    {
        public string riskType { get; set; } = string.Empty;
        public string description { get; set; } = string.Empty;
        public string level { get; set; } = "Low";
    }

    public AiCoachController(AppDbContext context, IConfiguration configuration, HttpClient httpClient)
    {
        _context = context;
        _httpClient = httpClient;
        _apiKey = configuration["GeminiSettings:ApiKey"]
            ?? throw new InvalidOperationException("API Key не знайдено в appsettings.json");
    }

    [HttpPost("messages")]
    public async Task<IActionResult> GetAiCoachRecommendation([FromBody] AiCoachRequestDto dto)
    {
        if (dto.UserId == Guid.Empty) return BadRequest("UserId є обов'язковим.");

        dto.PeriodStart = DateTime.SpecifyKind(dto.PeriodStart, DateTimeKind.Utc);
        dto.PeriodEnd = DateTime.SpecifyKind(dto.PeriodEnd, DateTimeKind.Utc);

        var sleepRecords = await _context.SleepRecords
            .Where(r => r.UserId == dto.UserId && r.SleepDate >= dto.PeriodStart && r.SleepDate <= dto.PeriodEnd)
            .OrderBy(r => r.SleepDate)
            .ToListAsync();

        var sleepDataSummary = string.Join("\n", sleepRecords.Select(r =>
            $"- Дата сну: {r.SleepDate:yyyy-MM-dd}, Початок: {r.SleepStart:HH:mm}, Кінець: {r.SleepEnd:HH:mm}, Тривалість: {r.DurationMinutes} хв, Ефективність сну: {r.SleepEfficiency}%"));

        if (!sleepRecords.Any())
        {
            sleepDataSummary = "За вказаний період записи сну в базі даних відсутні.";
        }

        string systemInstruction = "Ти — професійний медичний AI-коуч зі сну в додатку Luma. Твоє завдання — аналізувати статистику сну, відповідати на питання користувача українською мовою та повертати СТРОГО чистий JSON об'єкт.";

        string userPrompt = $@"
Користувач задає питання: ""{dto.Message}""

Ось його актуальні дані сну за період з {dto.PeriodStart:yyyy-MM-dd} по {dto.PeriodEnd:yyyy-MM-dd}:
{sleepDataSummary}

Сформуй відповідь СТРОГО у форматі JSON за такою схемой (не використовуй маркдаун блоки типу ```json, віддай тільки сирий текст об'єкта):
{{
  ""assistantMessage"": ""Твоя розгорнута відповідь на питання користувача українською мовою."",
  ""summary"": ""Короткий підсумок аналізу періоду сну (1-2 речення)."",
  ""insights"": ""Глибокі інсайти щодо виявлених закономірностей або аномалій сну."",
  ""recommendations"": [
    {{
      ""title"": ""Назва рекомендації"",
      ""description"": ""Детальний опис дії"",
      ""type"": ""SleepMode"", 
      ""priority"": 1
    }}
  ],
  ""riskIndicators"": [
    {{
      ""riskType"": ""SleepDebt"",
      ""description"": ""Опис ризику"",
      ""level"": ""Medium""
    }}
  ]
}}

Дозволені Enum-типи:
- recommendations.type: ""SleepMode"", ""CircadianRhythm"", ""Environment"", ""Lifestyle"".
- riskIndicators.level: ""Low"", ""Medium"", ""High"".";

        // Чистий рядок без жодного прихованого форматування
        string url = "https://api.groq.com/openai/v1/chat/completions";

        var requestBody = new
        {
            model = "llama-3.1-8b-instant",
            messages = new[]
             {
                new { role = "system", content = systemInstruction },
                new { role = "user", content = userPrompt }
            },
            response_format = new { type = "json_object" },
            temperature = 0.3
        };

        try
        {
            var jsonPayload = JsonSerializer.Serialize(requestBody);
            var content = new StringContent(jsonPayload, Encoding.UTF8, "application/json");

            // Очищаємо заголовок перед додаванням токена
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _apiKey.Trim());

            var response = await _httpClient.PostAsync(url, content);
            if (!response.IsSuccessStatusCode)
            {
                var errorText = await response.Content.ReadAsStringAsync();
                return StatusCode((int)response.StatusCode, $"Помилка ШІ провайдера: {errorText}");
            }

            var responseString = await response.Content.ReadAsStringAsync();

            using var jsonDoc = JsonDocument.Parse(responseString);
            var rawAiText = jsonDoc.RootElement
                .GetProperty("choices")[0]
                .GetProperty("message")
                .GetProperty("content")
                .GetString();

            if (string.IsNullOrEmpty(rawAiText))
                return StatusCode(500, "ШІ повернув порожню відповідь.");

            var aiResult = JsonSerializer.Deserialize<GeminiResponseShape>(rawAiText);
            if (aiResult == null) return StatusCode(500, "Не вдалося розпарсити JSON від ШІ.");

            var reportId = Guid.NewGuid();
            var dbReport = new AIReport
            {
                Id = reportId,
                UserId = dto.UserId,
                PeriodStart = dto.PeriodStart,
                PeriodEnd = dto.PeriodEnd,
                Summary = aiResult.summary,
                Insights = aiResult.insights,
                GeneratedAt = DateTime.UtcNow
            };

            foreach (var recDto in aiResult.recommendations)
            {
                Enum.TryParse(recDto.type, out RecommendationType parsedType);
                dbReport.Recommendations.Add(new Recommendation
                {
                    Id = Guid.NewGuid(),
                    ReportId = reportId,
                    Title = recDto.title,
                    Description = recDto.description,
                    Type = parsedType,
                    Priority = recDto.priority
                });
            }

            foreach (var riskDto in aiResult.riskIndicators)
            {
                Enum.TryParse(riskDto.level, out RiskLevel parsedLevel);
                dbReport.RiskIndicators.Add(new RiskIndicator
                {
                    Id = Guid.NewGuid(),
                    ReportId = reportId,
                    RiskType = riskDto.riskType,
                    Description = riskDto.description,
                    Level = parsedLevel
                });
            }

            if (dto.SaveReport)
            {
                _context.AIReports.Add(dbReport);
                await _context.SaveChangesAsync();
            }

            return Ok(new
            {
                messageId = Guid.NewGuid(),
                reportId = reportId,
                assistantMessage = aiResult.assistantMessage,
                summary = dbReport.Summary,
                insights = dbReport.Insights,
                generatedAt = dbReport.GeneratedAt.ToString("yyyy-MM-ddTHH:mm:ss.fffZ"),
                recommendations = dbReport.Recommendations.Select(r => new
                {
                    title = r.Title,
                    description = r.Description,
                    type = r.Type.ToString(),
                    priority = r.Priority
                }),
                riskIndicators = dbReport.RiskIndicators.Select(ri => new
                {
                    riskType = ri.RiskType,
                    description = ri.Description,
                    level = ri.Level.ToString()
                })
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Внутрішня помилка сервера: {ex.Message}");
        }
    }
}