# /resume — Resume Work With Full Context

You are resuming a working session. Load the brain, show the user where things stand, and help them pick what to work on.

## Brain Root

Every brain path in this command (`BRAIN-INDEX.md`, `products/...`, `templates/...`, `scripts/...`) is relative to the **brain root**, not to the working directory. The brain root is the directory that holds both `BRAIN-INDEX.md` and `products/`: either the working directory or one attached with `--add-dir`. Find it first. If no such directory is available, stop and tell the user to attach the brain with `claude --add-dir /path/to/brain`. If the brain's `CLAUDE.md` is not in context, read it from the brain root.

## Step 0: Pull the Brain

A brain kept in git may have been pushed to from another machine since the last session. Before reading anything, run `git -C <brain root> pull --ff-only`.

- Pulled, or already up to date → continue.
- Not a git repository, or no upstream → continue with the local copy, and say so in one line.
- Uncommitted changes in the brain → another session has it open, or one ended without `/wrap-up`. Show `git status --short` in the briefing, and don't commit those files: they are not this session's. They don't stop the pull, since `--ff-only` refuses rather than overwrite a changed file.
- Commits ahead of the remote (`git status --short --branch` shows `ahead`) → commands of a session that ended without `/wrap-up`, or of one still open, committed and didn't push. List them in the briefing (`git log --oneline @{u}..`). Don't push them: the next `/wrap-up` does.
- The pull fails (offline, a refused overwrite, or the histories diverged) → continue with the local copy and tell the user why. Never merge, rebase, stash or reset the brain on your own.

## Step 1: Pick the Product

Read `BRAIN-INDEX.md` and `products/README.md`, then apply the Product Resolution rule from `CLAUDE.md`:

- `/resume <slug>` → that product. If the slug matches no folder in `products/`, list the products and ask.
- `/resume brain`, when no product folder is named `brain` → the brain itself, see below.
- No argument, and the working directory is a product's code location or inside it → that product.
- No argument and one product → that product.
- No argument and several products → show one line per product (name, status, phase, date of last handoff), suggest the one with the most recent handoff, and ask. If `company/handoffs/` exists, add one line for the brain itself: the date and focus of its latest handoff.

Call the chosen folder `products/<slug>/` below.

**The brain itself.** When the user picks the brain, read the highest-numbered file in `company/handoffs/`, the record of the last session that changed the brain rather than a product. Skip Steps 2 and 3: brief from that handoff, with what it did, its open questions and its *Next Session Recommendations*, and no progress bars, since the brain has no plan. Then go to Step 4. If `company/handoffs/` doesn't exist, say that no session has recorded brain-level work yet, and list the products.

## Step 2: Load Context

Read in this order. If a file is missing, say so and continue.

1. `products/<slug>/README.md` — overview, code location, current status
2. `products/<slug>/Execution-Plan.md` — roadmap with phase and step statuses
3. The highest-numbered file in `products/<slug>/handoffs/`. If none exists, this is the first session for this product.

**Pull the code.** The product's code may have been pushed from another machine as well. For each code location in the README's `**Code:**` that is a git repository on this machine, note `git -C <repo> rev-parse HEAD`, then run `git -C <repo> pull --ff-only`, as Step 0 does for the brain. Pull only this product's repos, never another product's. Put one line per repo in the briefing:

- Pulled → the branch, and the commits that came in (`git -C <repo> log --oneline <noted HEAD>..`), or that it was already up to date.
- Not on this machine, not a git repository, or a branch with no upstream → say so and continue.
- Uncommitted changes, or commits ahead of the remote → show them (`git status --short --branch`). They are the repo's, and its own rules say when they are committed and pushed. They don't stop the pull, since `--ff-only` refuses rather than overwrite a changed file.
- The pull fails (offline, a refused overwrite, or the histories diverged) → continue with the local copy and tell the user why. Never merge, rebase, stash, reset or switch branches in a code repo on your own.

If the product README says the repo leads (a section *Where Work Is Tracked*), the handoff points at a resume point in the repo. Name it in the briefing, and tell the user to run the repo's own start step next if it has one.

Do not read every file in the brain. Open department files such as `engineering/Architecture.md` only when the chosen work needs them.

## Step 3: Session Briefing

Present a clear, scannable briefing:

### Product: [Name]

**Last Session:** [Summarise the latest handoff: what was done, when, key decisions.]
If no handoff exists: "This is the first working session for this product."

**Progress:**
Show each phase with a text progress bar and fraction. A finished phase moved to `Execution-Plan-Archive.md` has a one-line entry in the plan with its step count; show it as complete from that line, without opening the archive:
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

**Code Access:** if the product's code location is neither the working directory nor an attached directory, say so before implementation work. Tell the user to start the session in the code repo with the brain attached, using the command under *Code Location* in `CLAUDE.md`.

## Step 4: Ask What to Work On

Offer the top recommendations but let the user choose freely: a recommended step, unplanned work, adding to the plan, updating brain files, or fixing a blocker. Once they choose, dive in. You have full context; don't ask them to re-explain what the brain already says.

## Important Behaviors

- **Summarise, don't dump.** The user can open any file themselves.
- **Reference files by path** (`products/<slug>/engineering/Architecture.md`) so the user can find them.
- **Stale brain?** If you see TODOs, placeholders or outdated information, mention it briefly and offer to update.
- **Plan drift?** If completed work isn't reflected in the execution plan, offer `/sync` after the briefing.
- **Stay in one product.** If the user wants to switch, run `/resume <other-slug>` rather than blending contexts.
