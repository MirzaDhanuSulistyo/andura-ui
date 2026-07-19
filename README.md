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

## Package structure

- `foundations`: colors, spacing, radii, sizing, typography, and motion
- `theme`: coordinated light and dark Material 3 themes
- `components`: buttons, cards, fields, text areas, selects, dialogs, badges, selectors, states, and page layouts

Components expose disabled, loading, error, helper, and focus-friendly states where applicable. Shared token categories include semantic colors, spacing, radii, sizing, typography, motion, elevation, and responsive layout values.

Product-specific business widgets should remain in the consuming application. Contributions and issues are welcome in the [public repository](https://github.com/MirzaDhanuSulistyo/andura-ui).
