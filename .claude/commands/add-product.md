# /add-product — Add a Product to the Brain

You are adding a product to an existing brain. Each product gets a self-contained folder under `products/` with its own roadmap, engineering docs, product docs, operations docs and session history.

**Before starting:** the brain must exist. If a directory holds the installed commands and `templates/` but no `BRAIN-INDEX.md`, the brain has not been initialised: tell the user to run `/init-brain` first and stop.

## Brain Root

Every brain path in this command (`BRAIN-INDEX.md`, `products/...`, `templates/...`, `scripts/...`) is relative to the **brain root**, not to the working directory. The brain root is the directory that holds both `BRAIN-INDEX.md` and `products/`: either the working directory or one attached with `--add-dir`. Find it first. If no such directory is available, stop and tell the user to attach the brain with `claude --add-dir /path/to/brain`. If the brain's `CLAUDE.md` is not in context, read it from the brain root. Run the link checker as `<brain root>/scripts/check-links.sh <brain root>`.

## Phase 1: Discovery Interview

Ask **one at a time**, conversationally. If the product name was already given (for example by `/init-brain`), skip question 1.

1. **What are you building?** Product name and a one-sentence description.
2. **Who is it for?** Target users.
3. **What is the tech stack?** Languages, frameworks, infrastructure.
4. **What exists already, and where does the code live?** Existing codebase, MVP, or nothing yet. Ask for a path or repository URL; "nowhere yet" is a valid answer.
5. **What are the top 3 priorities right now?**
6. **Any hard constraints?** Deadlines, budget, team size, platform requirements.
7. **What does "done" look like for the next milestone?**
8. **Status?** `active` (default), `paused` or `maintenance`.

Then propose a **slug**: the product name in lowercase kebab-case (`Addon Manager` → `addon-manager`). Confirm it with the user. It must not match an existing folder in `products/`.

## Phase 2: Generate the Product Folder

Create `products/<slug>/` with this structure. Every file gets **real content from the answers**, not empty templates.

```
products/<slug>/
  README.md               Product index
  Execution-Plan.md       Phased roadmap
  MVP-Scope.md            What the first shippable version includes and excludes
  Feature-Priorities.md   Ranked feature list, linking to specs in features/
  User-Stories.md         Who needs what, and why
  features/
    README.md             Feature spec index
  engineering/
    README.md
    Architecture.md
    Tech-Stack.md
    Conventions.md
    adr/
      README.md           Architecture Decision Records index
  operations/
    README.md
    Environments.md
    CI-CD.md
    Monitoring.md
  handoffs/
    README.md
```

### Content Rules

1. **README.md** (product index) — Parent line `> Part of [Products](../README.md)`, then:

   ```markdown
   # [Product Name]

   > [One-sentence description]

   **Status:** active
   **Code:** [path, URL, or "not started"]
   **Stack:** [short list]
   **Started:** [today's date]

   ## Quick Links
   - [Execution Plan](Execution-Plan.md) — roadmap and task status
   - [MVP Scope](MVP-Scope.md) — what ships first, and what doesn't
   - [Feature Priorities](Feature-Priorities.md) — ranked features and their specs
   - [User Stories](User-Stories.md) — who needs what, and why
   - [Features](features/README.md) — feature specs
   - [Engineering](engineering/README.md) — architecture, stack, conventions, ADRs
   - [Operations](operations/README.md) — environments, CI/CD, monitoring
   - [Handoffs](handoffs/README.md) — session continuity

   ## Current Status
   - **Phase:** [current phase from the execution plan]
   - **Next milestone:** [from the interview]
   - **Last updated:** [today's date]
   ```

   `/wrap-up` keeps *Current Status* up to date.

2. **Execution-Plan.md** — Parent line `> Part of [Product Name](README.md)`. Generate 3–4 phases with 3–5 steps each from the priorities and the milestone. Use the step format from `CLAUDE.md`:

   ```markdown
   ## Phase 1: [Name]
   **Status:** not_started | in_progress | completed
   **Target:** [date or milestone]

   ### Step 1.1: [Name]
   - **Status:** not_started
   - **Effort:** S | M | L | XL
   - **Dependencies:** none | Step X.Y
   - **Description:** [1-2 sentences]
   - [ ] Task 1
   - [ ] Task 2
   ```

   If code already exists, mark what is evidently done as `completed` and say so in the summary.

3. **Product-level docs** (`MVP-Scope.md`, `Feature-Priorities.md`, `User-Stories.md`) — Parent line `> Part of [Product Name](README.md)`. Derived from the interview: the milestone defines the MVP scope, the priorities seed the feature list, the target users seed the stories. Cross-link them (`MVP-Scope.md` ↔ `Feature-Priorities.md` ↔ `User-Stories.md`).

4. **Folder indexes** (`features/README.md`, `engineering/README.md`, `operations/README.md`, `handoffs/README.md`, `engineering/adr/README.md`) — Parent line pointing to the product README (the ADR index points to `engineering/README.md`). Describe what the folder covers and link every file in it. `features/README.md` starts with an empty *Index* list; `/feature` adds specs there.

5. **Leaf files** — Parent line pointing to their folder's `README.md`. Real content derived from the interview. Cross-link related files (`Architecture.md` ↔ `Tech-Stack.md`). Where the interview gave nothing (for example no monitoring yet), write a short note saying so and what the likely first step is, rather than leaving the file empty.

6. **handoffs/README.md** — Explain that `/wrap-up` writes `handoff-NNN.md` here and `/resume` reads the latest one. Include an empty *Index* list.

### Link Rules

- Relative markdown links only. Paths are relative to the file that contains them.
- Never link from one product folder into another. Shared material belongs in `company/`.
- Refer to code with backticks (`src/main.rs`), not markdown links; the code is not part of the brain.

## Phase 3: Register the Product

1. Add a row to the table in `products/README.md`: `| [Name](<slug>/README.md) | status | Phase 1 — Name | — | code location |`
2. Add a bullet under *Products* in `BRAIN-INDEX.md`: `- [Name](products/<slug>/README.md) — one-liner — **status**, Phase 1`
3. If `company/Vision.md` lists products, add this one.
4. If the code lives in its own repository, offer to add a *Brain* section to that repo's `CLAUDE.md` (create the file if there is none). Ask before editing the code repo. The section lets a session started there find the brain even when the brain's `CLAUDE.md` is not loaded:

   ```markdown
   ## Brain

   This project's long-term memory lives outside this repo.

   - **Brain root:** `<absolute path to the brain root>`
   - **Product folder:** `products/<slug>/` inside the brain root (slug `<slug>`)

   Every path a brain command mentions is relative to the brain root, not to this repo. The brain's rules are in `CLAUDE.md` at the brain root; read it if it is not already in context. Start with `/resume <slug>`, end with `/wrap-up`.
   ```

## Phase 4: Verify and Summarise

1. Run `scripts/check-links.sh` and fix anything it reports.
2. Show the tree of created files and the count.
3. If the code lives in its own directory, give the user the start command for product work and suggest a shell alias for it: `cd <code path> && CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir <brain root>`. Starting in the code repo is what makes its hooks, permission rules and `CLAUDE.md` load.
4. Suggest `/resume <slug>`.
