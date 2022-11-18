import { test, expect } from '@playwright/test';

test('posts agile blogging', async ({ page }) => {
  await page.goto('posts/howtoget');


  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Blogging agile/);

  await page.screenshot({ path: 'blogging-agile.png', fullPage: true });

  //check that mermaid diagram loads
  //Syntax error in graph mermaid version 9.2.2
  await expect(page.locator('.mermaid')).not.toHaveText('Syntax error in graph');
});
