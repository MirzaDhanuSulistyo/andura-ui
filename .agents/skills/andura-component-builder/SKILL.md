---
name: andura-component-builder
description: Builds accessible components with Andura UI, placing product-specific compositions in the consuming app and routing genuinely reusable primitives through Andura's four-platform contract. Use when users ask to add, create, wrap, or contribute an Andura-based component.
compatibility: Requires access to the consuming project or an Andura UI checkout and the relevant platform toolchain.
metadata:
  author: andura-ui
  version: "1.0"
---

# Andura Component Builder

Build the component in the correct repository boundary. Reuse Andura before creating another primitive.

## Classify first

Inspect the requested behavior, consuming project, Andura exports, `component_manifest.json`, and nearby components. Classify the request:

### Product composition

Keep it in the consuming application when it contains domain language, business data, app navigation, feature-specific analytics, or combines primitives for one product. Examples: invoice summary, subscription card, media timeline, account quota panel.

### Shared primitive

Consider an Andura contribution only when the component is domain-neutral, broadly reusable, has equivalent semantics on all four platforms, and is not already expressible as a small composition of existing primitives.

If classification is ambiguous or a shared primitive would expand the public contract, explain the choice and ask for approval before changing Andura across all four adapters.

## Product-component workflow

1. Read project instructions and inspect Git status, platform, Andura dependency, active theme, component conventions, and tests.
2. Inspect Andura's actual public exports and signatures; do not invent components or props.
3. Define the component contract: content, actions, states, responsive behavior, and ownership of state.
4. Compose public Andura primitives. Consume the active semantic design-system values instead of copying Andura source or hard-coding substitute colors, spacing, radii, or motion.
5. Implement applicable loading, empty, error, disabled, focused, selected, and partial-data states.
6. Preserve native semantics, keyboard/focus behavior, minimum target size, text scaling, localization, and reduced motion.
7. Add a preview/story/example with realistic data and focused behavior/accessibility tests.
8. Format, lint/analyze/typecheck, test, and run the preview when available.
9. Keep the component in the consuming application and do not modify `component_manifest.json`.

## Shared-primitive workflow

After explicit approval:

1. Read Andura's root `AGENTS.md`, `CONTRIBUTING.md`, all four package `AGENTS.md` files, `component_manifest.json`, and nearby implementations/tests.
2. Define one platform-neutral behavioral and accessibility contract. Document any unavoidable native difference.
3. Update `component_manifest.json`.
4. Implement equivalent public APIs in Flutter, React, Compose, and SwiftUI using handwritten component sources.
5. Update every adapter's exports or entry points and relevant showcase/preview.
6. Add behavior and accessibility tests on every platform.
7. Never edit generated token or design-system catalog files for a component change.
8. Run repository validators and every available platform suite listed in `CONTRIBUTING.md`.
9. Report unavailable toolchains and unrun connected/device tests precisely; never call the cross-platform change complete while required checks fail.

Use [the review checklist](references/review-checklist.md) before completion.

## Rules

- Prefer focused composition over expanding Andura's shared contract.
- Do not create brand-specific component variants; visual identity belongs in semantic systems.
- Avoid API divergence hidden behind platform-specific names.
- Preserve unrelated working-tree changes.
- Do not commit unless requested.

## Completion response

Report classification, location, public behavior, states/accessibility covered, files changed, validations run, platform limitations, and whether a shared-contract decision remains.
