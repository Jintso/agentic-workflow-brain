# /init-brain — Create a New Brain

You are initialising a brain in the current directory. A brain is a folder of plain markdown files that holds long-term memory for one organisation and every product it builds. It needs nothing beyond Claude Code and a text editor.

This command creates the shared, organisation-level part of the brain and then adds the first product.

**Before starting:** if `BRAIN-INDEX.md` already exists here, stop. Tell the user the brain already exists and point them to `/add-product` (new product), `/migrate` (import an old vault) or `/status`.

## Phase 1: Organisation Interview

Ask these **one at a time**, waiting for each answer. Be conversational, not robotic.

1. **What should this brain be called?** A company, studio, team or personal name. "Just me" is fine.
2. **In one sentence, what does this organisation build, and why?**
3. **Which values or principles should guide decisions across every product?** Skip if the user has none yet.
4. **Which product do you want to set up first?** Name only; the product interview comes next. Mention that more products can be added any time with `/add-product`.

## Phase 2: Generate the Shared Structure

Create these files with real content from the answers. No empty placeholders except where marked.

```
BRAIN-INDEX.md
CLAUDE.md
company/
  README.md
  Vision.md
  Values.md
products/
  README.md
```

### Content Rules

- **BRAIN-INDEX.md** — The entry point Claude reads first every session. Contains the organisation name, the one-line description, then these sections:
  - *Start Here*: links to `CLAUDE.md` and `products/README.md`
  - *Company*: link to `company/README.md` with a one-line description
  - *Products*: one bullet per product (link, one-liner, status, current phase). Empty until Phase 3.
  - *Shared*: link to `templates/README.md`
- **CLAUDE.md** — Copy `templates/CLAUDE.md` and fill in every `[PLACEHOLDER]`. If `CLAUDE.md` already exists (the installer may have placed it), fill in its placeholders instead of overwriting it.
- **company/README.md** — Folder index: what lives here, links to `Vision.md` and `Values.md`. Parent line: `> Part of [Brain Index](../BRAIN-INDEX.md)`.
- **company/Vision.md** — The one-sentence answer expanded into a short vision statement: what is built, for whom, why it matters, and how the products relate to each other. Parent line: `> Part of [Company](README.md)`.
- **company/Values.md** — The stated principles, each with one line on what it means in practice. If the user skipped this, write a short note that values are not yet defined and link to the vision. Parent line: `> Part of [Company](README.md)`.
- **products/README.md** — Portfolio index. Parent line `> Part of [Brain Index](../BRAIN-INDEX.md)`, a one-line description, then this table (rows are added in Phase 3):

  ```markdown
  | Product | Status | Phase | Last session | Code |
  |---------|--------|-------|--------------|------|
  ```

### Link Rules

- Standard relative markdown links only: `[Vision](Vision.md)`, `[Company](../company/README.md)`. No `[[wikilinks]]`.
- Every file except `BRAIN-INDEX.md` and `CLAUDE.md` starts with a parent line: `> Part of [Parent Title](relative/path.md)`.
- Every folder has a `README.md` linking to everything inside it.

## Phase 3: First Product

Now follow `.claude/commands/add-product.md` from its Phase 1 for the product named in the interview. Do not ask the user to run `/add-product` themselves; run through it in this conversation.

## Phase 4: Verify and Summarise

1. Run `scripts/check-links.sh` and fix anything it reports.
2. Show the full tree of created files and the file count.
3. Tell the user the brain works in any markdown editor or forge; the links between files are what make it navigable.
4. Suggest `/resume <slug>` to start the first working session.
