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

**Never copy a secret into the brain**, whatever the source: operations files, docs, memory. Passwords, tokens and keys are secrets, and so is a recipe for reaching a machine (a user, a host and a key path together). Record only that such access exists and where it is documented. Read an `.env` file for the names of its variables, not their values.

**First, compare the clone with its remote.** The inspection describes the clone on disk. If it is behind, the brain describes an older state. Check before reading anything else, without fetching:

- `git status --short --branch` shows the branch, uncommitted changes, and how far the branch was ahead or behind at the last fetch.
- `git ls-remote <remote> <branch>` gives the remote's current commit. If that commit is not in the clone (`git cat-file -e <commit>` fails), the remote has commits the clone lacks.

If the clone is behind, or holds uncommitted or unpushed work, say so and ask how to go on: the user pulls or commits first, or the inspection describes the clone as it is. Pulling changes the repository, so never pull without a yes. If the remote cannot be reached, say so and go on. Note the commit the inspection reads and how it stands against the remote; the product README records both.

1. **The project.** The README, the build manifest (`package.json`, `Cargo.toml`, `pyproject.toml` or similar) and the top-level layout. They give the name, the description, the target users, the stack and the architecture.
2. **The docs against the code.** Docs fall behind the code, and the brain must not copy what is no longer true. Check the claims a reader acts on against the code at the commit you read: commands to build, run and deploy; file and folder names; configuration keys, ports and versions; listed features and scripts; the architecture described. Where they disagree, the code is right: write the brain's files from the code, and record the claim as a finding (Phase 2, `Feature-Priorities.md`). You need not check every line, but say in the summary what was checked and what was not.
3. **The history.** `git log`: the date of the first commit, the date of the latest one, and the tags. The first commit dates the start of the product. The log shows what is already done.
4. **Public or private, and other clones.** `git remote -v` shows where the repository is published. Find out whether it is public, for example with `gh repo view --json visibility`. Then look for clones on other machines: authors in `git log` other than the user, such as an agent's commits; docs or deploy scripts that clone the repo onto a server; notes about resuming on another PC. If you cannot tell, ask in the interview. Phase 3 depends on both answers.
5. **Operations.** CI configuration, container files, deployment scripts.
6. **Claude Code entry points.** List the repository root and its `.claude/` folder with `ls -la`. A listing of regular files hides symlinks. Note `CLAUDE.md`, `CLAUDE.local.md`, commands, skills and settings files, and where each symlink points. Project rules in `CLAUDE.md` are a source for `engineering/Conventions.md`.

   Compare the names of the repo's commands and skills with the brain's ten commands. Both sets load in a session started in the repo. With the same name, the repo's copy runs and hides the brain's: say which. With names that nearly collide or jobs that overlap (`/wrapup` and `/wrap-up`, `/pickup` and `/resume`), the user must know which to run and in which order. Record both cases in `engineering/Conventions.md`, and settle the order with the user (see *When the Repo Leads* in Phase 2).
