import { test, expect } from '@playwright/test';

const BASE_URL = process.env.URL as string;

test('about page', async ({ page }) => {
  await page.goto('https://martdegraaf.github.io/posts/add-properties-for-consuming-apps-to-a-nuget-package/');

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Add project properties/);
});
