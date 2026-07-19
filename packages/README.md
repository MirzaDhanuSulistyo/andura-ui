# Andura platform packages

All adapters consume the same platform-neutral catalog in
`design_systems/catalog.json` and cover the complete 38-component contract.

- `flutter/` — Dart package, Material themes, tests, showcase, and 151 themes
- `react/` — React components, contextual CSS variables, tests, and 151 themes
- `compose/andura/` — Jetpack Compose components, Material theme adapter, and 151 themes
- `swift/` — SwiftUI components, environment theme modifier, and 151 themes

Platform theme entry points:

```tsx
<DesignSystemProvider systemId="linear-app">…</DesignSystemProvider>
```

```kotlin
AnduraDesignSystemTheme(AnduraDesignSystems.byId("linear-app")) { /* … */ }
```

```swift
ContentView().anduraDesignSystem("linear-app")
```

Refresh Open Design and every generated catalog with:

```sh
python3 scripts/import_open_design.py ~/code/open-design/design-systems
```

Regenerate the original Andura token outputs with:

```sh
python3 scripts/generate_tokens.py
```
