---
description: Conventions for Framer website projects — design, CDN code, and project structure. Apply when working on a Framer-stack project.
alwaysApply: false
---

# Framer Rules

## When Framer is Used

Framer is the stack choice for simpler marketing sites, single-page sites, and fast-turnaround projects. The design and build happen directly in Framer's visual editor — there is no Figma-to-code handoff.

## Project Structure

Framer projects have a minimal local repo:

```
repo/
├── project.md              # Source of truth
├── design.md               # Style reference
├── CLAUDE.md               # Project-level AI instructions
├── .env                    # Proofly/Framer credentials (gitignored — see MCP Access)
└── src/                    # Custom code (if needed)
    ├── scripts/            # JS for CDN delivery
    └── styles/             # CSS for CDN delivery
```

The Framer project URL is stored in `project.md` frontmatter as `framer_url`.

**Repo management:** a Framer repo is a **documentation vault** — local git + iCloud only, **never pushed to GitHub** (no remote, branches, PRs, or worktrees; commit straight to `main`). The site itself lives in Framer's cloud. See `git.md` › Repo Management Policy.

## MCP Access — Proofly (primary, as of 2026-06-02)

orbytes uses **Proofly MCP** (112 tools, headless-capable) as the primary MCP for Framer projects. The first-party `framer-mcp` remains a fallback for in-session relay work, but it requires its plugin tab open every session — Proofly doesn't, once set up. Full reference: 2nd Brain [[proofly]].

**Connector model — one connector serves all projects:**
- A single user-scope `proofly` connector is registered in `~/.claude.json`. The `prooflyToken` in its URL is **account-wide** (confirmed 2026-06-02: same token across TAT and The Code Pizza).
- Every Proofly tool call passes `projectId` + `secret` as **per-call arguments** — read them from the project's `.env`. Do not register per-project connectors.

**Credential scoping:**

| Credential | Scope | Source |
|---|---|---|
| `projectId` + `secret` | Per-project | Proofly MCP plugin panel (open once in the project) |
| `prooflyToken` (`mcp_srv_…`) | Account-wide | Plugin → Server API Access → Generate Token (already done) |
| Framer API key (`fr_…`) | Per-project | Framer Site Settings → General → API Keys (~5yr expiry) |

**Per-project setup (one-time, when the Framer project is created):**
1. Open the project in Framer → open the **Proofly MCP** plugin → copy `projectId` + `secret` from the panel URL.
2. Generate a **Framer API key**: Site Settings → General → API Keys.
3. Save all credentials to the repo-root **`.env`** (gitignored). **Never** put them in `project.md` or any tracked file — the vault is handed to the client at completion.
4. Register headless: `setServerApiKey({projectId, secret, apiKey, projectUrl})`. `projectUrl` must be Framer's **native editor URL** (`https://framer.com/projects/<slug>--<id>`, query params stripped) — Proofly's `projectId` hash is rejected.

**Operational gotchas:**
- Proofly holds the Framer API key **in-memory** (`expiresAfter: process restart`). When calls fail with *"Plugin not connected and no Server API key registered"*, check `getServerApiKeyStatus` and re-run `setServerApiKey` from the project's `.env`.
- **UI-bound tools** (selection, zoom, notify, `htmlSnapshot`) always require the plugin tab open. Headless is *documented* to cover styles, pages, nodes, CMS, code files, audits — but actual handler coverage is unverified. ⚠️ 2026-06-02 (The Code Pizza): registration validated (`registered:true`) yet **all project-reaching calls timed out headless** (searchFonts, getCurrentUser, getAllPages, via connector and raw curl). If headless hangs, fall back to opening the Proofly plugin tab (relay mode) and re-test headless later — and update this note when the cause is known.
- **CMS enum values cannot be written headless** — they silently fall back to the first case. Set enums via plugin-relay (tab open).
- `secret`/`prooflyToken` are full write credentials baked into URLs — treat like passwords, never commit.

## Design Conventions

- Design directly in Framer — do not create separate Figma mockups unless the project also needs a Figma file for a specific reason
- Use Framer's built-in responsive breakpoints
- Use Framer's built-in interactions and animations — avoid custom JS unless necessary
- Use Framer CMS for any structured content (blog posts, team members, etc.)
- Apply brand tokens from `design.md` to Framer's design system (colors, fonts)

## Custom Code via CDN

When a Framer site needs custom JavaScript or CSS beyond what Framer provides:

1. Write the code locally in `src/scripts/` or `src/styles/`
2. Push to GitHub
3. Deliver via CDN — either:
   - **jsDelivr:** `https://cdn.jsdelivr.net/gh/williamteig/[repo]@main/src/scripts/[file].js`
   - **Vercel:** Deploy the repo and use the Vercel URL
4. Embed in Framer via custom code block (`<script>` or `<link>`)

## Gotchas

**Gotcha — Framer has no local development.**
Unlike Astro, there is no `npm run dev`. All design and layout work happens in Framer's web editor. The local repo is only for project management files and custom code.

**Gotcha — Framer CMS is not Git-based.**
Content lives inside Framer, not in local markdown files. If the client needs Git-based content management, use Astro + CloudCannon instead.

**Gotcha — custom fonts need to be uploaded to Framer.**
Framer supports Google Fonts natively. For custom/self-hosted fonts, upload the font files directly in Framer's font settings.

**Gotcha — `GF;Manrope-*` selectors are deprecated; use `FS;Manrope-*` (Fontshare).**
Several popular Google Fonts (including Manrope) have been moved to Fontshare inside Framer. Setting font via MCP with `GF;Manrope-700` still resolves, but Framer flags it as "Manrope (Deprecated)" in the font picker UI. The current selector is `FS;Manrope-{light|regular|medium|semibold|bold|extrabold|variable}`. When unsure for any font, use the `searchFonts` MCP tool (or look at Framer's picker for "(Deprecated)" tags) before applying. See [[framer-mcp#Font selectors]].

**Gotcha — Framer Styles panel flattens slash-namespaced names.**
A style named `Neutral / Surface Main` shows in the Styles panel as just `Surface Main` under the `Color` folder. Full path is only visible in the picker dropdown, the inspector, and MCP responses. For [[framepad]]-based projects (where there are hundreds of slash-namespaced styles), install the **Style Manager** plugin (Framer Marketplace) for orientation. See [[framer-mcp#Style management caveats]] and [[framer-gotchas#Styles panel hides folder prefixes]].

**Gotcha — MCP can't delete color or text styles.**
`manageColorStyle` / `manageTextStyle` only expose `create` and `update` (verified on first-party framer-mcp; Proofly exposes the same pair — confirm before assuming delete exists). Style deletion is manual in Framer's UI (right-click style → Delete in the Styles panel). Plan an end-of-session manual cleanup pass when LLM-driven token work creates duplicates or leftovers.
