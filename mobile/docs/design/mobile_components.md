# Mobile Components

## AppScaffold

Base layout for main screens.

Should support:

- dark background;
- optional app bar;
- bottom navigation;
- safe area;
- consistent screen padding.

## GradientButton

Used for primary actions.

Examples:

- Start Free
- Save Sleep Entry
- Upgrade to Premium
- View AI Report

Style:

- gradient from #7C5CFF to #4DA8FF;
- rounded corners;
- strong but elegant;
- full width on forms.

## SecondaryButton

Used for secondary actions.

Style:

- transparent or dark surface;
- subtle border;
- rounded corners.

## GlassCard

Base card component.

Used for:

- metrics;
- AI insights;
- premium blocks;
- reports;
- habit cards.

Style:

- dark translucent surface;
- subtle border;
- rounded corners;
- soft shadow;
- optional glow.

## MetricCard

Used to show one important metric.

Props:

- title
- value
- subtitle
- icon
- status
- trend

Examples:

- Sleep Score: 84
- Sleep Duration: 7h 32m
- Recovery: 78%
- Sleep Debt: 42m

## SleepScoreCard

Large card for main sleep score.

Should include:

- score number;
- label;
- short explanation;
- visual ring or progress indicator.

Example:

“84 — Good recovery”

## AiInsightCard

Used for AI-generated explanation.

Content:

- AI label
- insight title
- short explanation
- recommendation preview
- optional confidence/status
- disclaimer if needed

Style:

- premium gradient border or glow;
- smart analyst feeling;
- not a chatbot bubble.

## RecommendationCard

Used for personalized sleep coaching actions.

Content:

- title
- explanation
- priority
- expected benefit
- action status

Examples:

- “Reduce screen time 45 minutes before sleep”
- “Keep bedtime within a 30-minute window”
- “Avoid caffeine after 16:00”

## HabitFactorCard

Used for behavioral factors.

Factors:

- caffeine;
- stress;
- activity;
- screen time;
- mood.

Content:

- factor name;
- current value;
- effect indicator;
- small explanation.

## ChartCard

Wrapper for charts or chart placeholders.

Used for:

- line charts;
- sleep timeline;
- heatmaps;
- recovery charts;
- habit correlations.

Until a chart library is approved, create polished placeholder chart widgets.

## PremiumLockedCard

Used when a feature is premium-only.

Content:

- premium feature name;
- short value explanation;
- Upgrade button.

Tone:

- helpful;
- not annoying;
- not aggressive.

## EmptyState

Used when there is no data.

Content:

- icon;
- title;
- short explanation;
- primary action.

Example:

“Add your first sleep entry to start seeing AI insights.”

## RiskIndicatorBadge

Used for warning patterns.

Statuses:

- stable;
- attention;
- risk;

Must not use diagnostic wording.

Example:

“Possible sleep debt pattern”