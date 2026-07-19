# SwiftUI adapter guide

Read the root `AGENTS.md` first.

## Ownership

- Handwritten components: `AnduraComponents.swift`, `AnduraExtendedComponents.swift`
- Theme environment and modifier: `AnduraDesignSystemTheme.swift`
- Previews: `AnduraPreviews.swift`
- Tests: `Tests/`

Do not edit `AnduraTokens.swift` or files under `Generated/` directly. Use the root generators.

The repository-level `Package.swift` is the distribution entry point; the package-local manifest supports development from this directory. Keep target membership compatible with both. The package supports iOS 16+, macOS 13+, and Swift tools 5.9.

Keep public APIs and accessibility behavior aligned with `component_manifest.json`. Prefer native SwiftUI environment, focus, disabled, and accessibility mechanisms.

## Validation

From the repository root:

```sh
swift test
```

The equivalent package-local command is `cd packages/swift && swift test`.
