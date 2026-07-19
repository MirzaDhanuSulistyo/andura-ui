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

## App-local custom design systems

Applications can create a custom system from a bundled baseline without
forking Andura or changing the generated catalog:

```dart
final acme = AnduraDesignSystems.byId('default').copyWith(
  id: 'acme',
  name: 'Acme',
  accent: 0xFF6750A4,
  accentOn: 0xFFFFFFFF,
);

MaterialApp(theme: AnduraTheme.fromSystem(acme));
```

```tsx
const acme: AnduraDesignSystem = {
  ...getDesignSystem('default'),
  id: 'acme',
  name: 'Acme',
  accent: '#6750a4',
};

<DesignSystemProvider system={acme}>…</DesignSystemProvider>
```

```kotlin
val acme = AnduraDesignSystems.defaultSystem.copy(
    id = "acme", name = "Acme", accent = 0xFF6750A4u,
)
AnduraDesignSystemTheme(acme) { /* … */ }
```

```swift
let acme = AnduraDesignSystems.defaultSystem.copyWith(
    id: "acme", name: "Acme", accent: 0xFF6750A4
)
ContentView().anduraDesignSystem(acme)
```

These objects remain owned by the consuming application and are not added to
`AnduraDesignSystems.all` or `designSystems`. Fonts must be bundled or loaded by
the consuming application.

## AI builder skills

Andura includes project-level Agent Skills for app delivery, app-local design
systems, and component creation:

- `app-builder` — product brief through phased implementation;
- `andura-ds-builder` — creates and validates an app-local branded system;
- `andura-component-builder` — builds product compositions or prepares a
  cross-platform shared primitive contribution.

Inside this repository, restart the agent so it discovers the skills, then run:

```text
/skill:app-builder Build a Flutter app for <idea>. The core feature is <feature>.
/skill:andura-ds-builder Create an Acme system from our brand colors.
/skill:andura-component-builder Add an accessible pricing card.
```

To use a skill from a sibling consuming project with pi:

```sh
pi --skill ../andura-ui/.agents/skills/andura-ds-builder/SKILL.md
```

Repeat `--skill` to load more than one. The app-builder workflow pauses for
approval between stages. Each skill keeps product-specific code in the
consuming application by default.

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
