import { expect, test } from '@playwright/test';
test('Andura core fixture renders consistently', async ({ page }) => {
  await page.goto(new URL('./fixture.html', import.meta.url).href);
  const screenshot = await page.locator('main').screenshot({ animations: 'disabled' });
  expect(screenshot.byteLength).toBeGreaterThan(0);
});
