import { test, expect } from '@playwright/test';

test('home page', async ({ page }) => {
  await page.goto('/');


  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Mart's blog/);

  await page.screenshot({ path: 'hompage.png', fullPage: true });
});

// test('about page', async ({ page }) => {
//   await page.goto('/about');


//   // Expect a title "to contain" a substring.
//   await expect(page).toHaveTitle(/About Mart/);

//   await page.screenshot({ path: 'about.png', fullPage: true });
// });
