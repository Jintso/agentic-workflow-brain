# /resume — Resume Work With Full Context

You are resuming a working session. Load the brain, show the user where things stand, and help them pick what to work on.

## Step 1: Pick the Product

Read `BRAIN-INDEX.md` and `products/README.md`, then apply the Product Resolution rule from `CLAUDE.md`:

- `/resume <slug>` → that product. If the slug matches no folder in `products/`, list the products and ask.
- No argument and one product → that product.
- No argument and several products → show one line per product (name, status, phase, date of last handoff), suggest the one with the most recent handoff, and ask.

Call the chosen folder `products/<slug>/` below.

## Step 2: Load Context

Read in this order. If a file is missing, say so and continue.

1. `products/<slug>/README.md` — overview, code location, current status
2. `products/<slug>/Execution-Plan.md` — roadmap with phase and step statuses
3. The highest-numbered file in `products/<slug>/handoffs/`. If none exists, this is the first session for this product.

Do not read every file in the brain. Open department files such as `engineering/Architecture.md` only when the chosen work needs them.

## Step 3: Session Briefing

Present a clear, scannable briefing:

### Product: [Name]

**Last Session:** [Summarise the latest handoff: what was done, when, key decisions.]
If no handoff exists: "This is the first working session for this product."

**Progress:**
Show each phase with a text progress bar and fraction:
```
Phase 1: Foundation    [========--]  80%  (4/5 steps)
Phase 2: Core Build    [===-------]  30%  (3/10 steps)
Phase 3: Polish        [----------]   0%  (0/5 steps)
```

**In Progress:** steps with status `in_progress`, with tasks done / total.

**Blocked:** steps with status `blocked` and why.

**Ready to Start:** the top 3–5 `not_started` steps whose dependencies are all `completed`, ranked by:
1. Steps that unblock the most other steps
2. Steps in the current active phase
3. Smaller effort first, for momentum

**Parallel Opportunities:** ready steps that don't depend on each other.

**Code Access:** if the product README names a code location outside this directory and you cannot read it, say so and tell the user to restart with `claude --add-dir <path>` before implementation work.

## Step 4: Ask What to Work On

Offer the top recommendations but let the user choose freely: a recommended step, unplanned work, adding to the plan, updating brain files, or fixing a blocker. Once they choose, dive in. You have full context; don't ask them to re-explain what the brain already says.

## Important Behaviors

- **Summarise, don't dump.** The user can open any file themselves.
- **Reference files by path** (`products/<slug>/engineering/Architecture.md`) so the user can find them.
- **Stale brain?** If you see TODOs, placeholders or outdated information, mention it briefly and offer to update.
- **Plan drift?** If completed work isn't reflected in the execution plan, offer `/sync` after the briefing.
- **Stay in one product.** If the user wants to switch, run `/resume <other-slug>` rather than blending contexts.
