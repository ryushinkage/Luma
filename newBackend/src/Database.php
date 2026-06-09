<?php
declare(strict_types=1);

namespace Luma;

use PDO;

final class Database
{
    public static function connect(array $config): PDO
    {
        return new PDO($config['dsn'], $config['user'], $config['password'], [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
    }
}
