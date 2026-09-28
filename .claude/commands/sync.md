# /sync — Brain Health Check and Auto-Repair

You are auditing the whole brain for structural and content issues and fixing them. This keeps the link graph clean so every file is reachable from `BRAIN-INDEX.md`.

## Brain Root

Every brain path in this command (`BRAIN-INDEX.md`, `products/...`, `templates/...`, `scripts/...`) is relative to the **brain root**, not to the working directory. The brain root is the directory that holds both `BRAIN-INDEX.md` and `products/`: either the working directory or one attached with `--add-dir`. Find it first. If no such directory is available, stop and tell the user to attach the brain with `claude --add-dir /path/to/brain`. If the brain's `CLAUDE.md` is not in context, read it from the brain root. Run the link checker as `<brain root>/scripts/check-links.sh <brain root>`.

## Step 1: Run the Link Checker

Run the link checker (see *Brain Root*). It is deterministic and reports five kinds of issue:

| Code | Meaning | Fix |
|------|---------|-----|
| `BROKEN` | A relative link points at a file that doesn't exist | Correct the path if it's a typo (suggest the closest match), create a stub if the topic is valid, remove the link if obsolete. Ask if ambiguous. |
| `WIKILINK` | A leftover `[[wikilink]]` | Convert to a relative markdown link to the matching file. If no file matches, ask. |
| `NO-PARENT` | File lacks a `> Part of [...](...)` first line | Add it, pointing at the folder's `README.md` (or the product README for `Execution-Plan.md`). |
| `ORPHAN` | No other file links to this one | Add it to its folder's `README.md`. |
| `CROSS-PRODUCT` | A file in one product links into another product | Move the shared material to `company/` and link there from both, or drop the link. |

Fix everything mechanical without asking, then re-run until it reports clean.

## Step 2: Structural Checks

### Root
- `BRAIN-INDEX.md` links to `company/README.md`, `products/README.md`, `templates/README.md`, and every product README.
- `products/README.md` has exactly one row per folder in `products/`; no rows for folders that don't exist.
- Each product's row (status, phase, last session) matches its `README.md` and its latest handoff.

### Per product
- Each folder `README.md` links every file in its folder.
- *Current Status* in the product README matches the execution plan (phase) and the latest handoff (last updated).
- No links from this product's folder into another product's folder. Move shared material to `company/`.

**Fix:** update indexes and status lines directly.

## Step 3: Content Checks (per product)

### Execution plan drift
Compare `Execution-Plan.md` against the last three handoffs:
- Completed steps still marked `not_started` or `in_progress`?
- Steps marked `in_progress` with no recent handoff mentioning them?
- Task checkboxes inconsistent with step statuses?
**Fix:** update statuses; flag discrepancies you cannot resolve.

### Stale content markers
Search for `TODO`, `FIXME`, `HACK`, `XXX`, `[placeholder]`, `[TBD]`, `[fill in]`, and headers with nothing beneath them.
**Fix:** list each with file and line. Offer to resolve.

### Stub files
Files with fewer than three lines of real content, excluding the parent line and headings.
**Fix:** flag them and ask whether to fill in or remove.

### Handoff chain integrity
Handoffs are numbered sequentially per product with no gaps, and the latest one reflects the actual state.
**Fix:** flag gaps. Never generate missing handoffs.

## Output Format

```
🔍 Brain Sync Report
═══════════════════════════

Link checker:      [files] files, [links] links, [issues] issues
✅ Passed checks:  [count]
⚠️ Issues found:   [count]
🔧 Auto-fixed:     [count]
❓ Needs input:    [count]

──────────────────────────

[For each category with findings:]

### [Category]
[Issue]
→ **Fixed:** [what was done]
  or
→ **Needs input:** [question for the user]

──────────────────────────

Brain health: [Healthy / Needs Attention / Needs Repair]
```

## Behavior

- **Auto-fix mechanical issues** without asking: missing parent lines, incomplete indexes, stale status rows.
- **Ask before changing content**: removing files, resolving ambiguous links, rewriting sections.
- **Never delete files** without explicit confirmation.
- **Report only issues**, not every file that is fine.
- If everything is clean: "Brain is healthy. No issues found."
