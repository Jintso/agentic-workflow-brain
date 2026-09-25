# CLAUDE.md — Brain Operating Instructions

> Loaded automatically at the start of every Claude Code session started from this directory.
> It tells Claude how to work inside this brain.

## What This Directory Is

A **brain**: a folder of plain markdown files holding long-term memory for one organisation and every product it builds. Claude reads it at the start of a session and updates it at the end, so nothing is lost between sessions.

- **Organisation:** [ORG_NAME]
- **What we build:** [ONE_LINE_DESCRIPTION]
- **Products:** see `products/README.md`

## Session Protocol

1. **Start:** read `BRAIN-INDEX.md`, resolve the product (below), then read that product's `README.md`, `Execution-Plan.md` and the latest file in its `handoffs/`. `/resume` does this.
2. **End:** run `/wrap-up` to write a handoff and update the execution plan.
3. **Never assume context** from a previous conversation. Read the files.

## Product Resolution

Most commands act on one product. Resolve it in this order:

1. An explicit argument matching a folder name in `products/` (`/resume addon-manager`).
2. The product already being worked on in this conversation.
3. If exactly one product exists, that one.
4. Otherwise list the products from `products/README.md`, suggest the one with the most recent handoff, and ask.

Never guess silently between two products.

## Layout

```
BRAIN-INDEX.md              Entry point
CLAUDE.md                   This file
company/                    Shared context: vision, values, cross-product sprints
products/README.md          Portfolio index (one row per product)
products/<slug>/            One self-contained folder per product
  README.md                 Product index: description, code location, current status
  Execution-Plan.md         Phased roadmap with step statuses
  MVP-Scope.md              What ships first, and what doesn't
  Feature-Priorities.md     Ranked features, linking to specs
  User-Stories.md           Who needs what, and why
  features/                 Feature specs
  engineering/              Architecture, tech stack, conventions, plans, adr/
  operations/               Environments, CI/CD, monitoring
  handoffs/                 handoff-NNN.md session records, sprint plans
  assets/                   Non-markdown files (optional)
templates/                  Shared templates
scripts/                    check-links.sh
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

## Code Location

Each product README states where its code lives (`**Code:**`). Implementation happens there, not in the brain. When the code is outside this directory, start sessions with:

```
claude --add-dir /path/to/code
```

## Rules

- **Don't delete brain files** without asking. Mark them deprecated instead.
- **Update the execution plan** whenever work completes.
- **Create ADRs** for significant technical decisions.
- **Never skip `/wrap-up`**, even after a short session.
- **Keep product folders self-contained** so a product can be moved out or archived without breaking links.
- **Reference files by path** so the reader can open them.

## Organisation-Wide Conventions

[FILL IN: standards that apply to every product, or "none yet". Product-specific conventions live in each product's engineering/Conventions.md]
