<?php
declare(strict_types=1);

namespace Luma\Controllers;

use Luma\Http\Response;
use PDO;

final class UsersController
{
    public function __construct(private readonly PDO $pdo)
    {
    }

    public function count(): void
    {
        $count = (int)$this->pdo->query('SELECT COUNT(*) FROM "Users"')->fetchColumn();
        Response::json(['count' => $count]);
    }
}
