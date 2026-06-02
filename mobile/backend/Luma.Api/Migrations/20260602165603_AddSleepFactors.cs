using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Luma.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddSleepFactors : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "SleepFactors",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    SleepRecordId = table.Column<Guid>(type: "uuid", nullable: false),
                    Caffeine = table.Column<bool>(type: "boolean", nullable: false),
                    StressLevel = table.Column<int>(type: "integer", nullable: false),
                    ScreenTimeMinutes = table.Column<int>(type: "integer", nullable: false),
                    PhysicalActivityMinutes = table.Column<int>(type: "integer", nullable: false),
                    Notes = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SleepFactors", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SleepFactors_SleepRecords_SleepRecordId",
                        column: x => x.SleepRecordId,
                        principalTable: "SleepRecords",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_SleepFactors_SleepRecordId",
                table: "SleepFactors",
                column: "SleepRecordId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "SleepFactors");
        }
    }
}
