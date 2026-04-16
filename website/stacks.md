# Website Stacks

Orbytes delivers websites using one of three stacks. The stack is chosen during client onboarding based on project complexity, CMS needs, and budget.

---

## Astro + CloudCannon (Default)

**When:** Multi-page sites, content-heavy sites, sites needing a Git-based CMS, sites where performance matters most.

**Stack:**
- **Framework:** Astro (static-first, islands architecture)
- **Styling:** Tailwind CSS
- **CMS:** CloudCannon (Git-based — editors use a visual UI, changes commit to the repo)
- **Deploy:** Cloudflare Pages or Vercel
- **Code repo:** Full codebase in GitHub

**Scaffold command:** `/new-orbytes-website` with stack choice `astro`

**Key conventions:**
- File-based routing in `src/pages/`
- Content collections for blog, case studies, etc.
- Design tokens from `brand.md` mapped to `tailwind.config.mjs`
- CloudCannon config in `cloudcannon.config.yml` — see global rule `cloudcannon.md`
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
