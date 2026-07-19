# Andura UI for Flutter

Flutter adapter for the Andura UI cross-platform design system. It includes 38
shared components and 151 selectable visual systems.

```dart
import 'package:andura_ui/andura_ui.dart';

MaterialApp(
  theme: AnduraTheme.forSystem('linear-app', Brightness.light),
  darkTheme: AnduraTheme.forSystem('linear-app', Brightness.dark),
  home: const MyApp(),
);
```

For Git installation from the monorepo:

```yaml
dependencies:
  andura_ui:
    git:
      url: https://github.com/MirzaDhanuSulistyo/andura-ui.git
      ref: v0.3.0
      path: packages/flutter
```

See the [repository README](../../README.md) for the shared catalog and other
platform adapters.
