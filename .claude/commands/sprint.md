# /sprint — Plan a Week of Work

You are creating an agile-style sprint plan from the current state of the brain.

## Input

- `/sprint` → the resolved product (Product Resolution rule in `CLAUDE.md`)
- `/sprint <slug>` → that product
- `/sprint all` → one plan across every `active` product

## Data Collection (per product in scope)

1. `products/<slug>/Execution-Plan.md` — step statuses and dependencies
2. Latest handoff in `products/<slug>/handoffs/` — where things left off
3. Any `Plan-*.md` files in `products/<slug>/engineering/`
4. `CLAUDE.md` — constraints or conventions

## Analysis

Identify all actionable work:
- Steps currently `in_progress` (highest priority: finish what's started)
- Steps `not_started` but fully unblocked
- Steps that become unblocked once in-progress items complete

Estimate capacity:
- Assume ~3–4 hours of focused work per day, 5 days
- Effort sizes: S (~1–2 hrs), M (~3–4 hrs), L (~6–8 hrs), XL (2+ days)

In `all` mode, balance the week across products according to their priority and momentum. Say explicitly which products get no time this week and why.

## Sprint Plan Output

```markdown
> Part of [Handoffs](README.md)

# Sprint Plan — Week of [date]

**Product:** [name, or "Portfolio" in all mode]
**Sprint Goal:** [One sentence describing what "done" looks like this week]
**Capacity:** ~15–20 hours of focused work

---

## Day 1: [Theme/Focus]
- [ ] **[Step X.Y — Task name]** (M) — [brief description]
- [ ] **[Step X.Y — Task name]** (S) — [brief description]
> 💡 [Tip: tactical note about order or approach]

## Day 2: [Theme/Focus]
- [ ] **[Step X.Y — Task name]** (M) — [brief description]

## Day 3: [Theme/Focus]
- [ ] **[Step X.Y — Task name]** (L) — [brief description]
> ⚠️ [Risk: anything that might take longer than expected]

## Day 4: [Theme/Focus]
- [ ] **[Step X.Y — Task name]** (M) — [brief description]

## Day 5: Buffer + Polish
- [ ] Catch-up on anything that spilled over
- [ ] **[Step X.Y — Task name]** (S) — [if time allows]
- [ ] Run `/sync` to check brain health
- [ ] Run `/wrap-up` to capture the week

---

## Sprint Summary
**Total steps touched:** [count]
**Expected completions:** [steps expected done by Friday]
**Unblocks for next week:** [what becomes available after this sprint]
**Key risks:** [what could derail the plan]

## Parallel Streams
- **Stream A:** [Steps X.Y, X.Z] — [theme]
- **Stream B:** [Steps A.B, A.C] — [theme]
These have no dependencies on each other and can be interleaved.
```

In `all` mode prefix each task with the product: `**[addon-manager] Step 2.3 — Task name**`.

## Save and Link

- **Single product:** `products/<slug>/handoffs/sprint-YYYY-MM-DD.md`, parent line `> Part of [Handoffs](README.md)`, listed in `handoffs/README.md`.
- **All:** `company/sprints/sprint-YYYY-MM-DD.md`, parent line `> Part of [Company](../README.md)`, listed under a *Sprints* section in `company/README.md` (create the section if missing).
- Run `scripts/check-links.sh`.

## After Presenting

Ask the user:
- Does this look realistic?
- Want to adjust priorities or swap anything?
- Ready to start with Day 1?

If they agree, suggest `/resume <slug>` to begin the first task.
