import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: '{{SITE_URL}}',
  integrations: [
    tailwind(),
    sitemap(),
  ],
  output: 'static',
});