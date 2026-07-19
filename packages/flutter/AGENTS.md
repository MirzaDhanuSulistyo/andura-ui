# Flutter adapter guide

Read the root `AGENTS.md` first.

## Ownership

- Public library entry point: `lib/andura_ui.dart`
- Handwritten components: `lib/src/components/`
- Handwritten foundations and theme adapter: `lib/src/foundations/`, `lib/src/theme/`
- Tests: `test/`
- Interactive showcase: `example/`

Do not edit `lib/src/foundations/generated_tokens.dart`, `lib/src/theme/generated_design_systems.dart`, or files under `lib/src/theme/generated/` directly. Use the root generators described in `AGENTS.md`.

Keep Flutter component names aligned with `component_manifest.json`. Components should consume `AnduraThemeTokens.of(context)` where visual-system values apply and should remain usable inside ordinary Material theme hosts.

## Validation

```sh
cd packages/flutter
flutter pub get
dart format --output=none --set-exit-if-changed lib test example/lib
flutter analyze
flutter test
(cd example && flutter analyze)
```

Use Flutter 3.41.0 or a compatible version satisfying `pubspec.yaml`.
