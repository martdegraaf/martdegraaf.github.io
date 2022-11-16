import { test, expect } from '@playwright/test';

test('posts verifylogged-with-xunit', async ({ page }) => {
  await page.goto('posts/verifylogged-with-xunit');


  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/How to verify that ILogger actually logged an error?/);

  await page.screenshot({ path: 'verifylogged-with-xunit.png', fullPage: true });
});
