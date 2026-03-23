# CLAUDE.md — Brain DNA

> This file is loaded automatically at the start of every Claude Code session.
> It tells Claude how to work within this vault.

## Project

- **Name:** [PROJECT_NAME]
- **Description:** [ONE_LINE_DESCRIPTION]
- **Tech Stack:** [STACK]
- **Repository:** [REPO_URL or "this vault"]

## Session Protocol

1. **Every session starts with:** Read `BRAIN-INDEX.md`, then the latest handoff in `Handoffs/`.
2. **Every session ends with:** Run `/wrap-up` to create a handoff document.
3. **Never assume context** from a previous conversation — always read the brain files.

## File Conventions

### Wikilinks
- Use `[[filename]]` (no paths) — Obsidian resolves them automatically.
- Every file (except BRAIN-INDEX.md) starts with `> Part of [[ParentIndex]]`.
- Cross-link related files generously. The graph view depends on this.

### Naming
- Use PascalCase with hyphens for multi-word files: `Feature-Priorities.md`, `Tech-Stack.md`
- Folder indexes share the folder name: `01_Engineering/Engineering.md`
- Handoffs are numbered: `handoff-001.md`, `handoff-002.md`
- ADRs are numbered: `ADR-001-[topic].md`

### Structure
- Folders are numbered for sort order: `00_`, `01_`, `02_`, `03_`
- Each folder has an index file linking to all contents
- `BRAIN-INDEX.md` links to all folder indexes
- `Templates/` contains reusable templates
- `Assets/` holds non-markdown files (images, PDFs)

## Execution Plan Format

Steps in `Execution-Plan.md` use this format:

```markdown
### Step X.Y: [Name]
- **Status:** not_started | in_progress | completed | blocked
- **Effort:** S | M | L | XL
- **Dependencies:** none | Step X.Y
- **Description:** [What this accomplishes]
- [ ] Task 1
- [ ] Task 2
```

Status definitions:
- `not_started` — No work done yet
- `in_progress` — Actively being worked on
- `completed` — All tasks done, verified
- `blocked` — Cannot proceed, reason documented

## Coding Conventions

[FILL IN: Your project's coding standards, patterns, tools, etc.]

## Important Rules

- **Don't delete brain files** without asking. Mark them as deprecated instead.
- **Always update the execution plan** when completing work.
- **Create ADRs** for significant technical decisions.
- **Handoffs are sacred** — never skip the wrap-up, even for short sessions.
- **Reference files by wikilink** so the user can click through in Obsidian.
