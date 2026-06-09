<?php
declare(strict_types=1);

namespace Luma\Controllers;

use Luma\Http\Response;
use Luma\JwtService;
use PDO;

final class AuthController
{
    public function __construct(
        private readonly PDO $pdo,
        private readonly array $jwtConfig
    ) {
    }

    public function register(): void
    {
        $body = requestBody();
        $email = strtolower(trim((string)($body['email'] ?? $body['Email'] ?? '')));
        $password = (string)($body['password'] ?? $body['Password'] ?? '');
        $displayName = trim((string)($body['displayName'] ?? $body['DisplayName'] ?? ''));

        if ($email === '' || $password === '' || $displayName === '') {
            Response::json(['error' => 'Email, password and displayName are required.'], 400);
            return;
        }

        $statement = $this->pdo->prepare('SELECT 1 FROM "Users" WHERE lower("Email") = :email LIMIT 1');
        $statement->execute(['email' => $email]);

        if ($statement->fetchColumn() !== false) {
            Response::json('Користувач з таким Email вже існує.', 400);
            return;
        }

        $statement = $this->pdo->prepare(
            'INSERT INTO "Users" ("Id", "Email", "DisplayName", "PasswordHash", "CreatedAtUtc", "Role")
             VALUES (:id, :email, :displayName, :passwordHash, :createdAtUtc, :role)'
        );

        $statement->execute([
            'id' => uuidV4(),
            'email' => $email,
            'displayName' => $displayName,
            'passwordHash' => password_hash($password, PASSWORD_BCRYPT),
            'createdAtUtc' => utcNow(),
            'role' => 'User',
        ]);

        Response::json('Реєстрація успішна!');
    }

    public function login(): void
    {
        $body = requestBody();
        $email = strtolower(trim((string)($body['email'] ?? $body['Email'] ?? '')));
        $password = (string)($body['password'] ?? $body['Password'] ?? '');

        $statement = $this->pdo->prepare('SELECT * FROM "Users" WHERE lower("Email") = :email LIMIT 1');
        $statement->execute(['email' => $email]);
        $user = $statement->fetch();

        if (!$user || !password_verify($password, (string)$user['PasswordHash'])) {
            Response::json('Невірний Email або пароль.', 401);
            return;
        }

        $token = (new JwtService($this->jwtConfig))->create([
            'nameid' => $user['Id'],
            'email' => $user['Email'],
            'role' => $user['Role'],
            'displayName' => $user['DisplayName'],
        ]);

        Response::json([
            'Token' => $token,
            'Message' => 'Вхід успішний!',
        ]);
    }
}
