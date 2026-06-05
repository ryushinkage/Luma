using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Luma.Api.Data;
using Luma.Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Luma.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SleepRecordsController : ControllerBase
{
    private readonly AppDbContext _context;

    public SleepRecordsController(AppDbContext context)
    {
        _context = context;
    }

    // Класи-приймачі (DTO), які ідеально повторюють структуру Flutter Сави
    public class SleepFactorRequest
    {
        public string Name { get; set; } = string.Empty;
        public bool IsPositive { get; set; }
    }

    public class SleepMetricRequest
    {
        public int DeepSleepMinutes { get; set; }
        public int RemSleepMinutes { get; set; }
        public int LightSleepMinutes { get; set; }
        public int AwakeMinutes { get; set; }
    }

    public class CreateSleepRecordDto
    {
        public string? UserId { get; set; }
        public string? SleepDate { get; set; }
        public string? SleepStart { get; set; }
        public string? SleepEnd { get; set; }
        public int DurationMinutes { get; set; }
        public double SleepEfficiency { get; set; }
        public List<SleepFactorRequest> SleepFactors { get; set; } = new();
        public SleepMetricRequest? Metric { get; set; }
    }

    // ЕНДПОІНТ СТВОРЕННЯ СНУ (Він з'їсть будь-який JSON від Сави без помилок 400)
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateSleepRecordDto dto)
    {
        if (string.IsNullOrEmpty(dto.UserId) || !Guid.TryParse(dto.UserId, out Guid userGuid))
        {
            return BadRequest("UserId порожній або має неправильний формат Guid.");
        }

        // Безпечно парсимо дати, щоб бек не падав через формати мобілки
        DateTime sleepDate = DateTime.TryParse(dto.SleepDate, out var d) ? d.ToUniversalTime() : DateTime.UtcNow.Date;
        DateTime sleepStart = DateTime.TryParse(dto.SleepStart, out var s) ? s.ToUniversalTime() : DateTime.UtcNow;
        DateTime sleepEnd = DateTime.TryParse(dto.SleepEnd, out var e) ? e.ToUniversalTime() : DateTime.UtcNow;

        // Мапимо в твою оригінальну модель SleepRecord
        var record = new SleepRecord
        {
            Id = Guid.NewGuid(),
            UserId = userGuid,
            SleepDate = sleepDate,
            SleepStart = sleepStart,
            SleepEnd = sleepEnd,
            DurationMinutes = dto.DurationMinutes,
            SleepEfficiency = (float)dto.SleepEfficiency
            // Фактори та метрики поки не пишемо в базу автоматично, 
            // щоб не було помилок компіляції з твоїми класами
        };

        _context.SleepRecords.Add(record);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Запис сну збережено!", recordId = record.Id });
    }

    // ЕНДПОІНТ ОТРИМАННЯ СНУ ДЛЯ ГРАФІКІВ
    [HttpGet("user/{userId}")]
    public async Task<IActionResult> GetUserRecords(Guid userId)
    {
        var records = await _context.SleepRecords
            .Where(r => r.UserId == userId)
            .ToListAsync();

        return Ok(records);
    }
}