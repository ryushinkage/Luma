using Luma.Api.Models;

namespace Luma.Api.Data;

public static class DbInitializer
{
    public static void Initialize(AppDbContext context)
    {
        if (context.Users.Any()) return;

        var user = new User
        {
            Id = Guid.NewGuid(),
            Email = "test@luma.com",
            DisplayName = "Kirill User",
            Role = "Student"
        };

        context.Users.Add(user);
        context.SaveChanges();
    }
}