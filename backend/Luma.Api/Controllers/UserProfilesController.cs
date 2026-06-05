using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Luma.Api.Data;
using Luma.Api.Models;
using System;
using System.Threading.Tasks;

namespace Luma.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserProfilesController : ControllerBase
{
    private readonly AppDbContext _context;

    public UserProfilesController(AppDbContext context)
    {
        _context = context;
    }

    public class ProfileTestDto
    {
        public Guid UserId { get; set; }
        public string SleepGoal { get; set; } = string.Empty;
        public string PreferredSleepTime { get; set; } = "23:00:00"; 
        public string PreferredWakeTime { get; set; } = "07:00:00";  
    }

    [HttpPost]
    public async Task<IActionResult> SaveProfile([FromBody] ProfileTestDto dto)
    {
        if (dto.UserId == Guid.Empty)
            return BadRequest("Помилка: UserId не може бути порожнім!");

        TimeSpan sleepTime;
        TimeSpan wakeTime;

        if (!TimeSpan.TryParse(dto.PreferredSleepTime, out sleepTime))
            sleepTime = new TimeSpan(23, 0, 0); // 23:00

        if (!TimeSpan.TryParse(dto.PreferredWakeTime, out wakeTime))
            wakeTime = new TimeSpan(7, 0, 0);   // 07:00

        var existingProfile = await _context.UserProfiles
            .FirstOrDefaultAsync(p => p.UserId == dto.UserId);

        if (existingProfile == null)
        {
            var newProfile = new UserProfile
            {
                Id = Guid.NewGuid(),
                UserId = dto.UserId,
                SleepGoal = dto.SleepGoal,
                PreferredSleepTime = sleepTime,
                PreferredWakeTime = wakeTime
            };
            _context.UserProfiles.Add(newProfile);
        }
        else
        {
            existingProfile.SleepGoal = dto.SleepGoal;
            existingProfile.PreferredSleepTime = sleepTime;
            existingProfile.PreferredWakeTime = wakeTime;
            _context.UserProfiles.Update(existingProfile);
        }

        await _context.SaveChangesAsync();
        return Ok(new { message = "Профіль успішно збережено в базі!" });
    }
}