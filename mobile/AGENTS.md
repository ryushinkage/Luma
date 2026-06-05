# AGENTS.md

## Project

This is the Flutter mobile application for the Sleep Analytics project.

The product is a mobile and web platform for long-term sleep analytics, sleep habit tracking, AI-generated recommendations, and premium sleep-coaching reports.

The mobile app should support:
- Google OAuth authorization.
- Quick creation of sleep records.
- Viewing sleep statistics.
- Viewing AI recommendations and reports.
- Push reminder support.
- User profile management.
- Premium subscription flow preparation.

Backend stack:
- ASP.NET Core REST API.
- PostgreSQL database.
- Google OAuth.
- PayPal for paid subscription.
- AI API for recommendations.

Mobile stack:
- Flutter.
- Dart.
- REST API integration.
- Clean architecture style.
- Feature-based folder structure.

## Main product direction

The app should feel like a combination of:

- premium AI SaaS product;
- health-tech analytics system;
- modern wellness platform;
- polished data dashboard.

The mobile app must not feel like:

- a simple alarm app;
- an old fitness tracker;
- a corporate medical system;
- a colorful crypto dashboard.

## Important documentation

Before implementing UI, read the relevant files from `docs/design/`.

Use these files as the source of truth until a finalized Figma design exists:

- `docs/design/README.md`
- `docs/design/visual_direction.md`
- `docs/design/design_tokens.md`
- `docs/design/mobile_navigation.md`
- `docs/design/mobile_screens.md`
- `docs/design/mobile_components.md`
- `docs/design/ai_assistant_ui.md`

For product and safety logic, use:

- `docs/product/product_overview.md`
- `docs/product/safety_rules.md`

For working process, use:

- `docs/codex/task_workflow.md`
- `docs/codex/prompt_examples.md`

## UI rules

The UI must be:

- dark theme only;
- premium;
- futuristic but calm;
- minimalistic but polished;
- spacious;
- based on rounded cards;
- based on soft glow and glassmorphism elements;
- focused on analytics, insights and sleep coaching.

Use this main gradient for CTA and AI-related elements:

`linear-gradient(135deg, #7C5CFF 0%, #4DA8FF 100%)`

## Flutter rules

- Use Material 3.
- Prefer reusable widgets.
- Keep widgets small and readable.
- Do not put business logic inside widgets.
- Do not call API directly from UI widgets.
- Use feature-based structure.
- Avoid unnecessary dependencies.
- Do not add chart libraries unless explicitly requested.
- If charts are needed before a chart library is approved, create clean placeholder widgets.

## Language and communication

Explain important decisions in Russian.
Code, class names, variables, folders and comments should be in English.

## Architecture rules

Use a feature-based structure:

lib/
  app/
  core/
  features/
  shared/

Each feature should be split into:
- data
- domain
- presentation

Use simple clean architecture, but do not over-engineer.

Prefer this flow:
UI widget -> state/controller -> repository -> api client -> backend.

Do not put direct HTTP calls inside widgets.

Do not put business logic inside UI widgets.

## Flutter rules

Use Material 3.
Keep UI clean, calm, minimal and health-oriented.
Prefer reusable widgets.
Avoid huge widgets.
Split files when a widget becomes too large.
Use named routes or a centralized router.
Use responsive layouts where possible.

## State management

Use a simple and consistent state management approach.
If the project has no existing state management yet, prefer Riverpod.
Do not mix multiple state management libraries without a strong reason.

## Networking

All backend communication must go through core/network/api_client.dart.

Use typed request and response models.
Handle errors explicitly.
Do not silently ignore failed API calls.
Add placeholders when backend endpoints are not ready yet.

## Authentication

Authentication should be prepared for Google OAuth.
Do not hardcode tokens.
Store tokens through a token storage abstraction.
Do not store secrets in the repository.

## Product rules

Free users can access:
- Basic daily sleep metrics.
- Simple charts.
- Limited history.

Premium users can access:
- Long-term trends.
- AI assistant.
- Habit-to-sleep-quality correlations.
- Smart reminders and goals.
- Extended history.
- Export reports.

## Medical safety

The app is not a medical diagnosis tool.
AI recommendations must be framed as wellness/sleep-coaching suggestions.
Risk indicators may warn about patterns such as chronic sleep deficit, irregular schedule, low sleep efficiency, stress or fatigue signs.
Do not present AI output as a doctor diagnosis.

## Code quality

Before finishing a task:
- Run `flutter analyze`.
- Run relevant tests if tests exist.
- Keep changes focused.
- Do not reformat unrelated files.
- Do not add production dependencies without explaining why.

## Git rules

Work in small changes.
Prefer one feature per branch.
Do not commit secrets.
Do not change backend contracts unless explicitly asked.
If an API endpoint is missing, create a clearly marked mock or TODO abstraction instead of inventing final backend behavior.

## Testing

Add unit tests for:
- Models.
- Mappers.
- Repositories where possible.
- Sleep duration calculations.
- Sleep regularity calculations.

For UI, add widget tests for important screens when practical.

## Naming

Use clear English names:
- SleepEntry
- SleepMetric
- SleepQualityScore
- SleepRecommendation
- AiReport
- SubscriptionPlan
- UserProfile

## Обязательные правила для Codex

1. Перед любой задачей по проекту сначала прочитать файлы из `docs/context`.
2. Не считать продукт обычным sleep tracker. Это AI-driven sleep analytics / sleep-coaching платформа.
3. Не придумывать стек, роли, платежи, AI-функции или сущности, если они уже описаны в документах.
4. Если задача касается мобильного приложения — сначала читать:
   - `docs/context/01-product-overview.md`
   - `docs/context/02-mobile-requirements.md`
   - `docs/context/05-data-and-analytics.md`
   - `docs/context/06-ai-assistant-and-premium.md`
5. Если задача касается backend — сначала читать:
   - `docs/context/01-product-overview.md`
   - `docs/context/03-backend-requirements.md`
   - `docs/context/04-domain-model.md`
   - `docs/context/05-data-and-analytics.md`
   - `docs/context/07-business-rules.md`
6. Если задача касается web — сначала читать:
   - `docs/context/01-product-overview.md`
   - `docs/context/02-web-requirements.md`
   - `docs/context/05-data-and-analytics.md`
   - `docs/context/06-ai-assistant-and-premium.md`
7. Если задача касается архитектуры/UML — читать `docs/context/08-diagrams.md` и draw.io файлы в `docs/context/diagrams`.
8. Не добавлять врачей, консультантов или внешних медицинских специалистов: персональный сопровождатель в проекте — AI-ассистент.
9. Не позиционировать систему как медицинскую диагностику. Разрешённый формат: мониторинг, индикаторы риска, предупреждения, рекомендации по sleep hygiene и sleep-coaching.
10. При нехватке информации не выдумывать, а оставить TODO/вопрос.


Avoid unclear abbreviations.