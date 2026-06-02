# Design Documentation

This folder is the temporary design source of truth for the Sleep Analytics mobile app.

There is currently no finalized Figma design.

Until Figma exists, implement mobile UI based on these files:

1. `visual_direction.md`
2. `design_tokens.md`
3. `mobile_navigation.md`
4. `mobile_screens.md`
5. `mobile_components.md`
6. `ai_assistant_ui.md`

## How to use this documentation

When implementing a new screen:

1. Read `visual_direction.md`.
2. Read `design_tokens.md`.
3. Read the relevant screen description in `mobile_screens.md`.
4. Use components from `mobile_components.md`.
5. If the screen contains AI insights, also read `ai_assistant_ui.md`.

## Design priority

If files conflict, follow this priority:

1. `AGENTS.md`
2. `design_tokens.md`
3. `mobile_screens.md`
4. `mobile_components.md`
5. `visual_direction.md`

## General rule

Do not invent a different visual style unless the user explicitly asks for a redesign.