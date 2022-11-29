import { test, expect } from '@playwright/test';

test.describe('Blogging Agile', () => {
  test.describe('Start Blogging', () => {
    test('posts agile blogging', async ({ page }) => {
      await page.goto('posts/blogging-agile/start-blogging-today/');
    
    
      // Expect a title "to contain" a substring.
      await expect(page).toHaveTitle(/Beat your excuses and start blogging/);
      
    
      await page.screenshot({ path: 'blogging-agile.png', fullPage: true });
    
      //This article is part of the series 'Blogging Agile'.
      //await expect(page.content).toContain(/This article is part of the series 'Blogging Agile'/);
    
      //check that mermaid diagram loads
      //Syntax error in graph mermaid version 9.2.2
      await expect(page.locator('.mermaid')).not.toHaveText('Syntax error in graph');
    });
  });
});

