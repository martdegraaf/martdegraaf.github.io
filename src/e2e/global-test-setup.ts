// https://playwright.dev/docs/auth#reuse-signed-in-state
import { chromium, expect, FullConfig } from '@playwright/test';

async function globalSetup(config: FullConfig) {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  await page.goto(process.env.PLAYWRIGHT_TEST_BASE_URL as string);

  await page.getByPlaceholder('Enter password').click();
  await page.getByPlaceholder('Enter password').fill(process.env.PASSWORD as string);
  await page.getByRole('button', { name: 'Submit' }).click();
  
  await page.waitForSelector('div.logo a');

  await page.context().storageState({ path: config.projects[0].use.storageState as string });
  await browser.close();
}

export default globalSetup;