7. **Work tracked in the repo.** A repo may already track its own work: `TODO.md`, `HANDOFF.md`, `ROADMAP.md`, a `plans/` or `docs/handoff/` folder, issues on the forge, and commands or skills that write them. For each, note what it holds, when it last changed (`git log -1 -- <path>`), and who reads it: people, a CI job, an agent working in another clone, a session on a machine without this brain. A record that something outside this machine reads is a reason for the repo to keep leading (question 8).
8. **Per-project memory.** Claude Code keeps memory per working directory under `~/.claude/projects/`, in a folder named after the code location with every `/` replaced by `-`, the leading one included: `/home/me/code/app` → `~/.claude/projects/-home-me-code-app/memory/`. If the session is not allowed to read that folder, say so in the summary and give the user the path to check. Sort every entry:
   - **A fact about this project:** a source for the brain. Check it against the code like the docs (item 2).
   - **Open work:** treat it like the repo's tracking files (item 7). It is still open only if the code and the log do not show it done.
   - **No longer true:** list it for the user with a proposed edit (Phase 3, step 6).
   - **About another product, or the whole machine:** not copied into this product's folder. Name it in the summary: it belongs to that product, or to `company/`.
   - **Access to a machine or a service:** not copied (see above). Note that it exists.

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
8. **Where is open work tracked from now on?** Ask only when the inspection found work tracked in the repo. Two lists of open work drift apart, so one place leads:
   - **The brain leads** (recommend it by default). The open items of the repo's files are carried into the execution plan and the feature priorities. Then ask what becomes of each file: a pointer to the brain, a frozen record with a line saying it is no longer updated, or left as it is. If the repo's `CLAUDE.md` describes the old workflow, it needs a change too. Changes to the repo are made in Phase 3, after asking.
   - **The repo leads** (recommend it when something outside this machine reads the repo's record). The repo's files stay the working record, and the product folder holds the product view: see *When the Repo Leads* in Phase 2.

**After an inspection, do not ask what the code already answered.** Show what you found first: a draft answer for every question the inspection covers, each with its source (`README.md`, the git history, `Cargo.toml`). Let the user correct the drafts. List the findings of the docs check with them, and the state of the clone against its remote. Then ask the open questions one at a time. Questions 4, 6 and 8 are decisions, not facts: always ask them. You may suggest answers from what you found, marked as suggestions. If the docs check found several mismatches, suggest bringing the docs in line with the code as one of the priorities.

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
   - **Latest commit:** [hash and date of the commit the inspection read, and how it stands against the remote: level with `origin/main`, N commits behind, uncommitted changes]
   - **Last updated:** [today's date]
   ```

   *Started* is when work on the product began, not when it entered the brain. For existing code it is the date of the first commit, or the date the user gives if there is no git history. For a new product it is today's date. Leave out the *Added to this brain* line when both dates are the same. Leave out *Latest commit* when there is no code yet.

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

   The size rule of 3–4 phases with 3–5 steps is for the open work. The completed part takes as many phases as the history needs, but keep it coarse: a phase per major version or period of work, a step per feature or release, never a step per commit. The tasks name the commits; the log keeps the detail. For a long history, merge steps before adding more.

3. **Product-level docs** (`MVP-Scope.md`, `Feature-Priorities.md`, `User-Stories.md`) — Parent line `> Part of [Product Name](README.md)`. Derived from the interview and the inspection: the milestone defines the MVP scope, the priorities seed the feature list, the target users seed the stories. Cross-link them (`MVP-Scope.md` ↔ `Feature-Priorities.md` ↔ `User-Stories.md`).

   The findings of the docs check go into `Feature-Priorities.md`, in a section *Findings in the Docs*. Say which commit was checked and what was not checked, then one row per finding:

   ```markdown
   | # | File | It says | The code says | Since |
   |---|------|---------|---------------|-------|
   | 1 | `README.md`, setup | Port 8080 | `docker-compose.yml` maps 8181 | `a1b2c3d`, 2026-06-17 |
   ```

   *Since* is the commit that made the doc wrong, when the history shows it. Leave the section out when the check found nothing, and say so in the summary.

4. **Folder indexes** (`features/README.md`, `engineering/README.md`, `operations/README.md`, `handoffs/README.md`, `engineering/adr/README.md`) — Parent line pointing to the product README (the ADR index points to `engineering/README.md`). Describe what the folder covers and link every file in it. `features/README.md` starts with an empty *Index* list; `/feature` adds specs there.

5. **Leaf files** — Parent line pointing to their folder's `README.md`. Real content derived from the interview and the inspection. Cross-link related files (`Architecture.md` ↔ `Tech-Stack.md`). Where neither gave anything (for example no monitoring yet), write a short note saying so and what the likely first step is, rather than leaving the file empty.

6. **handoffs/README.md** — Explain that `/wrap-up` writes `handoff-NNN.md` here and `/resume` reads the latest one. Include an empty *Index* list.

7. **ADR-001** — If question 8 was asked, record the answer as `engineering/adr/ADR-001-<topic>.md` from `templates/ADR-Template.md`, listed in the ADR index: the repo's files and their state, who reads them, the decision, what becomes of each file, and the alternative not chosen.

### When the Repo Leads

If the answer to question 8 is that the repo leads, the repo's files stay the working record and the brain must not grow a second one. Change the files above as follows:

- **README.md** gets a section *Where Work Is Tracked* that names the repo's files and links ADR-001. *Current Status* adds a line *Resume point in the repo* (for example the latest session in `HANDOFF.md`). If the repo has its own commands for the start and end of a session, add a table with the order of the steps: at the start `/resume`, then the repo's; at the end the repo's, then `/wrap-up`.
- **Execution-Plan.md** stays at the level of the milestone. A step names the entry or plan file in the repo by path and does not restate its tasks. Say so at the top of the plan.
- **features/README.md** says where specs are written in the repo, and with which command. The *Index* stays empty. `/feature` is for a spec that concerns the brain only.
- **handoffs/README.md** says that a handoff here is short and points at the repo's resume point, with a table of what it holds: the pointer (the repo's session and commit), the steps of the plan that moved, what concerns only the brain, and what waits for the user. Where the brain and the repo disagree, the repo is right.

### Link Rules

- Relative markdown links only. Paths are relative to the file that contains them.
- Never link from one product folder into another. Shared material belongs in `company/`.
- Refer to code with backticks (`src/main.rs`), not markdown links; the code is not part of the brain.

## Phase 3: Register the Product

1. Add a row to the table in `products/README.md`: `| [Name](<slug>/README.md) | status | Phase N — Name | — | code location |`. The phase is the current one from the execution plan: Phase 1 for a new product.
2. Add a bullet under *Products* in `BRAIN-INDEX.md`: `- [Name](products/<slug>/README.md) — one-liner — **status**, Phase N`
3. If `company/Vision.md` lists products, add this one.
4. If the code lives in its own repository, offer to add a *Brain* section to it. The section lets a session started there find the brain even when the brain's `CLAUDE.md` is not loaded. It holds absolute paths on this machine, so where it goes depends on where the repository is cloned. A clone where the brain does not exist would be pointed at a brain it cannot reach, whether a person, a second machine or an agent works in it:

   | File | Use it when | Effect |
   |------|-------------|--------|
   | `CLAUDE.local.md`, listed in the repo's `.gitignore` | Any clone lives where this brain is not: the repository is public; someone works in it without this brain; it is cloned on a server, another PC, or for an agent | Stays in this clone. Nothing is published, and other clones see nothing |
   | `CLAUDE.md` | The repository is private, and every clone of it is used with this brain at the same path, typically one user on one machine | Committed with the repo. Loads in every clone |

   Claude Code loads both files from the working directory. Recommend one and say why, naming the clones you found. If you do not know whether the repository is public or where else it is cloned, ask.

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

   When the repo leads (question 8), the last sentence names the repo's own steps too, in their order: for example "Start with `/resume <slug>`, then `/pickup`. End with `/wrapup`, then `/wrap-up`."
5. If the brain leads (question 8) and the user chose to change the repo's tracking files, make those changes now, under the same rules as step 4: ask first and name the files, check for symlinks, do not commit. Carry every open item into the brain before a file becomes a pointer.
6. If the per-project memory holds entries that are no longer true, or open work that the brain now tracks, propose an edit for each: a correction, a removal, or a line pointing at the brain. Memory lies outside both the brain and the repo, so change a file only after the user agrees to that edit.

## Phase 4: Verify and Summarise

1. Run `scripts/check-links.sh` and fix anything it reports.
2. Show the tree of created files and the count.
3. **Summarise from the product folder.** Report what the inspection read and at which commit, how the clone stands against its remote, the findings of the docs check and what was not checked, the answer to question 8, the memory entries proposed for an edit or belonging elsewhere, and what changed in the code repo and is left to commit. Before you show it, check each statement against the product folder: every finding, decision and open item must be in one of its files, and every number must be counted from them. Add to the folder what is missing there, and run the link checker again if a file changed. Then say where each part is recorded.
4. If the code lives in its own directory, give the user the start command for product work and suggest a shell alias for it: `cd <code path> && CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir <brain root>`. Starting in the code repo is what makes its hooks, permission rules and `CLAUDE.md` load.
5. Suggest `/resume <slug>`.
