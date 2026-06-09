<?php
declare(strict_types=1);

namespace Luma;

use PDO;

final class DatabaseInitializer
{
    public static function initialize(PDO $pdo): void
    {
        self::createTables($pdo);
        self::seedUser($pdo);
    }

    private static function createTables(PDO $pdo): void
    {
        $pdo->exec('CREATE TABLE IF NOT EXISTS "Users" (
            "Id" uuid PRIMARY KEY,
            "Email" varchar(320) NOT NULL UNIQUE,
            "DisplayName" varchar(200) NOT NULL,
            "PasswordHash" varchar(500) NOT NULL,
            "CreatedAtUtc" timestamptz NOT NULL,
            "Role" varchar(50) NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "JournalEntries" (
            "Id" uuid PRIMARY KEY,
            "UserId" uuid NOT NULL,
            "Content" varchar(10000) NOT NULL,
            "Mood" integer NOT NULL,
            "CreatedAtUtc" timestamptz NOT NULL,
            "UpdatedAtUtc" timestamptz NULL
        )');

        $pdo->exec('CREATE INDEX IF NOT EXISTS "IX_JournalEntries_UserId_CreatedAtUtc"
            ON "JournalEntries" ("UserId", "CreatedAtUtc")');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "SleepRecords" (
            "Id" uuid PRIMARY KEY,
            "UserId" uuid NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
            "SleepDate" timestamptz NOT NULL,
            "SleepStart" timestamptz NOT NULL,
            "SleepEnd" timestamptz NOT NULL,
            "DurationMinutes" integer NOT NULL,
            "SleepEfficiency" real NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "UserProfiles" (
            "Id" uuid PRIMARY KEY,
            "UserId" uuid NOT NULL UNIQUE REFERENCES "Users"("Id") ON DELETE CASCADE,
            "SleepGoal" varchar(300) NOT NULL,
            "PreferredSleepTime" interval NOT NULL,
            "PreferredWakeTime" interval NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "SleepFactors" (
            "Id" uuid PRIMARY KEY,
            "SleepRecordId" uuid NOT NULL REFERENCES "SleepRecords"("Id") ON DELETE CASCADE,
            "Caffeine" boolean NOT NULL,
            "StressLevel" integer NOT NULL,
            "ScreenTimeMinutes" integer NOT NULL,
            "PhysicalActivityMinutes" integer NOT NULL,
            "Notes" varchar(500) NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "SleepMetrics" (
            "Id" uuid PRIMARY KEY,
            "SleepRecordId" uuid NOT NULL UNIQUE REFERENCES "SleepRecords"("Id") ON DELETE CASCADE,
            "RegularityScore" real NOT NULL,
            "SleepDebtMinutes" integer NOT NULL,
            "QualityScore" real NOT NULL,
            "EfficiencyScore" real NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "NotificationSettings" (
            "Id" uuid PRIMARY KEY,
            "UserId" uuid NOT NULL UNIQUE REFERENCES "Users"("Id") ON DELETE CASCADE,
            "PushEnabled" boolean NOT NULL,
            "ReminderTime" interval NOT NULL,
            "SmartRemindersEnabled" boolean NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "Subscriptions" (
            "Id" uuid PRIMARY KEY,
            "UserId" uuid NOT NULL UNIQUE REFERENCES "Users"("Id") ON DELETE CASCADE,
            "PlanType" text NOT NULL,
            "Status" text NOT NULL,
            "ExpiresAt" timestamptz NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "AIReports" (
            "Id" uuid PRIMARY KEY,
            "UserId" uuid NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
            "PeriodStart" timestamptz NOT NULL,
            "PeriodEnd" timestamptz NOT NULL,
            "Summary" text NOT NULL,
            "Insights" text NOT NULL,
            "GeneratedAt" timestamptz NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "Recommendations" (
            "Id" uuid PRIMARY KEY,
            "ReportId" uuid NOT NULL REFERENCES "AIReports"("Id") ON DELETE CASCADE,
            "Title" text NOT NULL,
            "Description" text NOT NULL,
            "Type" text NOT NULL,
            "Priority" integer NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "RiskIndicators" (
            "Id" uuid PRIMARY KEY,
            "ReportId" uuid NOT NULL REFERENCES "AIReports"("Id") ON DELETE CASCADE,
            "RiskType" text NOT NULL,
            "Description" text NOT NULL,
            "Level" text NOT NULL
        )');

        $pdo->exec('CREATE TABLE IF NOT EXISTS "RecommendationRules" (
            "Id" uuid PRIMARY KEY,
            "Condition" text NOT NULL,
            "Action" text NOT NULL,
            "Active" boolean NOT NULL
        )');
    }

    private static function seedUser(PDO $pdo): void
    {
        $count = (int)$pdo->query('SELECT COUNT(*) FROM "Users"')->fetchColumn();
        if ($count > 0) {
            return;
        }

        $statement = $pdo->prepare(
            'INSERT INTO "Users" ("Id", "Email", "DisplayName", "PasswordHash", "CreatedAtUtc", "Role")
             VALUES (:id, :email, :displayName, :passwordHash, :createdAtUtc, :role)'
        );

        $statement->execute([
            'id' => uuidV4(),
            'email' => 'test@luma.com',
            'displayName' => 'Kirill User',
            'passwordHash' => password_hash('password', PASSWORD_BCRYPT),
            'createdAtUtc' => utcNow(),
            'role' => 'Student',
        ]);
    }
}
