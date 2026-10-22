# CLAUDE.md — Brain Operating Instructions

> Loaded automatically at the start of every Claude Code session started from this directory.
> A session started in a product's code repo loads it when the brain is attached and `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1` is set.
> It tells Claude how to work inside this brain.

This file is a map. Each section says in a few lines what it covers. The rules that hold for every brain edit are written here; everything else is a pointer that says when to read which file.

## What This Directory Is

A **brain**: a folder of plain markdown files holding long-term memory for one organisation and every product it builds. Claude reads it at the start of a session and updates it at the end, so nothing is lost between sessions.

- **Organisation:** [ORG_NAME]
- **What we build:** [ONE_LINE_DESCRIPTION]
- **Products:** see `products/README.md`

## Brain Root

The **brain root** is the directory that holds this file, `BRAIN-INDEX.md` and `products/`. Every brain path in this file and in the slash commands is relative to the brain root, not to the working directory.

- The brain root is either the working directory or a directory attached with `--add-dir`. Find it before reading or writing any brain file.
- A `BRAIN-INDEX.md` with no `products/` folder beside it is a legacy vault, not the brain. Leave it alone.
- Run the link checker as `<brain root>/scripts/check-links.sh <brain root>`, and the path check of every `CLAUDE.md` as `<brain root>/scripts/check-claude-md.sh <brain root>`.

## Session Protocol

1. **Start:** read `BRAIN-INDEX.md`, resolve the product (below), then read that product's `README.md`, `Execution-Plan.md` and the latest file in its `handoffs/`. `/resume` does this. `Execution-Plan-Archive.md` is history: open it only when a question needs the past.
2. **End:** run `/wrap-up` to write a handoff, update the execution plan and replace the product's status.
3. **Never assume context** from a previous conversation. Read the files.

## Compact Instructions

When the conversation is compacted (by `/compact` or automatically), the summary keeps:

- **Where we are:** the product slug, the brain root, the code repo and its branch or worktree, and the Execution Plan step and task in hand.
- **Decisions:** every decision made this session, the user's words quoted where given, who decided, and the alternatives turned down. `/wrap-up` writes them into the handoff.
- **Open items:** questions waiting on the user, blockers, and the next action promised.
- **References, copied exactly:** commit hashes, PR and issue numbers, changed file paths, and measured numbers (test results, counts, costs, the `date` stamps of tasks in flight).
- **Corrections:** anything the user corrected or ruled out, so it isn't proposed again.
- **Templates and formats in use, by path** (`templates/Handoff-Template.md`, *Execution Plan Format* below), not their text. Re-read them after compaction.

It drops tool output, file contents that can be re-read, and dead ends, keeping one line per dead end saying why it failed.

## Product Resolution

Most commands act on one product. Resolve it in this order:

1. An explicit argument matching a folder name in `products/` (`/resume addon-manager`).
2. The product already being worked on in this conversation.
3. The product whose code location is the working directory or contains it. Code locations are in the *Code* column of `products/README.md`.
4. If exactly one product exists, that one.
5. Otherwise list the products from `products/README.md`, suggest the one with the most recent handoff, and ask.

Never guess silently between two products.

## Where Things Are

