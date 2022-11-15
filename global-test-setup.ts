// https://playwright.dev/docs/auth#reuse-signed-in-state
import { chromium, expect, FullConfig } from '@playwright/test';

async function globalSetup(config: FullConfig) {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  const BASE_URL = config.projects[0].use.baseURL as string;
  await page.goto(BASE_URL);
  const passwordField = page.getByPlaceholder('Enter password');
  await passwordField.fill(process.env.PASSWORD as string);
  await passwordField.press('Enter');
  
  await expect(page).toHaveTitle(/Mart's blog/);

  await page.context().storageState({ path: config.projects[0].use.storageState as string });
  await browser.close();
}

export default globalSetup;