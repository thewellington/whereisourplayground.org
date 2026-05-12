# Technical setup (developers)

This site is a static [Jekyll](https://jekyllrb.com/) project. Use the steps below to run it locally and verify builds.

## Prerequisites

Pick one:

| Approach | What you need |
|----------|----------------|
| **Nix (recommended)** | [Nix](https://nixos.org/) with flakes, and optionally [direnv](https://direnv.net/) |
| **Plain Ruby** | Ruby matching [`.ruby-version`](.ruby-version) and Bundler |

## Nix + direnv

From the repo root:

1. Allow direnv to load the flake: `direnv allow`
2. Install gems: `bundle install`
3. Serve the site: `bundle exec jekyll serve` (or `bundle exec jekyll build` for a one-off build)

If you are not using direnv, run commands inside the dev shell: `nix develop` (or `nix develop --no-write-lock-file` if you prefer not updating `flake.lock`), then the same `bundle` commands.

The flake pins **Ruby 3.3.x**, **Bundler**, and common native build deps (`pkg-config`, `libffi`). Gems install under `vendor/bundle` via `BUNDLE_PATH` set in the shell hook.

## Without Nix

Install the Ruby version in `.ruby-version`, then:

```bash
bundle install
bundle exec jekyll serve
```

## Useful paths

- **`_parks/`** — park pages (see `_parks/_template.html`).
- **`_config.yml`** — site settings; **`homepage_parks_limit`** caps how many project cards appear on the homepage (in-progress first, then completed).
- **`assets/`** — CSS, images (large assets may use Git LFS; see main README).

## CI

GitHub Actions (`.github/workflows/jekyll.yml`) runs `bundle install` and `bundle exec jekyll build` on pushes and PRs to `main` and `dev`, using Ruby from `.ruby-version`.
