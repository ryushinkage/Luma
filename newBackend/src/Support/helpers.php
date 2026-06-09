<?php
declare(strict_types=1);

function requestBody(): array
{
    $raw = file_get_contents('php://input') ?: '';
    $decoded = json_decode($raw, true);

    return is_array($decoded) ? $decoded : [];
}

function getUserId(): string
{
    $headers = function_exists('getallheaders') ? getallheaders() : [];
    $value = $headers['X-User-Id'] ?? $headers['x-user-id'] ?? null;

    if (is_string($value) && preg_match('/^[0-9a-fA-F-]{36}$/', $value) === 1) {
        return $value;
    }

    return '11111111-1111-1111-1111-111111111111';
}

function uuidV4(): string
{
    $bytes = random_bytes(16);
    $bytes[6] = chr((ord($bytes[6]) & 0x0f) | 0x40);
    $bytes[8] = chr((ord($bytes[8]) & 0x3f) | 0x80);

    return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($bytes), 4));
}

function utcNow(): string
{
    return gmdate('Y-m-d H:i:sP');
}
