using Luma.Api.Data;
using Microsoft.EntityFrameworkCore;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// =========================================================================
// 1. НАЛАШТУВАННЯ СЕРВІСІВ (builder.Services)
// =========================================================================

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpClient();

// Налаштування CORS (Дозволяємо сайту Дмитра та іншим фронтендам слати запити)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllFrontend", policy =>
    {
        policy.AllowAnyOrigin()   // Дозволяє запити з будь-якого сайту (включаючи localhost:5173 Дмитра)
              .AllowAnyHeader()   // Дозволяє будь-які заголовки (Content-Type, Authorization тощо)
              .AllowAnyMethod()   // Дозволяє POST, GET, PUT, DELETE та головне — OPTIONS!
              .SetPreflightMaxAge(TimeSpan.FromMinutes(10)); // Кешує preflight-запити
    });
});

// Підключення до бази даних PostgreSQL
var connectionString = builder.Configuration.GetConnectionString("Default")
                        ?? throw new InvalidOperationException("Connection string 'Default' not found.");

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString));

// Налаштування JWT Авторизації
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var secretKey = jwtSettings["Secret"]
                ?? throw new InvalidOperationException("JWT Secret Key not found in appsettings.");

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["Issuer"],
        ValidAudience = jwtSettings["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey))
    };
});

var app = builder.Build();

// =========================================================================
// 2. НАЛАШТУВАННЯ МІДЛВАРЕ (Порядок викликів має критичне значення!)
// =========================================================================

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// КРИТИЧНО: Спочатку обробляємо CORS (і OPTIONS-запити), і тільки потім усе інше!
app.UseCors("AllowAllFrontend");

app.UseHttpsRedirection();

app.UseRouting(); // Додаємо явну маршрутизацію перед авторизацією

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// Ініціалізація та сидінг бази даних
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var context = services.GetRequiredService<AppDbContext>();
    context.Database.EnsureCreated();
    DbInitializer.Initialize(context);
}

app.Run();