# /add-product — Add a Product to the Brain

You are adding a product to an existing brain. Each product gets a self-contained folder under `products/` with its own roadmap, engineering docs, product docs, operations docs and session history.

The product may be new, or it may be an existing project with code and a history. An existing project has most of the answers written down already: read them there instead of asking for them.

**Before starting:** the brain must exist. If a directory holds the installed commands and `templates/` but no `BRAIN-INDEX.md`, the brain has not been initialised: tell the user to run `/init-brain` first and stop.

## Brain Root

Every brain path in this command (`BRAIN-INDEX.md`, `products/...`, `templates/...`, `scripts/...`) is relative to the **brain root**, not to the working directory. The brain root is the directory that holds both `BRAIN-INDEX.md` and `products/`: either the working directory or one attached with `--add-dir`. Find it first. If no such directory is available, stop and tell the user to attach the brain with `claude --add-dir /path/to/brain`. If the brain's `CLAUDE.md` is not in context, read it from the brain root. Run the link checker as `<brain root>/scripts/check-links.sh <brain root>`.

## Phase 1: Discovery Interview

### Find the Code First

Before asking anything else, establish whether code exists and where it lives.

- A path or URL given with the command is the code location.
- If the working directory is a code repository that is neither the brain root nor the code location of a product in `products/README.md`, suggest it and confirm.
- Otherwise ask: **Does code exist already, and where does it live?** Ask for a path or repository URL; "nowhere yet" is a valid answer.

If the code location is a directory this session can read, inspect it before the interview. If there is no code yet, or only a URL, go straight to the interview and ask every question.

### Inspect the Code Location

Read only. Nothing in the code repository changes in this phase.

1. **The project.** The README, the build manifest (`package.json`, `Cargo.toml`, `pyproject.toml` or similar) and the top-level layout. They give the name, the description, the target users, the stack and the architecture.
2. **The history.** `git log`: the date of the first commit, the date of the latest one, and the tags. The first commit dates the start of the product. The log shows what is already done.
3. **Public or private.** `git remote -v` shows where the repository is published. Find out whether it is public, for example with `gh repo view --json visibility`. If you cannot tell, ask in the interview. Phase 3 depends on the answer.
4. **Operations.** CI configuration, container files, deployment scripts. Never copy a secret into the brain.
5. **Claude Code entry points.** List the repository root and its `.claude/` folder with `ls -la`. A listing of regular files hides symlinks. Note `CLAUDE.md`, `CLAUDE.local.md`, commands and settings files, and where each symlink points. Project rules in `CLAUDE.md` are a source for `engineering/Conventions.md`.
6. **Per-project memory.** Claude Code keeps memory per working directory under `~/.claude/projects/`, in a folder named after the code location with every `/` replaced by `-`, the leading one included: `/home/me/code/app` → `~/.claude/projects/-home-me-code-app/memory/`. Note what it says about the project. If the session is not allowed to read that folder, say so in the summary and give the user the path to check.

**A legacy vault is a case for `/migrate`.** If the repository holds a vault in the original layout (a `BRAIN-INDEX.md` with no `products/` beside it, numbered folders such as `00_Company/`), or if its `CLAUDE.md` or `.claude/commands` is a symlink into one, say so and point the user to `/migrate <path to the vault>`, which imports the vault and moves the repository onto this brain. Continue here only if the user wants a fresh product folder anyway.

### The Interview

Ask **one at a time**, conversationally. If the product name was already given (for example by `/init-brain`), skip question 1.

1. **What are you building?** Product name and a one-sentence description.
2. **Who is it for?** Target users.
3. **What is the tech stack?** Languages, frameworks, infrastructure.
4. **What are the top 3 priorities right now?**
5. **Any hard constraints?** Deadlines, budget, team size, platform requirements.
6. **What does "done" look like for the next milestone?**
7. **Status?** `active` (default), `paused` or `maintenance`.

**After an inspection, do not ask what the code already answered.** Show what you found first: a draft answer for every question the inspection covers, each with its source (`README.md`, the git history, `Cargo.toml`). Let the user correct the drafts. Then ask the open questions one at a time. Questions 4 and 6 are decisions, not facts: always ask them. You may suggest answers from what you found, marked as suggestions.

