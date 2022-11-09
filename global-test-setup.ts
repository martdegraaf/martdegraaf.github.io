// https://playwright.dev/docs/test-auth#sign-in-with-beforeeach
import { chromium, FullConfig } from '@playwright/test';

async function globalSetup(config: FullConfig) {
  const browser = await chromium.launch();
  const page = await browser.newPage();


  await page.goto('/');
  const passwordField = page.getByPlaceholder('Enter password');
  await passwordField.fill('Thanks4Testing!');
  await passwordField.press('Enter');
  
  // Save signed-in state to 'storageState.json'.
  await page.context().storageState({ path: 'storageState.json' });
  await browser.close();
}

export default globalSetup;