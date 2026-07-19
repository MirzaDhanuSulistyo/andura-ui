# Releasing adapters

Releases are intentionally manual. Run the `Release platform packages` workflow
with a version after CI passes.

- React requires `NPM_TOKEN`.
- Compose requires Maven publishing credentials and a configured repository.
- Swift releases are distributed by tagging the repository; the package manifest
  is compatible with Swift Package Manager.
