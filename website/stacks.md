# Website Stacks

Orbytes delivers websites using one of three stacks. The stack is chosen during client onboarding based on project complexity, CMS needs, and budget.

---

## Astro + CloudCannon

**When:** Code-heavy sites, content-heavy sites, sites needing a Git-based CMS, sites where performance matters most. Not the default — Framer is the default for most orbytes work.

**Stack:**
- **Scaffold:** `CloudCannon/astro-component-starter` (official CloudCannon starter, fetched via `npx create-astro-component-starter`)
- **Framework:** Astro (static-first, islands architecture)
- **Styling:** Vanilla CSS with CSS custom properties (no Tailwind — the starter is framework-free by design)
- **Components:** Three-file pattern (`.astro` + `.cloudcannon.inputs.yml` + `.cloudcannon.structure-value.yml`) — **Bookshop is soft-deprecated, do not use**
- **CMS:** CloudCannon (Git-based — editors use a visual UI, changes commit to the repo)
- **Hosting:** CloudCannon-built (default — visual preview in editor) / Cloudflare Pages headless (optional)
- **Agent-skills:** 4 of 5 CloudCannon skills installed per-project at `.agents/skills/` (`cloudcannon-configuration`, `cloudcannon-visual-editing`, `cloudcannon-snippets`, `migrating-to-cloudcannon`)
- **Code repo:** Full codebase in GitHub under `williamteig/` (private)

**Scaffold command:** `/new-orbytes-website` with stack choice `astro`

**Key conventions:**
- Component Starter ships with 40+ components in `src/components/building-blocks/`, `page-sections/`, `navigation/` — modify in place, don't rebuild structure
- File-based routing in `src/pages/`
- Content collections for pages, blog, case studies (`src/content/`)
- Design tokens from `brand.md` applied to `src/styles/variables/`
- CloudCannon config in `cloudcannon.config.yml` (pre-populated by starter) — see global rule `cloudcannon.md`
- Component docs at `/component-docs/` (dev-only) — visual builder for all components
- Git: template history is inherited on clone; orbytes commits on top. `upstream` remote points at `CloudCannon/astro-component-starter` for future template pulls
- Branch workflow: `main` = production, `staging` = CloudCannon preview

---

## Framer

**When:** Simpler marketing sites, single-page sites, clients who want to self-edit visually, fast turnaround projects.

**Stack:**
- **Builder:** Framer (visual design + build tool)
- **CMS:** Framer CMS (built-in)
- **Deploy:** Framer hosting (custom domain connected)
- **Code repo:** Minimal — `project.md`, `brand.md`, `CLAUDE.md`, and any custom code

**Scaffold command:** `/new-orbytes-website` with stack choice `framer`

**Key conventions:**
- Design and build happen directly in Framer — no Figma-to-code handoff
- The local repo holds project management files and any CDN-delivered custom code
- Custom code (if needed) is written locally, pushed to GitHub, and delivered via Vercel or jsDelivr CDN
- Framer project URL stored in `project.md` frontmatter (`framer_url`)
- Responsive breakpoints are handled in Framer's visual editor
- Use Framer's built-in interactions/animations — avoid custom JS unless necessary

**CDN code pattern:**
```
repo/
├── project.md
├── brand.md
├── CLAUDE.md
├── src/                    # Custom scripts/styles for CDN delivery
│   ├── scripts/
│   └── styles/
└── package.json            # If using a build step for CDN assets
```

Scripts are embedded in Framer via `<script src="https://cdn.jsdelivr.net/gh/williamteig/[repo]@main/dist/[file].js">` or a Vercel deployment URL.

---

## Webflow (Legacy / Selective)

**When:** Existing Webflow sites being maintained, engagements where Webflow was specifically chosen, clients migrating from Webflow.

**Stack:**
- **Builder:** Webflow Designer
- **CMS:** Webflow CMS
- **Deploy:** Webflow hosting
- **Code repo:** Minimal — `project.md`, `brand.md`, `CLAUDE.md`, and any custom code

**Not the default for new work.** Always confirm in `project.md` whether a Webflow build exists before assuming.

**Key conventions:**
- Webflow site URL stored in `project.md` frontmatter (`webflow_url`)
- CSS approach: Client First naming as inspiration, custom classes preferred
- Breakpoints: Desktop → Tablet → Mobile Landscape → Mobile Portrait
- Custom code follows the same CDN pattern as Framer
- See global rules `webflow.md` for detailed Webflow conventions

---

## Choosing a Stack

| Factor | Astro + CloudCannon | Framer | Webflow |
|--------|-------------------|--------|---------|
| Performance | Best (static HTML) | Good | Good |
| CMS editing | CloudCannon UI | Framer CMS | Webflow CMS |
| Custom code | Full control | CDN embed | CDN embed |
| Design freedom | Unlimited (code) | High (visual) | High (visual) |
| Self-service edits | Via CloudCannon | Native | Native |
| Turnaround speed | Medium | Fast | Medium |
| Cost | Hosting only | Framer plan | Webflow plan |
| Best for | Complex, content-rich | Simple, visual | Legacy, Webflow-native |
