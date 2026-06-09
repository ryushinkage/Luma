<?php
declare(strict_types=1);

namespace Luma\Http;

use Luma\Controllers\AuthController;
use Luma\Controllers\EntriesController;
use Luma\Controllers\UsersController;
use PDO;

final class Router
{
    public static function dispatch(PDO $pdo, array $config): void
    {
        $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
        $path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
        $path = rtrim($path, '/') ?: '/';

        $authController = new AuthController($pdo, $config['jwt']);
        $entriesController = new EntriesController($pdo);
        $usersController = new UsersController($pdo);

        if ($method === 'POST' && $path === '/api/Auth/register') {
            $authController->register();
            return;
        }

        if ($method === 'POST' && $path === '/api/Auth/login') {
            $authController->login();
            return;
        }

        if ($method === 'GET' && $path === '/api/v1/users/count') {
            $usersController->count();
            return;
        }

        if ($path === '/api/v1/entries') {
            match ($method) {
                'POST' => $entriesController->create(),
                'GET' => $entriesController->all(),
                default => Response::json(['error' => 'Method not allowed'], 405),
            };
            return;
        }

        if (preg_match('#^/api/v1/entries/([0-9a-fA-F-]{36})$#', $path, $matches) === 1) {
            match ($method) {
                'GET' => $entriesController->find($matches[1]),
                'PUT' => $entriesController->update($matches[1]),
                'DELETE' => $entriesController->delete($matches[1]),
                default => Response::json(['error' => 'Method not allowed'], 405),
            };
            return;
        }

        Response::json(['error' => 'Not found'], 404);
    }
}
