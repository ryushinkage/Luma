using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Luma.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddSleepMetrics : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "SleepMetrics",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    SleepRecordId = table.Column<Guid>(type: "uuid", nullable: false),
                    RegularityScore = table.Column<float>(type: "real", nullable: false),
                    SleepDebtMinutes = table.Column<int>(type: "integer", nullable: false),
                    QualityScore = table.Column<float>(type: "real", nullable: false),
                    EfficiencyScore = table.Column<float>(type: "real", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SleepMetrics", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SleepMetrics_SleepRecords_SleepRecordId",
                        column: x => x.SleepRecordId,
                        principalTable: "SleepRecords",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_SleepMetrics_SleepRecordId",
                table: "SleepMetrics",
                column: "SleepRecordId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "SleepMetrics");
        }
    }
}
