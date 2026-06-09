<?php
declare(strict_types=1);

return [
    'database' => [
        'dsn' => 'pgsql:host=localhost;port=5433;dbname=luma',
        'user' => 'luma',
        'password' => 'luma',
    ],
    'jwt' => [
        'secret' => 'SUPER_SECRET_KEY_LUMA_DIARY_PROJECT_2026_LONG_STRING',
        'issuer' => 'Luma.Api',
        'audience' => 'Luma.Frontend',
        'ttl' => 7 * 24 * 60 * 60,
    ],
];
