var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

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

app.MapGet("/api/v1/users/count", async (AppDbContext db) =>
{
    var count = await db.Users.CountAsync();
    return Results.Ok(new { count });
});

app.Run();