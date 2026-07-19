# Andura UI integration rules

Use these rules for any app generated with the App Builder skill.

## Locate and inspect

Before implementation:

1. Read the Andura repository `README.md` and root `AGENTS.md`.
2. Read the target adapter's `AGENTS.md` completely.
3. Inspect the adapter's public exports, examples, manifest, component signatures, token/theme APIs, and required runtime versions.
4. Check the consuming project's existing dependency and theme configuration.
5. Select one approved visual-system ID. Do not mix visual systems within a product unless the product explicitly supports theme selection.

Current adapters live under:

- Flutter: `packages/flutter`
- React: `packages/react`
- Jetpack Compose: `packages/compose`
- SwiftUI: `packages/swift`

## Dependency strategy

Use a local path/project dependency while prototyping against a sibling checkout. Pin a released version/tag for reproducible CI and production builds. Never rely on an unpinned branch for a release.

For Flutter local development:

```yaml
dependencies:
  andura_ui:
    path: ../andura-ui/packages/flutter
```

Always verify relative paths from the consuming project rather than copying this example blindly.

## Component selection

Use Andura public components for shared UI concerns such as actions, cards/surfaces, forms, settings rows, feedback, filters, navigation helpers, progress, list items, responsive layout, loading, and empty states.

Create a product component only when it combines domain data or interaction in a way that is not a general design-system primitive, for example:

- live network-speed panel;
- monthly plan summary;
- transaction insights;
- media analytics graph;
- domain-specific timeline.

A product component should compose Andura primitives and consume theme tokens. It should remain in the consuming app.

## Token discipline

Use semantic tokens for:

- background and surfaces;
- foreground and muted content;
- accent, success, warning, and danger states;
- border;
- spacing;
- radius;
- motion;
- responsive container width.

Avoid raw color, spacing, radius, shadow, and motion literals when an Andura token expresses the intent. Small intrinsic measurements such as icon glyph sizes or chart stroke widths may be local when no token applies, but they should be centralized and justified.

Do not use warning/danger colors as decorative brand colors. Do not encode meaning by color alone.

## Theme and accessibility

- Configure Andura at the app root.
- Support the product's approved light/dark/system modes.
- Preserve adapter semantics and minimum target sizes.
- Test text scaling and long localized strings.
- Give charts, gauges, and visual summaries semantic labels and textual alternatives.
- Expose loading, empty, error, disabled, permission-denied, stale, and partial-data states.
- Respect reduced motion when the platform exposes it.

## Product proof expectations

A design-system proof is not complete until:

- it renders on the requested target viewport/device;
- the screenshot has been visually inspected for clipping, overflow, hierarchy, contrast, and safe-area behavior;
- interactive controls respond or are explicitly marked as prototype behavior;
- sample data is realistic and disclosed;
- formatter, static checks, and focused tests pass.

## Repository boundary

Do not add product-specific widgets to Andura UI. A new Andura component must be broadly reusable, represented in the shared component contract, and implemented consistently across all required adapters. Follow root and adapter `AGENTS.md` instructions before proposing such a change.
