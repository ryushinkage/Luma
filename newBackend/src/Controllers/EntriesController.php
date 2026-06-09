<?php
declare(strict_types=1);

namespace Luma\Controllers;

use Luma\Http\Response;
use PDO;

final class EntriesController
{
    public function __construct(private readonly PDO $pdo)
    {
    }

    public function create(): void
    {
        $body = requestBody();
        $entry = [
            'Id' => uuidV4(),
            'UserId' => getUserId(),
            'Content' => (string)($body['content'] ?? $body['Content'] ?? ''),
            'Mood' => (int)($body['mood'] ?? $body['Mood'] ?? 0),
            'CreatedAtUtc' => utcNow(),
            'UpdatedAtUtc' => null,
        ];

        $statement = $this->pdo->prepare(
            'INSERT INTO "JournalEntries" ("Id", "UserId", "Content", "Mood", "CreatedAtUtc", "UpdatedAtUtc")
             VALUES (:Id, :UserId, :Content, :Mood, :CreatedAtUtc, :UpdatedAtUtc)'
        );
        $statement->execute($entry);

        Response::json($entry, 201, ['Location' => '/api/v1/entries/' . $entry['Id']]);
    }

    public function all(): void
    {
        $statement = $this->pdo->prepare(
            'SELECT "Id", "UserId", "Content", "Mood", "CreatedAtUtc", "UpdatedAtUtc"
             FROM "JournalEntries"
             WHERE "UserId" = :userId
             ORDER BY "CreatedAtUtc" DESC
             LIMIT 50'
        );
        $statement->execute(['userId' => getUserId()]);

        Response::json($statement->fetchAll());
    }

    public function find(string $id): void
    {
        $entry = $this->findEntry($id);
        $entry ? Response::json($entry) : Response::json(null, 404);
    }

    public function update(string $id): void
    {
        $entry = $this->findEntry($id);
        if (!$entry) {
            Response::json(null, 404);
            return;
        }

        $body = requestBody();
        $entry['Content'] = (string)($body['content'] ?? $body['Content'] ?? $entry['Content']);
        $entry['Mood'] = (int)($body['mood'] ?? $body['Mood'] ?? $entry['Mood']);
        $entry['UpdatedAtUtc'] = utcNow();

        $statement = $this->pdo->prepare(
            'UPDATE "JournalEntries"
             SET "Content" = :Content, "Mood" = :Mood, "UpdatedAtUtc" = :UpdatedAtUtc
             WHERE "Id" = :Id AND "UserId" = :UserId'
        );
        $statement->execute([
            'Content' => $entry['Content'],
            'Mood' => $entry['Mood'],
            'UpdatedAtUtc' => $entry['UpdatedAtUtc'],
            'Id' => $entry['Id'],
            'UserId' => $entry['UserId'],
        ]);

        Response::json($entry);
    }

    public function delete(string $id): void
    {
        $entry = $this->findEntry($id);
        if (!$entry) {
            Response::json(null, 404);
            return;
        }

        $statement = $this->pdo->prepare('DELETE FROM "JournalEntries" WHERE "Id" = :id AND "UserId" = :userId');
        $statement->execute(['id' => $id, 'userId' => getUserId()]);

        Response::json(null, 204);
    }

    private function findEntry(string $id): array|false
    {
        $statement = $this->pdo->prepare(
            'SELECT "Id", "UserId", "Content", "Mood", "CreatedAtUtc", "UpdatedAtUtc"
             FROM "JournalEntries"
             WHERE "Id" = :id AND "UserId" = :userId
             LIMIT 1'
        );
        $statement->execute(['id' => $id, 'userId' => getUserId()]);

        return $statement->fetch();
    }
}
