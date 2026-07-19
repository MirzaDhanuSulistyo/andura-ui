# React adapter guide

Read the root `AGENTS.md` first.

## Ownership

- Public component API: `src/index.tsx`, `src/extended.tsx`
- Theme provider: `src/design-system-provider.tsx`
- Handwritten styles: `src/styles.css`
- Tests: `tests/`
- Showcase and visual fixtures: `showcase/`, `visual/`

Do not edit `tokens.ts`, `tokens.css`, or files under `src/design-systems/` directly; they are generated from root sources.

Keep exports covered by `scripts/check_api.py`. Preserve React 18+ compatibility, accessibility semantics, keyboard behavior, forwarded attributes, and provider scoping. Add Testing Library and `jest-axe` coverage for meaningful component behavior.

## Validation

```sh
cd packages/react
npm install --no-package-lock
npm run typecheck
npm test
npm run build
```

For intentional visual changes, also run `npm run test:visual` after installing Playwright's required browser.
