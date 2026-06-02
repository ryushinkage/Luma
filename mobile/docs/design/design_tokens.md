# Design Tokens

## Color palette

### Background

Primary background:

#060816

Secondary background:

#0B1020

Use these colors for main app backgrounds.

Cards and surfaces

Primary card:

#141D33

Secondary card:

#18243D

Glass surface:

rgba(255, 255, 255, 0.06)

Border:

rgba(255, 255, 255, 0.10)
Accent colors

Primary accent:

#7C5CFF

Secondary accent:

#4DA8FF

Main gradient:

linear-gradient(135deg, #7C5CFF 0%, #4DA8FF 100%)
Status colors

Positive:

#6EE7B7

Danger:

#FF6B7A

Warning:

#FBBF24
Text colors

Primary text:

#F5F7FF

Secondary text:

#B7C1D9

Muted text:

#7D8AA8
Flutter color naming

Use these names when creating theme constants:

AppColors.backgroundPrimary
AppColors.backgroundSecondary
AppColors.surfacePrimary
AppColors.surfaceSecondary
AppColors.primaryAccent
AppColors.secondaryAccent
AppColors.success
AppColors.warning
AppColors.danger
AppColors.textPrimary
AppColors.textSecondary
AppColors.textMuted
Gradients

Primary CTA gradient:

#7C5CFF -> #4DA8FF

AI card gradient:

#7C5CFF with opacity -> #4DA8FF with opacity

Background glow gradient:

soft radial glow using #7C5CFF and #4DA8FF with low opacity
Border radius

Use rounded corners consistently:

Small: 12
Medium: 16
Large: 20
Extra large: 28

Recommended usage:

buttons: 16
input fields: 16
metric cards: 20
large dashboard cards: 24
bottom sheets: 28
Spacing

Use a consistent spacing scale:

4
8
12
16
20
24
32
40
48

Recommended usage:

screen horizontal padding: 20 or 24
card internal padding: 16 or 20
section gap: 24 or 32
small item gap: 8 or 12
Typography

Use clean modern typography.

Recommended hierarchy:

Display / Hero

Used rarely.

Purpose:

onboarding headline;
main dashboard greeting.
Screen title

Large and bold.

Used once per screen.

Section title

Medium and semi-bold.

Used for groups like:

“Today’s Sleep”
“AI Insights”
“Behavioral Factors”
Body text

Readable and calm.

Caption

Used for:

explanations;
timestamps;
disclaimers;
secondary labels.
Shadows and glow

Use subtle shadows and glow.

Do not create heavy shadows.

Recommended effects:

soft blue/purple glow behind AI cards;
subtle border glow on premium elements;
very soft card shadow;
gradient background blobs with low opacity.
Icons

Use simple line icons.

Icon style should be:

minimal;
rounded;
modern;
not cartoonish.

Use icons for:

sleep;
moon;
AI;
analytics;
recovery;
habits;
profile;
settings.