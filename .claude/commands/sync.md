# /sync — Brain Health Check and Auto-Repair

You are auditing the brain for structural issues and fixing them. This keeps the knowledge graph clean and ensures Obsidian's graph view stays useful.

## Audit Checklist

Scan all `.md` files in the vault (excluding `node_modules`, `.git`, and other non-brain directories). Check for:

### 1. Orphan Files
Files that exist but are **not linked from any index or parent file**.
- Every file except `BRAIN-INDEX.md` should have a `> Part of [[X]]` backlink
- Every file should be linked from at least one other file
- **Fix:** Add missing backlinks and link from the appropriate folder index

### 2. Broken Wikilinks
`[[references]]` that point to files that don't exist.
- Scan all files for `[[X]]` patterns
- Check if a file named `X.md` exists anywhere in the vault
- **Fix:** For each broken link, either:
  - Create a stub file if the topic is valid
  - Correct the link if it's a typo (suggest the closest match)
  - Remove the link if it's obsolete
  - Ask the user if ambiguous

### 3. Empty or Stub Files
Files that exist but have minimal content (fewer than 3 lines of real content, excluding frontmatter and backlinks).
- **Fix:** Flag these and ask if the user wants them filled in or removed

### 4. Missing Backlinks
Files referenced by a parent index but that don't link back with `> Part of [[Parent]]`.
- **Fix:** Add the missing backlink at the top of the file

### 5. BRAIN-INDEX Completeness
Check that `BRAIN-INDEX.md` links to all folder indexes.
- **Fix:** Add missing links

### 6. Folder Index Completeness
For each folder index (Company.md, Engineering.md, etc.), verify it links to all files in its folder.
- **Fix:** Add missing links

### 7. Execution Plan Drift
Compare `Execution-Plan.md` against recent handoffs:
- Are there completed steps still marked as `not_started`?
- Are there steps marked `in_progress` with no recent handoff mentioning them?
- Are task checkboxes consistent with step statuses?
- **Fix:** Update statuses and flag discrepancies

### 8. Stale Content Markers
Search for:
- `TODO`, `FIXME`, `HACK`, `XXX` markers
- `[placeholder]`, `[TBD]`, `[fill in]` text
- Empty sections (headers with no content below)
- **Fix:** List all occurrences with file locations. Offer to resolve them.

### 9. Handoff Chain Integrity
Verify handoffs are sequentially numbered and each one exists:
- No gaps (e.g., handoff-001, handoff-003 with no 002)
- Most recent handoff reflects actual project state
- **Fix:** Flag gaps, don't auto-generate missing handoffs

## Output Format

```
🔍 Brain Sync Report
═══════════════════════════

✅ Passed Checks: [count]
⚠️ Issues Found:  [count]
🔧 Auto-Fixed:    [count]
❓ Needs Input:    [count]

──────────────────────────

[For each issue category with findings:]

### [Category Name]
[Issue description]
→ **Fixed:** [what was done]
  or
→ **Needs input:** [question for user]

──────────────────────────

Summary:
- [X] files scanned
- [Y] wikilinks verified
- [Z] issues resolved
- Brain health: [Healthy / Needs Attention / Needs Repair]
```

## Behavior

- **Auto-fix obvious issues** without asking (missing backlinks, incomplete indexes)
- **Ask before changing content** (removing files, resolving ambiguous links)
- **Never delete files** without explicit user confirmation
- **Be efficient** — don't list every file that's fine, only report issues
- If everything is clean, say so briefly: "Brain is healthy. No issues found."
