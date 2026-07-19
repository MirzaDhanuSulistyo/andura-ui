# Andura UI

A reusable Flutter design system for Andura applications. It provides a consistent Poppins-based theme, design tokens, responsive page layouts, accessible form controls, cards, buttons, dialogs, badges, feedback states, and navigation elements.

## Install

```yaml
dependencies:
  andura_ui:
    git:
      url: https://github.com/MirzaDhanuSulistyo/andura-ui.git
      ref: main
```

For local development, use a path dependency:

```yaml
andura_ui:
  path: ../andura-ui
```

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
cd example
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

## Package structure

- `foundations`: colors, spacing, radii, sizing, typography, motion, elevation, and layout tokens
- `theme`: coordinated light and dark Material 3 themes
- `components`: buttons, cards, fields, text areas, selects, dialogs, badges, selectors, states, and page layouts
- `component_manifest.json`: machine-readable component, variant, state, and accessibility inventory

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
