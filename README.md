# Andura UI

A cross-platform design-system monorepo for Flutter, React, Jetpack Compose, and SwiftUI. Every adapter exposes the same 151 visual systems and 38-component contract from one shared catalog.

## Install Flutter

```yaml
dependencies:
  andura_ui:
    git:
      url: https://github.com/MirzaDhanuSulistyo/andura-ui.git
      ref: v0.3.0
      path: packages/flutter
```

For local development, use a path dependency:

```yaml
andura_ui:
  path: ../andura-ui/packages/flutter
```

## Install other adapters

```sh
npm install @andura-ui/react@0.3.0
```

```kotlin
implementation("com.andura.ui:andura:0.3.0")
```

```swift
.package(
    url: "https://github.com/MirzaDhanuSulistyo/andura-ui.git",
    from: "0.3.0"
)
```

The Compose artifact is published through GitHub Packages. Swift Package
Manager uses the repository-level `Package.swift`.

## Usage

```dart
import 'package:andura_ui/andura_ui.dart';

MaterialApp(
  theme: AnduraTheme.light,
  darkTheme: AnduraTheme.dark,
  home: AnduraPage(
    title: 'Welcome',
    child: Column(
      children: [
        const AnduraCard(child: Text('Shared surface')),
        const SizedBox(height: AnduraSpacing.lg),
        AnduraButton(label: 'Continue', onPressed: () {}),
      ],
    ),
  ),
);
```

Run the interactive component showcase with:

```sh
cd packages/flutter/example
flutter run
```

The showcase includes a selector for all 151 imported Open Design systems. The
original Andura theme remains the default for backwards compatibility.

## Open Design catalog

Andura exposes the normalized Open Design catalog without duplicating widgets:

```dart
final systems = AnduraDesignSystems.all; // 151 entries

MaterialApp(
  theme: AnduraTheme.forSystem('linear-app', Brightness.light),
  darkTheme: AnduraTheme.forSystem('linear-app', Brightness.dark),
  home: const MyApp(),
);
```

Shared widgets read `AnduraThemeTokens.of(context)`, allowing colors,
typography, radii, spacing, motion, and layout values to change by system.
Generated catalogs use one clearly named source file per design system on every
platform (for example, `airbnb.dart`, `airbnb.ts`,
`AirbnbDesignSystem.kt`, and `AirbnbDesignSystem.swift`).
`docs/open_design_audit.json` contains the complete system/component coverage
matrix. To refresh it from a local Open Design checkout:

```sh
python3 scripts/import_open_design.py ~/code/open-design/design-systems
```

Open Design fixtures are web references. Their nine normalized component
groups map to shared Flutter implementations; brand-specific CSS classes are
kept as recipes rather than treated as stable component APIs. Imported systems
are aesthetic inspirations and are not official brand packages; source
attribution remains in the upstream Open Design manifests.

## AI app builder skill

Andura includes a project-level Agent Skill that turns an app idea into a product brief, feasibility assessment, PRD, screen inventory, Andura UI proof, architecture, and phase-by-phase vertical slices.

Inside this repository, restart the agent so it discovers the skill, then run:

```text
/skill:app-builder Build a Flutter app for <idea>. The core feature is <feature>.
```

To use it from a sibling consuming project with pi:

```sh
pi --skill ../andura-ui/.agents/skills/app-builder/SKILL.md
```

The default workflow pauses for approval between stages. See [the skill instructions](.agents/skills/app-builder/SKILL.md) for gated and autopilot behavior.

## Repository structure

- `design_systems/catalog.json`: platform-neutral source catalog
- `packages/flutter`: Dart package, themes, components, tests, and showcase
- `packages/react`: npm package and contextual CSS themes
- `packages/compose`: Android library and Material 3 adapter
- `packages/swift`: SwiftUI implementation used by the root `Package.swift`
- `component_manifest.json`: shared component and accessibility contract
- `platform_manifest.json`: cross-platform implementation and catalog coverage

Components expose disabled, loading, error, helper, and focus-friendly states where applicable. Shared token categories include semantic colors, spacing, radii, sizing, typography, motion, elevation, and responsive layout values.

Product-specific business widgets should remain in the consuming application.

## Platform adapters

All adapters expose the same 151-system catalog and complete 38-component
inventory:

- Flutter: `AnduraTheme.forSystem('linear-app')`
- React: `<DesignSystemProvider systemId="linear-app">`
- Compose: `AnduraDesignSystemTheme(AnduraDesignSystems.byId("linear-app"))`
- SwiftUI: `.anduraDesignSystem("linear-app")`

The React adapter is available in `packages/react` with native React components,
CSS tokens, Vitest/Testing Library coverage, and an interactive showcase. Run
its checks with:

```sh
cd packages/react
npm install
npm run typecheck
npm test
```

Contributions and issues are welcome in the [public repository](https://github.com/MirzaDhanuSulistyo/andura-ui).
