# 7. `docs/design/mobile_navigation.md`

```md
# Mobile Navigation

## Main navigation pattern

Use bottom navigation for the main mobile app.

Main tabs:

1. Home
2. Sleep
3. Analytics
4. AI Coach
5. Profile

## Tab purposes

### Home

Daily overview and main insight.

### Sleep

Sleep records, quick add, sleep history.

### Analytics

Trends, charts, correlations and recovery analytics.

### AI Coach

AI-generated insights, recommendations, weekly summaries and premium coaching.

### Profile

User info, subscription status, settings, notifications and logout.

## Secondary screens

Secondary screens should open from main tabs.

Examples:

- Add Sleep Entry
- Sleep Entry Details
- Weekly Report Details
- Goal Details
- Notification Settings
- Subscription Upgrade
- Export Report

## Navigation behavior

The bottom navigation should stay visible on main screens.

For forms and detail screens, use a top app bar with back navigation.

## Main user flow

Recommended MVP flow:

```text
Splash
  -> Login
  -> Home
      -> Add Sleep Entry
      -> AI Insight Details
      -> Weekly Report
Premium flow

When a free user opens premium functionality:

Premium locked card
  -> Upgrade screen
  -> Subscription info

Premium features:

AI Coach full access;
long-term analytics;
habit correlations;
smart recommendations;
report export;
extended history.
Empty states

Every tab should have a clean empty state.

Examples:

No sleep records yet.
Add your first sleep entry.
AI insights will appear after enough data.
Weekly report is not ready yet.

Empty states should include one clear action.