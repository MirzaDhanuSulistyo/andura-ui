# Contributing to Andura UI

Thanks for contributing. Start with `AGENTS.md`; it defines repository boundaries, generated files, and validation requirements. Read the relevant package's `AGENTS.md` before editing a platform adapter.

## Local setup

Install only the toolchains needed for your change. CI's supported baseline is Python 3, Flutter 3.41.0, Node.js 22, Gradle 8.11 with JDK 17, Android compile SDK 35, and Swift 5.9.

Package setup:

```sh
# Flutter
cd packages/flutter && flutter pub get

# React
cd packages/react && npm install --no-package-lock

# Compose (CI supplies Gradle 8.11)
cd packages/compose && gradle build

# Swift, from the repository root
swift test
```

## Choose the correct source

- Original Andura tokens: edit `tokens/andura_tokens.json`, then run `python3 scripts/generate_tokens.py`.
- Imported design-system data: refresh with `scripts/import_open_design.py` only when intentionally syncing an Open Design checkout.
- Generated design-system files: do not edit them directly.
- Components: edit the handwritten source in each platform adapter.

A local Open Design checkout is not needed for normal component work or testing. See `AGENTS.md` for the import and generation flow.

## Shared API changes

The repository promises a shared component inventory across four platforms. When adding, removing, or substantially changing a shared component:

1. Update `component_manifest.json` when the contract changes.
2. Implement equivalent behavior in Flutter, React, Compose, and SwiftUI.
3. Update each adapter's public exports or entry points.
4. Add or update platform tests.
5. Run the repository validators and all affected platform checks.

If a platform cannot represent identical behavior, document the platform-specific difference rather than silently diverging.

## Validation commands

Repository contracts:

```sh
python3 scripts/validate_design_system.py
python3 scripts/validate_platforms.py
python3 scripts/check_api.py
git diff --check
```

Flutter:

```sh
cd packages/flutter
flutter pub get
dart format --output=none --set-exit-if-changed lib test example/lib
flutter analyze
flutter test
(cd example && flutter analyze)
```

React:

```sh
cd packages/react
npm install --no-package-lock
npm run typecheck
npm test
npm run build
```

Compose:

```sh
cd packages/compose
gradle build
```

Swift:

```sh
swift test
```

Run the checks matching your change. Cross-platform contract or catalog changes should run every available suite.

## Pull requests

- Keep one concern per PR.
- Explain the user-visible effect and which platforms are affected.
- Call out generated files and name the generator used.
- Include validation commands and results.
- Include screenshots for visible showcase or styling changes when practical.
- Do not include build output, dependency caches, credentials, or unrelated generated churn.

Release instructions are in `packages/RELEASING.md`.
