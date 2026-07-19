# Jetpack Compose adapter guide

Read the root `AGENTS.md` first.

## Ownership

The Gradle-built source of truth is under `andura/src/main/kotlin/com/andura/ui/`:

- Handwritten components: `AnduraComponents.kt`, `AnduraExtendedComponents.kt`
- Theme adapter: `AnduraDesignSystemTheme.kt`
- Tests: `andura/src/androidTest/`

The root-level `AnduraComponents.kt` and generated token copy mirror packaged source for compatibility. Keep mirrors synchronized when a workflow intentionally updates them.

Do not edit generated `AnduraTokens.kt` files or files under `andura/src/main/kotlin/com/andura/ui/designsystems/` directly. Use the root generators.

Use Material 3 semantics and keep APIs aligned with `component_manifest.json`. The module targets JDK 17, Android min SDK 21, and compile SDK 35.

## Validation

```sh
cd packages/compose
gradle build
```

CI uses Gradle 8.11. Run connected Android tests when changing behavior that is covered under `src/androidTest` and a device or emulator is available.
