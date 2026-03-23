# /resume — Resume Work With Full Context

You are resuming a working session on this project. Your job is to load the full brain context, show the user where things stand, and help them pick what to work on.

## Step 1: Load Context

Read these files in order. If any are missing, note it but continue.

1. **BRAIN-INDEX.md** — Project overview and structure map
2. **CLAUDE.md** — Your operating instructions and conventions
3. **Execution-Plan.md** — Current roadmap with phase/step statuses
4. **Handoffs/** — Find and read the **most recent** handoff file (highest number or most recent date). If no handoffs exist, note this is the first session.

## Step 2: Session Briefing

Present a clear, scannable briefing:

### Project: [Name]

**Last Session:** [Summarize the latest handoff — what was done, when, key decisions]
If no handoff exists: "This is your first working session."

**Progress:**
Show each phase with a text progress bar and fraction:
```
Phase 1: Foundation    [========--]  80%  (4/5 steps)
Phase 2: Core Build    [===-------]  30%  (3/10 steps)
Phase 3: Polish        [----------]   0%  (0/5 steps)
```

**In Progress:**
List any steps with status `in_progress`, including how many tasks are done.

**Blocked:**
List any steps with status `blocked` and why.

**Ready to Start:**
List the top 3-5 steps that are `not_started` AND whose dependencies are all `completed`. Rank by:
1. Steps that unblock the most other steps
2. Steps in the current active phase
3. Smaller effort first (for momentum)

**Parallel Opportunities:**
If multiple ready steps have no dependencies on each other, note they can be worked simultaneously.

## Step 3: Ask What to Work On

Ask the user what they'd like to focus on. Offer the top recommendations but let them choose freely. They might want to:
- Pick a recommended step
- Work on something not in the plan
- Add something new to the plan
- Review/update existing brain files
- Fix a blocker

Once they choose, dive in. You have full context — don't ask them to re-explain things that are already in the brain files.

## Important Behaviors

- **Don't recite the entire brain** — summarize, don't dump. The user can browse files in Obsidian.
- **Reference files by name** so the user can find them in Obsidian: "As noted in [[Architecture]], we're using..."
- **If the brain is stale** (TODOs, placeholder content, outdated info), mention it briefly and offer to update.
- **If the execution plan has drift** (completed work not reflected), offer to run `/sync` after the briefing.
