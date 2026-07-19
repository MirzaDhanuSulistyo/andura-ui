---
name: andura-ds-builder
description: Creates an app-local custom design system for an Andura UI Flutter, React, Jetpack Compose, or SwiftUI application, wires it into the app, previews semantic tokens, checks contrast, and adds tests. Use when users want their own brand theme without forking or registering it in Andura's bundled catalog.
compatibility: Requires a consuming project using an Andura UI release with app-local design-system APIs and the target platform toolchain.
metadata:
  author: andura-ui
  version: "1.0"
---

# Andura Design-System Builder

Create a custom design system in the consuming application. Do not add it to Andura's generated catalog and do not fork Andura unless the user explicitly wants a distributable catalog preset.

## Workflow

1. Inspect the consuming repository, its instructions, Git status, platform, Andura dependency version, app root, existing themes, tests, and preview/showcase conventions.
2. Locate Andura from a local dependency, sibling checkout, or installed package. Read its `README.md`, root `AGENTS.md`, target package `AGENTS.md`, and current public theme API before editing.
3. Confirm only missing high-impact inputs:
   - system name and stable lowercase ID;
   - baseline bundled system ID;
   - primary accent and on-accent colors;
   - light, dark, or both;
   - brand fonts and whether they are bundled;
   - any required semantic success, warning, or danger colors.
4. Start from one bundled Andura system and override only intentional values. Keep the full normalized object app-local. Follow [the platform API reference](references/platform-apis.md).
5. Check text/background, text/surface, on-accent/accent, and status-color contrast. Target WCAG AA: 4.5:1 for normal text and 3:1 for large text and meaningful UI boundaries. If supplied colors fail, report the failure and propose an accessible adjustment instead of silently changing the brand.
6. Store the custom system in the consuming project's theme/design-system module. Do not edit generated Andura files, `design_systems/catalog.json`, or package caches.
7. Wire the custom object at the application's existing root theme/provider. Preserve current routing, state, and light/dark behavior.
8. Add or update a focused preview showing background, surfaces, typography, actions, controls, borders, and success/warning/danger states. Prefer an existing showcase over creating a production route.
9. Add tests proving the custom ID and accent reach an Andura component and that the bundled catalog was not modified.
10. Format and run the target package's typecheck/analyzer/tests. Run the app or preview when the toolchain is available.

## Rules

- Use semantic values, not component-specific color patches.
- Do not claim a font is active unless its assets or platform dependency are configured.
- Do not create separate branded copies of Andura components.
- Do not register app-local IDs in `AnduraDesignSystems.all`/`designSystems`.
- Keep existing Andura presets and APIs unchanged.
- If the installed Andura version lacks the required custom-system API, recommend upgrading or temporarily pinning a compatible local checkout; do not automatically fork.
- Preserve unrelated working-tree changes and never commit unless requested.

## Completion response

Report:

- custom system file and root integration changed;
- baseline and overridden semantic values;
- contrast results and font limitations;
- tests and checks run;
- preview/run result;
- any decision still needed.
