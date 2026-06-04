# Auth backend connection

Текущая авторизация в mobile app настроена под простой email/password flow.
Google OAuth временно не используется.

## Где подключено

Точка сборки зависимостей:

`lib/app/router.dart`

Auth screen получает:

```dart
AuthController(
  authRepository: BackendAuthRepository(
    apiClient: _buildApiClient(),
    tokenStorage: _tokenStorage,
  ),
)
```

`_buildApiClient()` создаёт `HttpApiClient`, который отправляет JSON-запросы на
backend и добавляет `Authorization: Bearer ...`, если token уже сохранён.

## Base URL

Базовый URL берётся из:

`lib/core/network/api_config.dart`

Сейчас:

```dart
class ApiConfig {
  static const String baseUrl = 'https://thermal-math-anywhere.ngrok-free.dev';
}
```

Для запуска с другим backend можно передать:

```bash
flutter run --dart-define=API_BASE_URL=https://your-backend.example.com
```

Для Android emulator локальный backend обычно указывается так:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

## Endpoints

Пути находятся в:

`lib/core/network/api_endpoints.dart`

| Flow | Method | Endpoint |
| --- | --- | --- |
| Login | `POST` | `/api/auth/login` |
| Register | `POST` | `/api/auth/register` |
| Registration onboarding profile | `POST` | `/api/users/me/onboarding-profile` |
| Logout | `POST` | `/api/auth/logout` |

## Login request

```json
{
  "email": "user@example.com",
  "password": "password"
}
```

## Register request

```json
{
  "email": "user@example.com",
  "password": "password"
}
```

После успешной регистрации mobile показывает два onboarding шага:

1. Обычное время засыпания и пробуждения.
2. Цель улучшения сна.

Кофеин в регистрацию не отправляется. Он относится к daily behavior factors и
заполняется при создании записи сна.

## Onboarding profile request

`POST /api/users/me/onboarding-profile`

```json
{
  "usualSleepTimeMinutes": 1380,
  "usualWakeTimeMinutes": 420,
  "improvementGoal": "Стабилизировать режим сна"
}
```

Этот запрос должен быть защищённым. `HttpApiClient` отправит:

```http
Authorization: Bearer jwt-access-token
```

## Auth response

Backend должен вернуть JSON object с токеном.

Для login токен обязателен. Основной ожидаемый формат:

```json
{
  "accessToken": "jwt-access-token"
}
```

Также mobile сейчас принимает поле `token`, если backend возвращает короткое имя:

```json
{
  "token": "jwt-access-token"
}
```

Опциональные поля можно вернуть сразу, mobile их не ломает:

```json
{
  "accessToken": "jwt-access-token",
  "refreshToken": "refresh-token",
  "userId": "user-id"
}
```

`accessToken` сохраняется через `SecureTokenStorage`.

Для register токен сейчас опционален: если backend вернул `accessToken` или
`token`, mobile сохранит его; если ответ пустой, текстовый или без токена,
mobile всё равно перейдёт к onboarding шагам. Если
`/api/users/me/onboarding-profile` защищён, backend должен вернуть токен уже на
регистрации или onboarding-запрос не сможет пройти авторизацию.

## Что делает mobile code

- `HttpApiClient` отправляет `GET`, `POST`, `PUT` JSON-запросы.
- `BackendAuthRepository` вызывает login/register/onboarding/logout endpoints.
- `AuthSessionResponse` читает `accessToken` или `token`.
- `OnboardingProfileRequest` мапит данные регистрации в backend payload.
- UI не вызывает backend напрямую.

## Ошибки

`HttpApiClient` бросает `ApiRequestFailure`, если:

- backend вернул HTTP 4xx/5xx;
- ответ не является JSON object;
- auth response не содержит `accessToken` или `token`;
- сеть недоступна.

`AuthController` переводит это в failure state, а экран показывает ошибку.
