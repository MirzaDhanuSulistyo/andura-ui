# Andura UI agent guide

Read this file before changing the repository. When working in a platform package, also read that package's `AGENTS.md`.

## Repository purpose

Andura UI is a cross-platform design-system monorepo. Flutter, React, Jetpack Compose, and SwiftUI expose the same 38-component contract and the same 151 imported visual systems.

Keep platform behavior and public API coverage aligned. Product-specific business widgets belong in consuming applications, not this repository.

## Documentation map

- User-facing overview and examples: `README.md`
- Contribution workflow: `CONTRIBUTING.md`
- Package overview: `packages/README.md`
- Release process: `packages/RELEASING.md`
- Shared component contract: `component_manifest.json`
- Platform coverage contract: `platform_manifest.json`
- Imported visual-system catalog: `design_systems/catalog.json`
- Import coverage report: `docs/open_design_audit.md` and `.json`
- Platform instructions:
  - `packages/flutter/AGENTS.md`
  - `packages/react/AGENTS.md`
  - `packages/compose/AGENTS.md`
  - `packages/swift/AGENTS.md`

## Source-of-truth boundaries

There are three distinct source flows:

1. `tokens/andura_tokens.json` is the source for Andura's original cross-platform tokens. Run `python3 scripts/generate_tokens.py` after changing it.
2. The upstream Open Design `design-systems/` directory is the import source for the visual-system catalog. `scripts/import_open_design.py` normalizes that source into the committed `design_systems/catalog.json`, audit files, and all generated platform catalogs.
3. Within this repository, committed `design_systems/catalog.json` is the input to `scripts/generate_platform_catalogs.py`. Use that generator when regenerating React, Compose, and Swift catalogs from the already-imported data.

Do not edit files beginning with `GENERATED FILE - DO NOT EDIT`. Change the appropriate source and regenerate instead.

### Open Design synchronization

A local Open Design checkout is **not required** for normal development, builds, or tests. It is required only when intentionally refreshing the imported catalog:

```sh
python3 scripts/import_open_design.py /path/to/open-design/design-systems
```

The importer rewrites the catalog, audits, and hundreds of generated files. Do not run it as a routine formatting or validation step. Review its full diff and run all repository validators afterward.

Keep `scripts/import_open_design.py` while Andura intends to track upstream Open Design systems. If the imported catalog becomes a permanently independent Andura-owned catalog, remove or replace the importer in a dedicated migration; do not silently delete it.

## Generated-file map

- `tokens/andura_tokens.json` → `scripts/generate_tokens.py` →
  - `packages/flutter/lib/src/foundations/generated_tokens.dart`
  - `packages/react/tokens.ts`, `packages/react/tokens.css`
  - Compose `AnduraTokens.kt` copies
  - `packages/swift/AnduraTokens.swift`
- Open Design checkout → `scripts/import_open_design.py` →
  - `design_systems/catalog.json`
  - `docs/open_design_audit.json`, `docs/open_design_audit.md`
  - Flutter generated theme catalog
  - invokes `scripts/generate_platform_catalogs.py`
- `design_systems/catalog.json` → `scripts/generate_platform_catalogs.py` → React, Compose, and Swift generated design-system files

## Cross-platform change rules

- A shared component addition or removal must update `component_manifest.json`, all four adapters, exports, and tests.
- A public API change should preserve equivalent semantics across platforms where the platform permits it.
- Keep disabled, loading, error, helper, focus, and accessibility behavior aligned with the manifest.
- A visual-system catalog change must be generated; never patch one platform's generated entry by hand.
- A token change must be made in `tokens/andura_tokens.json` and regenerated across platforms.
- Avoid unrelated generated churn. Check `git diff --stat` after every generator run.
- Do not commit dependency caches or build output.

## Environment baseline

CI currently uses:

- Python 3
- Flutter 3.41.0 / Dart 3.11
- Node.js 22
- Gradle 8.11, JDK 17, Android compile SDK 35
- Swift 5.9

Only install the toolchains needed for the package being changed. Cross-platform generators and validators require only Python 3; the Open Design importer optionally uses `dart format` when Dart is available.

## Validation

Always run the repository-level checks after contract, token, catalog, or generated-file changes:

```sh
python3 scripts/validate_design_system.py
python3 scripts/validate_platforms.py
python3 scripts/check_api.py
```

If token outputs changed, verify generation is clean:

```sh
python3 scripts/generate_tokens.py
git diff --check
```

Then run package-scoped checks from the relevant package as documented in its `AGENTS.md`. For cross-platform API changes, run all available platform suites.

## Working conventions

- Preserve the user's existing working tree; do not discard unrelated changes.
- Prefer focused changes and tests over broad refactors.
- Read nearby implementation and tests before modifying a public component.
- Update user-facing documentation when installation, public APIs, supported versions, or generation workflows change.
- Keep release versions aligned across Flutter, React, Compose, Swift, and the Git tag.
