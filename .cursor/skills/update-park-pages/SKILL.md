---
name: update-park-pages
description: >-
  Maintains Jekyll park issue pages in wheresourplayground: fresh copy, West Seattle Blog
  citations, Seattle Parks links, ribbons, timelines, city-council data, and section styling.
  Use when updating _parks, refreshing park content from WSB or seattle.gov, adding a park
  page, or the user asks to keep park pages current.
---

# Update park pages (Where Is Our Playground)

## Scope

- **Pages:** `_parks/*.html` (not `_template.html` unless copying it).
- **Timeline data:** `_data/parks/*.yml` when a park uses `site.data.parks.…` (e.g. Lincoln).
- **Council contacts:** `_data/city-council.yml` — verify against [Meet the Council](https://www.seattle.gov/council/meet-the-council).
- **Site config:** `_config.yml` if new root dev files must be `exclude`d from Jekyll.

## Source order

1. **`parks-dept.link`** on the page front matter — official status, PDFs, engagement URLs.
2. **West Seattle Blog** — search `site:westseattleblog.com` plus park/neighborhood names; prefer article URLs over memory. Note **publication date** vs **event date** (correct in copy).
3. **Cross-links** — sibling pages under `/parks/…/` when projects are related (e.g. Hiawatha play area ↔ community center).

## Copy rules

- **Completed vs open:** If a project has reopened or finished, rewrite lead/welcome/ribbon so nothing still says “today we wait” or “years without.” Keep a short accountability angle if the site mission warrants it.
- **Ribbon:** See [Ribbons](#ribbons) below.
- **Updates section:** Newest first; each bullet ties to a **specific WSB post** or official page; include full `https://` link, `target="_blank"` `rel="noopener noreferrer"`, and `class="link-light"` on dark bands.
- **Front matter:** Refresh `description` and `keywords` when the story changes; keep `open-graph.image` path valid.

## Ribbons

Folded corner on park pages and on the homepage project cards.

| Front matter | Effect |
|--------------|--------|
| `ribbon-text:` | **Required** to show a ribbon. Empty or omitted → no ribbon (see `_parks/_template.html` for placeholders). Short phrase only; it appears on cards and the park hero. |
| `ribbon_complete: true` | **Green** fold — use when the **park project** (rebuild, major repair, reopening) is done. Copy on the page should match (no “still closed” whiplash). |
| `ribbon_new: true` | **Yellow** fold — use when a page is **newly tracked** on the site. |

**Precedence:** If both `ribbon_complete` and `ribbon_new` are true, **green wins** (complete beats new).

**Implementation (do not drift):**

- Park body: `{% include park-ribbon.html %}` — reads `page.ribbon-text`, `page.ribbon_complete`, `page.ribbon_new`.
- Homepage cards: `index.html` — ribbon classes on each `p`; grid shows **in-progress** (no `ribbon_complete`) first, **completed** last, **A–Z by title** within each group, at most **`homepage_parks_limit`** cards (`_config.yml`, default 10). Pages with **`published: false`** are omitted.
- Styles: `assets/css/style.css` — base `.ribbon` (red), `.ribbon.ribbon-complete::before`, `.ribbon.ribbon-new` / `::before` (yellow with dark text).

- **`section-links`** `id`s must match `id` on each major band (`#welcome`, `#updates`, etc.).
- **Adjacent bands:** Do not stack two blocks with the same Bootstrap `text-bg-*`. Typical alternation: `text-bg-success` → `text-bg-secondary` → `text-bg-info` (or `text-bg-dark` only if intentional). Fix typos like `conatiner-fluid` → `container-fluid`.
- **Carousel:** One slide per distinct image; fix duplicate `active` items; meaningful `alt` text.
- **`{% include how-to-help.html %}`** expects `parks-dept` and `city-council.district` (and optional `contact`). Fix broken HTML in includes if you touch nearby templates.

## Verification

- Run `bundle exec jekyll build` and fix Liquid/HTML errors.
- After council elections or roster changes, update **`_data/city-council.yml`** (names, emails, `/council/members/…` URLs, `206-684-8801`–`8809` phones by seat).

## Quick checklist

```
- [ ] WSB + Parks sources opened; dates in copy match articles
- [ ] Completed projects: no stale “still closed” language
- [ ] Updates list ordered; links and link-light on dark sections
- [ ] Adjacent sections use different text-bg-* / container spelling
- [ ] Carousel / OG / description consistent with ribbon flags (see Ribbons section above)
- [ ] Ribbons: `ribbon-text` matches story; `ribbon_complete` / `ribbon_new` only when accurate; precedence respected
- [ ] Optional: city-council.yml if Seattle roster changed
- [ ] jekyll build passes
```
