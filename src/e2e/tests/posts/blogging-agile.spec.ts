import { test, expect } from '@playwright/test';

test('posts agile blogging', async ({ page }) => {
  await page.goto('posts/blogging-agile/how-to-get-started-with-technical-blogging/');


  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/How to get started with technical blogging/);

  await page.screenshot({ path: 'blogging-agile.png', fullPage: true });

  //check that mermaid diagram loads
  //Syntax error in graph mermaid version 9.2.2
  await expect(page.locator('.mermaid')).not.toHaveText('Syntax error in graph');
});
