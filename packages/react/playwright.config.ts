import { defineConfig } from '@playwright/test';
export default defineConfig({ testDir: './visual', snapshotPathTemplate: '{testDir}/snapshots/{arg}{ext}', use: { colorScheme: 'light' } });
