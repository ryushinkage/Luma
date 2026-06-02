using Luma.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Luma.Api.Controllers;

[ApiController]
[Route("api/v1/users")]
public class UsersController : ControllerBase
{
    private readonly AppDbContext _db;
    public UsersController(AppDbContext db) => _db = db;

    [HttpGet("count")]
    public async Task<ActionResult> GetCount()
    {
        var count = await _db.Users.CountAsync();
        return Ok(new { count });
    }
}