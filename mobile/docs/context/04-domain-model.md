# 04. Domain model

## Основные сущности

### User
Поля на уровне смысла:
- id;
- email;
- name;
- googleId;
- role;
- subscriptionStatus;
- createdAt;
- updatedAt.

Роли:
- User;
- Admin.

### SleepRecord
Запись сна пользователя.

Смысловые поля:
- id;
- userId;
- sleepStart;
- sleepEnd;
- durationMinutes;
- subjectiveQuality;
- sleepEfficiency;
- lightSleepMinutes;
- deepSleepMinutes;
- remSleepMinutes;
- awakeMinutes;
- source;
- createdAt;
- updatedAt.

Фазы сна могут быть null, если пользователь вводит запись вручную и нет источника данных.

### PhysiologicalMetrics
Физиологические показатели, если доступны:
- id;
- sleepRecordId или userId + date;
- averageHeartRate;
- nightHeartRate;
- spo2;
- bloodPressureSystolic;
- bloodPressureDiastolic;
- createdAt.

Эти данные optional.

### BehaviorFactor / DailyFactor
Поведенческие факторы:
- id;
- userId;
- date;
- caffeineLevel или caffeineAmount;
- physicalActivity;
- stressLevel;
- mood;
- eveningScreenTime;
- notes;
- createdAt;
- updatedAt.

### AnalyticsResult
Расчётная аналитика:
- id;
- userId;
- periodType: day/week/month/quarter;
- periodStart;
- periodEnd;
- averageSleepDuration;
- averageSleepQuality;
- regularityScore;
- sleepDebt;
- sleepEfficiency;
- riskIndicators;
- insights;
- createdAt.

### AiReport
AI-отчёт:
- id;
- userId;
- periodType;
- periodStart;
- periodEnd;
- summary;
- keyInsights;
- recommendations;
- actionPlan;
- createdAt.

### Subscription
Подписка:
- id;
- userId;
- provider: PayPal;
- status;
- plan;
- startedAt;
- expiresAt;
- createdAt;
- updatedAt.

## Важные связи

- User 1 → many SleepRecord
- User 1 → many DailyFactor
- User 1 → many AiReport
- User 1 → many AnalyticsResult
- User 1 → 0..1 active Subscription
- SleepRecord 1 → 0..1 PhysiologicalMetrics

## Важное ограничение

Это смысловая модель, а не финальная SQL-схема. При реализации можно уточнять названия полей, но нельзя ломать основные сущности и связи без отдельного решения.
