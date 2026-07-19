# Andura platform packages

These directories contain generated token outputs for future platform adapters.
The component implementations remain in the Flutter package until each adapter
has a platform-native API.

- `react/tokens.css` — CSS custom properties for React/web consumers
- `compose/AnduraTokens.kt` — Kotlin token constants for Jetpack Compose
- `swift/AnduraTokens.swift` — Swift token constants for SwiftUI/UIKit

Regenerate all outputs with:

```sh
python3 scripts/generate_tokens.py
```
