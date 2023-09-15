import { test, expect } from '@playwright/test';

test.describe('When unauthenticated', () => {
  if(!process.env.PLAYWRIGHT_TESTS_PRODUCTION){
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
  }
});