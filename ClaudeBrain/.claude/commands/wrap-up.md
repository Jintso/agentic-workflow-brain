# /wrap-up — End Session With Full Continuity

You are wrapping up the current working session. Your job is to capture everything that happened so the next session starts with zero context loss.

## Step 1: Session Audit

Review everything that happened in this conversation. Identify:
- Files created or modified
- Decisions made and their rationale
- Problems encountered and how they were solved
- Open questions or unresolved issues
- Anything the user mentioned wanting to do next

## Step 2: Update Brain Files

### Execution Plan
Open `Execution-Plan.md` and update:
- Mark completed steps as `completed`
- Mark partially-done steps as `in_progress` with notes on what remains
- Mark newly discovered blockers as `blocked` with the reason
- Check off completed tasks within steps
- Add any new steps that emerged during the session

### Department Files
Update any brain files that are now outdated based on session work:
- If architecture decisions were made → update `[[Architecture]]` and create an ADR in `01_Engineering/ADR/`
- If new features were scoped → update `[[Feature-Priorities]]` or `[[MVP-Scope]]`
- If tech stack changed → update `[[Tech-Stack]]`
- If conventions were established → update `[[Conventions]]`
- If CI/CD or infra was set up → update `[[CI-CD]]`, `[[Environments]]`

### Brain Index
If new files were created, ensure they are:
1. Linked from their parent folder index
2. Have a `> Part of [[ParentIndex]]` backlink
3. Linked from `BRAIN-INDEX.md` if they're top-level

## Step 3: Create Handoff Document

Determine the next handoff number by checking `Handoffs/` for existing files. Create a new file:

**Filename:** `Handoffs/handoff-NNN.md` (zero-padded, e.g., `handoff-001.md`)

**Content format:**

```markdown
> Part of [[Handoffs]]

# Session Handoff — NNN

**Date:** [today's date]
**Duration:** [approximate session length]
**Focus:** [1-line summary of what this session was about]

## What Was Done
- [Concrete accomplishment 1]
- [Concrete accomplishment 2]
- [etc.]

## Files Changed
| File | Action | Notes |
|------|--------|-------|
| [[filename]] | created/modified | brief note |

## Decisions Made
- **[Decision]:** [Rationale]. Alternatives considered: [X, Y].

## Blockers & Issues
- [Blocker description] — **Status:** open/resolved
- [If none: "No blockers identified."]

## Open Questions
- [Anything unresolved that needs future attention]
- [If none: "No open questions."]

## Next Session Recommendations
1. [Most important thing to do next]
2. [Second priority]
3. [Third priority]

**Suggested command:** `/resume` to load context and pick up from here.
```

## Step 4: Update Handoffs Index

Add a link to the new handoff in `Handoffs/Handoffs.md`:
```markdown
- [[handoff-NNN]] — [date] — [1-line summary]
```

## Step 5: Session Summary

Display to the user:
1. Number of files created/modified
2. Execution plan changes (steps completed, status changes)
3. Handoff file location
4. Top recommendation for next session
5. Remind them: "Your brain is updated. Run `/resume` next time to pick up where we left off."

## Important Behaviors

- **Be thorough but concise** — capture decisions and rationale, not every keystroke
- **Don't skip the execution plan update** — this is what makes `/resume` work
- **Preserve context for future-you** — write the handoff as if the reader has never seen this conversation
- **If the session was short or exploratory**, still create a handoff — even a brief one maintains the chain