- `BRAIN-INDEX.md`: the entry point, one line per top folder and per product. Read it at the start of every session.
- `products/README.md`: one row per product with its status, phase, last session and code location. Read it to resolve a product.
- `products/<slug>/README.md`: the product's map: what it is, where its code lives, its current status and next steps, and a link to every file in its folder. Read it first for any work on the product.
- `company/README.md`: the vision, the values in `company/Values.md`, and cross-product sprints. Read it when a decision weighs the values or spans products.
- `templates/README.md`: the handoff, ADR and feature-spec templates. Create those files from them.
- `scripts/`: `check-links.sh` (the link graph), `check-claude-md.sh` (the paths each `CLAUDE.md` names), `session-times.sh` (a session's measured times). `/sync` runs the first two.

Every product folder has the same shape, so a new file's place is never a guess:

```
products/<slug>/
  README.md                  The product's map and its current status
  Execution-Plan.md          The current and coming phases, with step statuses
  Execution-Plan-Archive.md  Finished phases, the old session log and status history
  MVP-Scope.md               What ships first, and what doesn't
  Feature-Priorities.md      Ranked features, linking to specs
  User-Stories.md            Who needs what, and why
  features/                  Feature specs
  engineering/               Architecture, tech stack, conventions, plans, adr/
  operations/                Environments, CI/CD, monitoring
  handoffs/                  handoff-NNN.md session records, sprint plans
  assets/                    Non-markdown files (optional)
```

## File Conventions

### Links
- Standard relative markdown links: `[Architecture](engineering/Architecture.md)`. They render in every editor and forge. No `[[wikilinks]]`.
- Paths are relative to the file that contains them.
- Every file except `BRAIN-INDEX.md` and `CLAUDE.md` starts with a parent line: `> Part of [Engineering](README.md)`.
- Every folder has a `README.md` that links to everything in it.
- Never link from one product's folder into another's. Shared material goes in `company/`.
- Code is referenced in backticks (`src/main.rs`), never linked. The code is not part of the brain.
- `scripts/check-links.sh` verifies all of this. `/sync` runs it.

### Naming
- Folders: lowercase kebab-case (`products/addon-manager/`, `engineering/`).
- Documents: PascalCase with hyphens (`Tech-Stack.md`, `Feature-Priorities.md`).
- Handoffs: `handoff-001.md`, numbered per product.
- ADRs: `ADR-001-short-topic.md`, numbered per product.
- Feature specs: `features/Feature-<Name>.md`.
- Implementation plans: `engineering/Plan-<Step-Name>.md`.

### Content
- **A summary under the title.** A document's first paragraph says in a sentence or two what it holds, and its folder's `README.md` reuses that line as its entry, so the index repeats the document instead of describing it a second time.
- **Templates:** a handoff, an ADR or a feature spec starts from its template in `templates/`.
- **Status is the present only.** A product README's *Current Status*, its row in `products/README.md` and its line in `BRAIN-INDEX.md` are replaced at each `/wrap-up`, never appended to. A session's record is its handoff.

## Execution Plan Format

```markdown
### Step X.Y: [Name]
- **Status:** not_started | in_progress | completed | blocked
- **Effort:** S | M | L | XL
- **Dependencies:** none | Step X.Y
- **Description:** [What this accomplishes]
- [ ] Task 1
- [ ] Task 2
```

- `not_started` — no work done yet
- `in_progress` — actively being worked on
- `completed` — all tasks done and verified
- `blocked` — cannot proceed; reason documented

A phase whose steps are all `completed` moves whole to `Execution-Plan-Archive.md`, and the live plan keeps one line for it: `## Phase N: [Name] — completed YYYY-MM-DD, S/S steps ([archive](Execution-Plan-Archive.md#…))`. Sessions aren't logged in the plan: the handoff is their record.

## Code Location

Each product README states where its code lives (`**Code:**`). Implementation happens there, not in the brain.

**Product work: start in the code repo and attach the brain.**

```
cd /path/to/code
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir /path/to/brain
```

A code repo's hooks, permission rules and `CLAUDE.md` load only when it is the working directory. The brain's slash commands load from an attached directory, and this file loads from one only when the environment variable is set; it then also reaches every subagent the session starts. A product whose main session delegates to subagents can leave the variable off: the brain's commands read this file themselves when it isn't loaded.

**Portfolio work: start in the brain.** `/status all`, `/sprint all`, `/sync`, `/add-product`, `/migrate` and `/init-brain` need no code repo.

A code repo should carry a short *Brain* section naming the brain root and the product slug, so a session finds the brain even when this file is not loaded. The section holds local paths, so it goes into `CLAUDE.local.md` with an entry in `.gitignore` whenever a clone of the repo lives where the brain is not: a public repo, a clone on another machine, an agent's clone. Only a private repo used on this one machine gets it in `CLAUDE.md`. `/add-product` offers to add it.

## Rules

- **Don't delete brain files** without asking. Mark them deprecated, or move finished material to the product's archive.
- **Update the execution plan** whenever work completes.
- **Create ADRs** for significant technical decisions.
- **Never skip `/wrap-up`**, even after a short session.
- **Keep product folders self-contained** so a product can be moved out or archived without breaking links.
- **Reference files by path** so the reader can open them.
- **Fork only when the work needs this conversation.** A fork (the Agent tool's `fork`) copies the whole conversation and re-reads it on every turn. A brief that stands on its own goes to a fresh agent, `general-purpose` or a named one, which starts from its own instructions.

## Organisation-Wide Conventions

The values in `company/Values.md` guide decisions in every product. Product-specific conventions live in each product's `engineering/Conventions.md`. Beyond the values:

- **Times are measured, never estimated.** Every start, end and duration written anywhere — a handoff, a runbook, a plan, a report, an agent's brief — comes from a clock:
  - `date '+%F %T %Z'` when a task starts and again when it ends, written down at the time. A brief handed to an agent asks it to stamp its own start and end the same way.
  - Or a recorded timestamp: the session transcript, a commit, a forge event, a log line.
  - A session's times come from `scripts/session-times.sh`, which reads its transcript. `/wrap-up` copies its `Handoff:` line.
  - A duration is the difference between two such times. A time nobody stamped is written `not recorded`, never guessed.
  - Forecasts stay forecasts: a step's *Effort* size and `/sprint`'s capacity are plans, not records.
- **A `CLAUDE.md` is a map.** This one and every code repo's:
  - **Sections:** each opens with a few lines on what it covers.
  - **Inline:** only the rules that hold on every action, and the *Compact Instructions*, since a compaction sees only what is in context.
  - **Everything else is a one-line pointer** that says when to read its file. A pointer from a code repo names only files its readers may open: if the repo's agents can't read the brain, it points into the repo only.
  - **No copies:** no status, counts or versions, which the files it points to keep current, and no session history, which the handoffs keep.
  - `scripts/check-claude-md.sh` reports any path a `CLAUDE.md` names that no longer exists.
- [FILL IN: the organisation's own standards for every product, one bullet each, or delete this line]
