import { test, expect } from '@playwright/test';

const BASE_URL = process.env.URL as string;

test('about page', async ({ page }) => {
  await page.goto('/about');

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/About Mart/);
});
