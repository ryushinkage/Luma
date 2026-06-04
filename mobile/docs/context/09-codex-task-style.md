# 09. How Codex should work with this project

## Перед выполнением задачи

Codex должен:
1. прочитать `AGENTS.md`;
2. открыть релевантные файлы в `docs/context`;
3. проверить существующую структуру проекта;
4. не переписывать архитектуру без необходимости;
5. вносить минимальные понятные изменения.

## Если задача большая

Разбивать на шаги:
1. какие файлы надо изменить;
2. какая бизнес-логика затрагивается;
3. какие риски есть;
4. какие тесты/проверки нужны.

## Если информации не хватает

Не выдумывать. Использовать:
- TODO;
- комментарий;
- короткий вопрос пользователю.

## Стиль кода

- Следовать уже существующей структуре проекта.
- Не менять стек.
- Не добавлять лишние библиотеки без причины.
- Не смешивать web/mobile/backend в одном изменении, если задача касается только одной части.
- Для API учитывать REST.
- Для Premium-функций всегда проверять статус подписки.
- Для пользовательских данных всегда учитывать userId/ownership.

## Типовые команды для пользователя

Перед задачей в Codex можно писать:

> Сначала прочитай `AGENTS.md` и все релевантные файлы из `docs/context`. Задача касается [mobile/web/backend]. Не придумывай новый стек и не меняй архитектуру без необходимости.

Для backend:

> Сначала прочитай `AGENTS.md`, `docs/context/03-backend-requirements.md`, `docs/context/04-domain-model.md`, `docs/context/05-data-and-analytics.md`, `docs/context/07-business-rules.md`. Потом предложи минимальный план изменений и только после этого меняй код.

Для mobile:

> Сначала прочитай `AGENTS.md`, `docs/context/02-mobile-requirements.md`, `docs/context/05-data-and-analytics.md`, `docs/context/06-ai-assistant-and-premium.md`. Делай Flutter-реализацию без изменения backend-контрактов, если это не требуется.

Для web:

> Сначала прочитай `AGENTS.md`, `docs/context/02-web-requirements.md`, `docs/context/05-data-and-analytics.md`, `docs/context/06-ai-assistant-and-premium.md`. Учитывай premium dark SaaS стиль и продуктовую логику Sleep Analytics.
