# onon-site

The website for [onon](https://github.com/Aethar01/onon), at [ononreader.com](https://ononreader.com): a landing page and the documentation, built with [Astro](https://astro.build) and [Starlight](https://starlight.astro.build).

## Working on it

```sh
npm install
npm run dev       # http://localhost:4321
npm run build     # into dist/
```

The guides in `src/content/docs/docs/` are written by hand. These files are generated from the onon repository, so edit them there:

- `src/content/docs/docs/reference/`: the reference for the latest release, for `main` and for each older release, from onon's `cmd/builddocs`
- `src/content/docs/docs/changelog.md`: from the GitHub releases
- `src/data/release.json`: the latest release's downloads, for the landing page

`scripts/update-generated.sh ../onon` regenerates them from a checkout of onon with its tags. The **Update generated pages** workflow checks onon every hour and, when its `main` branch or latest release has moved since `src/data/onon-source.txt` was written, regenerates them and commits the result. Run it by hand to regenerate now.

## Deploying

Cloudflare Workers builds and serves the site from this repository: build command `npm run build`, deploy command `npx wrangler deploy`, which serves `dist/` as `wrangler.jsonc` says. Every push to `main` deploys, including the generated pages' commits.
