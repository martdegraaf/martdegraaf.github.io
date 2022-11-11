import { test, expect } from '@playwright/test';

test('posts agile blogging', async ({ page }) => {
  await page.goto('/posts/blogging-agile');


  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Blogging agile/);

  await page.screenshot({ path: 'blogging-agile.png', fullPage: true });
});


test('posts clone git repos', async ({ page }) => {
  await page.goto('/posts/git-clone-all-repos-azure-devops');


  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Clone All Git Repos from Azure Devops/);

  await page.screenshot({ path: 'clone.png', fullPage: true });
});
