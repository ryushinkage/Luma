using Luma.Api.Models;
using Luma.Api.Data;
using Microsoft.EntityFrameworkCore;
using System.Linq;

Guid GetUserId(HttpContext http)
{
    if (http.Request.Headers.TryGetValue("X-User-Id", out var values) &&
        Guid.TryParse(values.FirstOrDefault(), out var userId))
        return userId;

    return Guid.Parse("11111111-1111-1111-1111-111111111111");
}


var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
var connectionString = builder.Configuration.GetConnectionString("Default")
                       ?? throw new InvalidOperationException("Connection string 'Default' not found.");

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString));


var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet("/health", () =>
{
    return Results.Ok(new { status = "Luma API is running" });
});

app.MapPost("/api/v1/entries", async (HttpContext http, AppDbContext db, JournalEntry entry) =>
{
    entry.UserId = GetUserId(http);
    entry.Id = Guid.NewGuid();
    entry.CreatedAtUtc = DateTime.UtcNow;

    db.JournalEntries.Add(entry);
    await db.SaveChangesAsync();

    return Results.Created($"/api/v1/entries/{entry.Id}", entry);
});


app.MapGet("/api/v1/entries", async (HttpContext http, AppDbContext db) =>
{
    var userId = GetUserId(http);

    var items = await db.JournalEntries
        .Where(x => x.UserId == userId)
        .OrderByDescending(x => x.CreatedAtUtc)
        .Take(50)
        .ToListAsync();

    return Results.Ok(items);
});


app.MapGet("/api/v1/entries/{id:guid}", async (HttpContext http, AppDbContext db, Guid id) =>
{
    var userId = GetUserId(http);

    var item = await db.JournalEntries.FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId);
    return item is null ? Results.NotFound() : Results.Ok(item);
});


app.MapPut("/api/v1/entries/{id:guid}", async (HttpContext http, AppDbContext db, Guid id, JournalEntry updated) =>
{
    var userId = GetUserId(http);

    var item = await db.JournalEntries.FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId);
    if (item is null) return Results.NotFound();

    item.Content = updated.Content;
    item.Mood = updated.Mood;
    item.UpdatedAtUtc = DateTime.UtcNow;

    await db.SaveChangesAsync();
    return Results.Ok(item);
});


app.MapDelete("/api/v1/entries/{id:guid}", async (HttpContext http, AppDbContext db, Guid id) =>
{
    var userId = GetUserId(http);

    var item = await db.JournalEntries.FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId);
    if (item is null) return Results.NotFound();

    db.JournalEntries.Remove(item);
    await db.SaveChangesAsync();
    return Results.NoContent();
});



app.MapGet("/api/v1/users/count", async (AppDbContext db) =>
{
    var count = await db.Users.CountAsync();
    return Results.Ok(new { count });
});

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var context = services.GetRequiredService<AppDbContext>();
    context.Database.EnsureCreated(); // Створює базу, якщо її немає
    DbInitializer.Initialize(context); // Додає тестового юзера
}

app.Run();