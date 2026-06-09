# Luma PHP Backend

PHP-версия backend API для приложения отслеживания сна.

## Структура

- `index.php` - короткая точка входа для запуска из корня `newBackend`.
- `public/index.php` - основной вход HTTP-запросов.
- `config/config.php` - настройки PostgreSQL и JWT.
- `src/Database.php` - подключение к базе данных.
- `src/DatabaseInitializer.php` - создание таблиц и стартовый пользователь.
- `src/JwtService.php` - генерация JWT.
- `src/Http/Router.php` - маршруты API.
- `src/Http/Response.php` - JSON-ответы.
- `src/Controllers/AuthController.php` - регистрация и вход.
- `src/Controllers/EntriesController.php` - CRUD дневниковых записей.
- `src/Controllers/UsersController.php` - счетчик пользователей.
- `src/Support/helpers.php` - общие функции.

## Основные маршруты

- `POST /api/Auth/register`
- `POST /api/Auth/login`
- `GET /api/v1/users/count`
- `POST /api/v1/entries`
- `GET /api/v1/entries`
- `GET /api/v1/entries/{id}`
- `PUT /api/v1/entries/{id}`
- `DELETE /api/v1/entries/{id}`
