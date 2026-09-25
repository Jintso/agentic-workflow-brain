# /wrap-up — End Session With Full Continuity

You are wrapping up the current working session. Capture everything that happened so the next session starts with zero context loss.

## Step 1: Session Audit

Review this conversation. Identify:
- Which product(s) were worked on. Usually one. If several, repeat Steps 2–4 for each.
- Files created or modified, in the brain and in code
- Decisions made and their rationale
- Problems encountered and how they were solved
- Open questions or unresolved issues
- Anything the user said they want to do next

## Step 2: Update Brain Files (per product)

### Execution plan — `products/<slug>/Execution-Plan.md`
- Mark completed steps `completed`
- Mark partially done steps `in_progress` with a note on what remains
- Mark new blockers `blocked` with the reason
- Check off completed tasks inside steps
- Add steps that emerged during the session

### Department files
Update whatever the session made outdated:
- Architecture decisions → `engineering/Architecture.md`, plus a new ADR in `engineering/adr/` (from `templates/ADR-Template.md`, listed in `engineering/adr/README.md`)
- New or rescoped features → `Feature-Priorities.md`, `MVP-Scope.md`, `User-Stories.md`, or the spec in `features/`
- Stack changes → `engineering/Tech-Stack.md`
- New conventions → `engineering/Conventions.md`
- Infra, CI/CD, monitoring → the matching file in `operations/`

### Product status
- In `products/<slug>/README.md`, update *Current Status*: phase, next milestone, last updated.
- In `products/README.md`, update the product's row: status, phase, last session date.

### New files
Every new file needs a parent line (`> Part of [Parent](path.md)`) and an entry in its folder's `README.md`.

## Step 3: Create the Handoff

Next number = highest existing `handoff-NNN.md` in `products/<slug>/handoffs/` plus one, zero-padded to three digits. Create `products/<slug>/handoffs/handoff-NNN.md` following `templates/Handoff-Template.md`:

```markdown
> Part of [Handoffs](README.md)

# Session Handoff — NNN

**Date:** YYYY-MM-DD
**Duration:** [approximate session length]
**Focus:** [one-line summary of what this session was about]

## What Was Done
- [Concrete accomplishment 1]
- [Concrete accomplishment 2]

## Files Changed
| File | Action | Notes |
|------|--------|-------|
| [Architecture](../engineering/Architecture.md) | modified | brief note |
| `src/main.rs` | modified | brief note |

Brain files get a relative link. Code files get backticks, no link.

## Decisions Made
- **[Decision]:** [Rationale]. Alternatives considered: [X, Y].

## Blockers & Issues
- [Description] — **Status:** open/resolved
- [If none: "No blockers identified."]

## Open Questions
- [Anything unresolved that needs future attention]
- [If none: "No open questions."]

## Next Session Recommendations
1. [Most important thing to do next]
2. [Second priority]
3. [Third priority]

**Suggested command:** `/resume <slug>`
```

## Step 4: Update the Handoffs Index

Add to the *Index* list in `products/<slug>/handoffs/README.md`:
```markdown
- [handoff-NNN](handoff-NNN.md) — YYYY-MM-DD — one-line summary
```

## Step 5: Verify

Run `scripts/check-links.sh`. Fix everything it reports before finishing. New files usually need a parent line and an index entry.

## Step 6: Session Summary

Show the user:
1. Product(s) touched and the number of brain files created/modified
2. Execution plan changes (steps completed, status changes)
3. Handoff file path
4. Top recommendation for next session
5. "Your brain is updated. Run `/resume <slug>` next time to pick up where we left off."

## Important Behaviors

- **Thorough but concise:** decisions and rationale, not every keystroke.
- **Never skip the execution plan update.** It is what makes `/resume` work.
- **Write for a reader who has never seen this conversation.**
- **Short or exploratory session?** Still write a handoff. Even a brief one keeps the chain intact.
- **Brain-only maintenance session that touched no product?** Say so, skip the handoff, still run the link checker.
