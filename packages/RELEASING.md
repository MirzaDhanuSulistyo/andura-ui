# Releasing adapters

Releases are intentionally manual. Run the `Release platform packages` workflow
with a version after CI passes.

- Flutter publishes from `packages/flutter` and requires `PUB_CREDENTIALS`.
- React requires `NPM_TOKEN`.
- Compose requires Maven publishing credentials and a configured repository.
- Swift releases are distributed by tagging the repository; the root
  `Package.swift` makes the repository URL directly installable.
- Keep Flutter, React, Compose, and the Git tag on the same version.
