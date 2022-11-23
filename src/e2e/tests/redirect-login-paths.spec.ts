import { test, expect } from '@playwright/test';

test.describe('When unauthenticated', () => {
    test.use({ storageState: 'emptyStorageState.json' }); 
  test('twitter should redirect to password', async ({ page }) => {
      await page.goto('/.auth/login/twitter');
      await expect(page).toHaveURL(/basicAuth/);
  });
  test('github should redirect to password', async ({ page }) => {
        await page.goto('/.auth/login/github');
      await expect(page).toHaveURL(/basicAuth/);
  });
  test('aad should redirect to password', async ({ page }) => {
      await page.goto('/.auth/login/aad');
      await expect(page).toHaveURL(/basicAuth/);
  });
});