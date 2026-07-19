# Component review checklist

## Boundary

- Is this domain-neutral enough for Andura?
- Does an existing Andura primitive or small composition already solve it?
- Is product data and navigation kept outside a shared primitive?
- Is visual branding expressed through the active design system rather than a component fork?

## Contract and states

- Public inputs and callbacks are minimal and controlled/uncontrolled ownership is clear.
- Default, disabled, loading, error, helper, focused, selected, empty, and read-only states are included where applicable.
- Async actions cannot accidentally run twice.
- Destructive actions are explicit.
- Long content, localization, text scaling, and small supported viewports are handled.

## Accessibility

- Native role and state semantics are exposed.
- Labels and errors are programmatically associated.
- Keyboard operation and visible focus work.
- Touch/click targets meet platform guidance.
- Meaning is not conveyed by color alone.
- Motion respects platform reduction preferences where applicable.

## Theming

- Semantic background, surface, foreground, muted, border, accent, and status values are used correctly.
- Spacing, radii, motion, and layout values come from Andura when available.
- The component works with a bundled system and an app-local custom system.
- Light/dark behavior does not assume one fixed canvas.

## Validation

### Product composition

Run the consuming project's formatter, analyzer/linter/typecheck, focused tests, and build or preview.

### Shared Andura primitive

Run:

```sh
python3 scripts/validate_design_system.py
python3 scripts/validate_platforms.py
python3 scripts/check_api.py
git diff --check
```

Then run the Flutter, React, Compose, and Swift commands in `CONTRIBUTING.md`. Record connected-device or visual tests separately when unavailable.
