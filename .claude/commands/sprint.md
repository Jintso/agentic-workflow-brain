# /sprint — Plan a Week of Work

You are creating an agile-style sprint plan based on the current state of the project.

## Data Collection

Read:
1. **Execution-Plan.md** — Current step statuses and dependencies
2. **Latest handoff** in `Handoffs/` — Where things left off
3. **CLAUDE.md** — Any constraints or conventions
4. **Any existing implementation plans** in the engineering folder

## Analysis

Identify all actionable work:
- Steps currently `in_progress` (highest priority — finish what's started)
- Steps that are `not_started` but fully unblocked (dependencies met)
- Steps that will become unblocked once in-progress items complete

Estimate capacity:
- Assume ~3-4 hours of focused work per day, 5 days
- Use effort sizes: S (~1-2 hrs), M (~3-4 hrs), L (~6-8 hrs), XL (~2+ days)

## Sprint Plan Output

```markdown
# Sprint Plan — Week of [date]

**Sprint Goal:** [One sentence describing what "done" looks like this week]
**Capacity:** ~15-20 hours of focused work

---

## Day 1: [Theme/Focus]
- [ ] **[Step X.Y — Task name]** (M) — [brief description]
- [ ] **[Step X.Y — Task name]** (S) — [brief description]
> 💡 [Tip: tactical note about order or approach]

## Day 2: [Theme/Focus]
- [ ] **[Step X.Y — Task name]** (M) — [brief description]
- [ ] **[Step X.Y — Task name]** (M) — [brief description]

## Day 3: [Theme/Focus]
- [ ] **[Step X.Y — Task name]** (L) — [brief description]
> ⚠️ [Risk: anything that might take longer than expected]

## Day 4: [Theme/Focus]
- [ ] **[Step X.Y — Task name]** (M) — [brief description]
- [ ] **[Step X.Y — Task name]** (S) — [brief description]

## Day 5: Buffer + Polish
- [ ] Catch-up on anything that spilled over
- [ ] **[Step X.Y — Task name]** (S) — [if time allows]
- [ ] Run `/sync` to update brain health
- [ ] Run `/wrap-up` to capture the week

---

## Sprint Summary
**Total steps touched:** [count]
**Estimated completion:** [list of steps expected to be done by Friday]
**Unblocks for next week:** [what becomes available after this sprint]
**Key risks:** [what could derail the plan]

## Parallel Blocks
If you want to tackle independent work streams:
- **Stream A:** [Steps X.Y, X.Z] — [theme]
- **Stream B:** [Steps A.B, A.C] — [theme]
These have no dependencies on each other and can be interleaved.
```

## Save and Link

1. Save to `Handoffs/sprint-[date].md`
2. Add to `Handoffs/Handoffs.md` index
3. Ensure `> Part of [[Handoffs]]` backlink

## After Presenting

Ask the user:
- Does this look realistic?
- Want to adjust priorities or swap anything?
- Ready to start with Day 1?

If they agree, suggest running `/resume` to begin the first task.
