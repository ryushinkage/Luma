# 8. `docs/design/mobile_screens.md`

```md
# Mobile Screens

## 1. Splash Screen

### Purpose

Show premium brand feeling while the app loads.

### Content

- Sleep Analytics logo or moon-like symbol
- dark gradient background
- subtle glow
- short loading state

### Style

Minimal and calm.

Do not overload with text.

---

## 2. Login Screen

### Purpose

Allow the user to sign in with Google.

### Content

- app logo
- headline:
  “Sleep better. Recover smarter.”
- subtitle:
  “AI-powered sleep analytics, recovery insights and personalized sleep coaching.”
- Google sign-in button
- short disclaimer:
  “AI insights are wellness recommendations and do not replace medical advice.”

### Style

Premium landing-like mobile screen.

Use background glow and gradient CTA.

---

## 3. Home Screen

### Purpose

Show the most important daily sleep summary.

### Content

- greeting
- current date
- last sleep summary
- Sleep Score card
- Sleep Duration card
- Recovery card
- Sleep Efficiency card
- AI insight preview
- quick action button: “Add Sleep Entry”

### Main cards

Top summary cards:

- Sleep Score
- Sleep Duration
- Recovery
- Sleep Efficiency

### AI preview example

“Your sleep quality decreased by 11% this week, possibly due to irregular bedtime and increased evening screen time.”

### Style

This screen should feel like the main mobile dashboard.

Keep it clean and scannable.

---

## 4. Add Sleep Entry Screen

### Purpose

Allow quick manual sleep record creation.

### Fields

- Sleep start time
- Wake time
- Sleep quality self-rating
- Stress level
- Caffeine in the evening
- Screen time before bed
- Physical activity
- Mood
- Notes

### Actions

Primary action:

- Save Sleep Entry

Secondary action:

- Cancel

### Validation

Show clear validation messages.

Examples:

- “Wake time must be after sleep start time.”
- “Please select sleep start and wake time.”

### Style

The form should feel simple and fast.

Avoid making the user fill too many required fields.

---

## 5. Sleep History Screen

### Purpose

Show previous sleep records.

### Content

- list of sleep entries
- date
- sleep duration
- quality score
- consistency status
- small trend indicator

### Filters

Optional:

- week
- month
- custom range

### Empty state

“Your sleep history is empty. Add your first sleep entry to start tracking patterns.”

---

## 6. Sleep Entry Details Screen

### Purpose

Show details for one sleep record.

### Content

- date
- bedtime
- wake time
- duration
- quality rating
- sleep efficiency
- behavioral factors
- notes
- AI explanation if available

### Style

Use grouped cards.

---

## 7. Analytics Screen

### Purpose

Show trends and long-term analytics.

### Content

Summary cards:

- Average Sleep Duration
- Sleep Debt
- Consistency
- Recovery
- Sleep Efficiency

Charts or chart placeholders:

- weekly trend
- monthly trend
- sleep phases timeline
- sleep consistency chart
- recovery trend
- habit correlation preview

### Mobile rule

Do not overload this screen.

Show only the most important analytics first.
Move detailed analytics into secondary screens.

---

## 8. AI Coach Screen

### Purpose

Show AI-generated insights and personalized sleep coaching.

### Content

- weekly AI summary
- top recommendations
- risk indicators
- habit explanations
- progress summary
- premium lock state if user is not premium

### Example AI summary

“Your sleep quality decreased by 11% this week. The main factors appear to be irregular bedtime, higher stress level and increased evening screen time.”

### Style

This screen should feel like a smart AI analyst.

It should not look like a chatbot-first interface.

---

## 9. Habits Screen

### Purpose

Track behavioral factors that may affect sleep.

### Content

Habit cards:

- caffeine
- stress
- screen time
- activity
- mood
- late meals
- alcohol placeholder if needed later

### Analytics

Show how habits may correlate with sleep quality.

Example:

“On days with more than 90 minutes of evening screen time, your average sleep quality was lower.”

### Style

Use clear positive/negative indicators.

---

## 10. Reports Screen

### Purpose

Show AI-generated weekly and monthly reports.

### Content

- weekly report card
- monthly report card
- progress tracking
- PDF export card
- premium lock for export if needed

### Report card content

- period
- sleep score change
- consistency change
- main insight
- recommendations count

---

## 11. Goals Screen

### Purpose

Allow user to track sleep improvement goals.

### Goal examples

- bedtime goal
- wake time goal
- recovery target
- sleep consistency goal
- screen time reduction goal
- caffeine reduction goal

### Style

Goals should feel encouraging, not punitive.

---

## 12. Profile Screen

### Purpose

Manage user profile and app settings.

### Content

- user name
- email
- subscription status
- notification settings
- connected integrations
- export data
- privacy
- logout

### Premium status

Show premium status clearly.

Examples:

- Free plan
- Premium active
- Premium expired

---

## 13. Upgrade Screen

### Purpose

Explain Premium value.

### Content

Free:

- Basic metrics
- Limited history
- Basic charts

Premium:

- AI assistant
- Long-term analytics
- Habit correlations
- Smart recommendations
- Report export
- Adaptive coaching

### CTA

- Upgrade to Premium

### Style

Premium but not aggressive.