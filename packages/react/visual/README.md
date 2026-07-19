# Visual regression

The fixture is intentionally static so Playwright can render it without a
bundler. Run the screenshot check with:

```sh
npm run test:visual
```

When intentional visual changes are made, regenerate the platform-specific
baseline with `npx playwright test --update-snapshots` and review the diff.
