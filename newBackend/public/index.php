<?php
declare(strict_types=1);

use Luma\Database;
use Luma\DatabaseInitializer;
use Luma\Http\Router;
use Luma\Http\Response;

require __DIR__ . '/../src/Support/helpers.php';
require __DIR__ . '/../src/Database.php';
require __DIR__ . '/../src/DatabaseInitializer.php';
require __DIR__ . '/../src/JwtService.php';
require __DIR__ . '/../src/Http/Response.php';
require __DIR__ . '/../src/Http/Router.php';
require __DIR__ . '/../src/Controllers/AuthController.php';
require __DIR__ . '/../src/Controllers/EntriesController.php';
require __DIR__ . '/../src/Controllers/UsersController.php';

header('Content-Type: application/json; charset=utf-8');

try {
    $config = require __DIR__ . '/../config/config.php';
    $pdo = Database::connect($config['database']);

    DatabaseInitializer::initialize($pdo);
    Router::dispatch($pdo, $config);
} catch (Throwable $exception) {
    Response::json([
        'error' => 'Internal server error',
        'details' => $exception->getMessage(),
    ], 500);
}
