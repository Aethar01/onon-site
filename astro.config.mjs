// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
	site: 'https://ononreader.com',
	trailingSlash: 'always',
	integrations: [
		starlight({
			title: 'onon',
			description: 'A keyboard-driven viewer for PDF, e-books, comics and images, configured in Lua.',
			logo: { src: './src/assets/onon.svg' },
			favicon: '/favicon.svg',
			customCss: ['./src/styles/starlight.css'],
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/Aethar01/onon' }],
			editLink: { baseUrl: 'https://github.com/Aethar01/onon-site/edit/main/' },
			lastUpdated: false,
			head: [
				{ tag: 'link', attrs: { rel: 'preconnect', href: 'https://fonts.googleapis.com' } },
				{ tag: 'link', attrs: { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' } },
				{
					tag: 'link',
					attrs: {
						rel: 'stylesheet',
						href: 'https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible:ital,wght@0,400;0,700;1,400&family=JetBrains+Mono:wght@400;600&family=Literata:opsz,wght@7..72,500;7..72,650&display=swap',
					},
				},
			],
			sidebar: [
				{
					label: 'Start here',
					items: [
						{ label: 'Getting started', slug: 'docs' },
						{ label: 'Upgrading from gopdf', slug: 'docs/upgrading' },
					],
				},
				{
					label: 'Guides',
					items: [
						{ label: 'Reading', slug: 'docs/reading' },
						{ label: 'Configuration', slug: 'docs/configuration' },
						{ label: 'Themes', slug: 'docs/themes' },
						{ label: 'Scripting with Lua', slug: 'docs/scripting' },
						{ label: 'Plugins', slug: 'docs/plugins' },
						{ label: 'Command line and editors', slug: 'docs/command-line' },
					],
				},
				{
					label: 'Reference',
					items: [
						{ label: 'Reference', slug: 'docs/reference' },
						{ label: 'Development version', slug: 'docs/reference/main' },
						{ label: 'Older versions', collapsed: true, items: [{ autogenerate: { directory: 'docs/reference/versions' } }] },
					],
				},
				{ label: 'Changelog', slug: 'docs/changelog' },
			],
		}),
	],
});
