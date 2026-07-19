# Andura platform packages

These directories contain generated token outputs and platform-native adapter work.

- `react/` — React components, tests, CSS tokens, and interactive showcase
- `react/tokens.css` — CSS custom properties for React/web consumers
- `compose/AnduraTokens.kt` — Kotlin token constants for Jetpack Compose
- `swift/AnduraTokens.swift` — Swift token constants for SwiftUI/UIKit

The React package currently covers the core component contract: buttons,
icon buttons, cards, fields, text areas, selects, dialogs, badges, search,
empty, loading, avatars, notifications, settings, choice, and check controls.
It includes production ESM/CJS builds, typed token exports, visual showcase
code, and axe-based accessibility tests.

Regenerate all outputs with:

```sh
python3 scripts/generate_tokens.py
```
