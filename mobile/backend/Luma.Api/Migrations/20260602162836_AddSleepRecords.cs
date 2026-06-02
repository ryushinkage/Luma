using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Luma.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddSleepRecords : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Role",
                table: "Users",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "SleepRecords",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    SleepDate = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    SleepStart = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    SleepEnd = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    DurationMinutes = table.Column<int>(type: "integer", nullable: false),
                    SleepEfficiency = table.Column<float>(type: "real", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SleepRecords", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SleepRecords_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_SleepRecords_UserId_SleepDate",
                table: "SleepRecords",
                columns: new[] { "UserId", "SleepDate" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "SleepRecords");

            migrationBuilder.DropColumn(
                name: "Role",
                table: "Users");
        }
    }
}