Then propose a **slug**: the product name in lowercase kebab-case (`Addon Manager` → `addon-manager`). Confirm it with the user. It must not match an existing folder in `products/`.

## Phase 2: Generate the Product Folder

Create `products/<slug>/` with this structure. Every file gets **real content from the answers and the inspection**, not empty templates.

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
   **Started:** [date work on the product began]
   **Added to this brain:** [today's date]

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

   *Started* is when work on the product began, not when it entered the brain. For existing code it is the date of the first commit, or the date the user gives if there is no git history. For a new product it is today's date. Leave out the *Added to this brain* line when both dates are the same.

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

   If code already exists, the plan starts with the work that is done: `completed` phases and steps reconstructed from the git history and the inspection, with the commits they come from. Say in the plan that they are reconstructed and that their effort values are estimates. The open work follows, planned as above. Say so in the summary.

3. **Product-level docs** (`MVP-Scope.md`, `Feature-Priorities.md`, `User-Stories.md`) — Parent line `> Part of [Product Name](README.md)`. Derived from the interview and the inspection: the milestone defines the MVP scope, the priorities seed the feature list, the target users seed the stories. Cross-link them (`MVP-Scope.md` ↔ `Feature-Priorities.md` ↔ `User-Stories.md`).

4. **Folder indexes** (`features/README.md`, `engineering/README.md`, `operations/README.md`, `handoffs/README.md`, `engineering/adr/README.md`) — Parent line pointing to the product README (the ADR index points to `engineering/README.md`). Describe what the folder covers and link every file in it. `features/README.md` starts with an empty *Index* list; `/feature` adds specs there.

5. **Leaf files** — Parent line pointing to their folder's `README.md`. Real content derived from the interview and the inspection. Cross-link related files (`Architecture.md` ↔ `Tech-Stack.md`). Where neither gave anything (for example no monitoring yet), write a short note saying so and what the likely first step is, rather than leaving the file empty.

6. **handoffs/README.md** — Explain that `/wrap-up` writes `handoff-NNN.md` here and `/resume` reads the latest one. Include an empty *Index* list.

### Link Rules

- Relative markdown links only. Paths are relative to the file that contains them.
- Never link from one product folder into another. Shared material belongs in `company/`.
- Refer to code with backticks (`src/main.rs`), not markdown links; the code is not part of the brain.

## Phase 3: Register the Product

1. Add a row to the table in `products/README.md`: `| [Name](<slug>/README.md) | status | Phase N — Name | — | code location |`. The phase is the current one from the execution plan: Phase 1 for a new product.
2. Add a bullet under *Products* in `BRAIN-INDEX.md`: `- [Name](products/<slug>/README.md) — one-liner — **status**, Phase N`
3. If `company/Vision.md` lists products, add this one.
4. If the code lives in its own repository, offer to add a *Brain* section to it. The section lets a session started there find the brain even when the brain's `CLAUDE.md` is not loaded. It holds absolute paths on this machine, so where it goes depends on who can see the repository:

   | File | Use it when | Effect |
   |------|-------------|--------|
   | `CLAUDE.local.md`, listed in the repo's `.gitignore` | The repository is public, or people work in it who do not use this brain | Stays on this machine. Nothing is published |
   | `CLAUDE.md` | The repository is private, and everyone who works in it uses this brain at the same path | Committed with the repo. Loads for everyone who clones it |

   Claude Code loads both files from the working directory. Recommend one and say why. If you do not know whether the repository is public, ask.

   **Ask before editing the code repo**, and say which files change. Then:

   - Check the file with `ls -la` first. If it is a symlink, do not write through it: say where it points and ask.
   - If the file exists, append the section and leave the rest as it is. If not, create it. A new `CLAUDE.local.md` starts with a line saying that it holds paths on this machine and is not committed.
   - For `CLAUDE.local.md`, add the line `CLAUDE.local.md` to the repo's `.gitignore`, unless `git check-ignore CLAUDE.local.md` shows it is ignored already.
   - Do not commit. Tell the user what is left to commit.

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
