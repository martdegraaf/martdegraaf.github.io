import { test, expect } from '@playwright/test';

test.describe('Git clone blog page', () => {
    test('posts clone git repos', async ({ page }) => {
        await page.goto('/posts/consulting/git-clone-all-repos-azure-devops/');

        // Expect a title "to contain" a substring.
        await expect(page).toHaveTitle(/Efficiently Git Clone All Repositories from Azure DevOps using PowerShell: A Step-by-Step Guide | Mart's blog/);

        await page.screenshot({ path: 'clone.png', fullPage: true });
    });
});