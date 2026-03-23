# /init-brain — Create a New Project Brain

You are initializing a persistent project brain inside this Obsidian vault. This brain will serve as your long-term memory across sessions — storing architecture decisions, execution plans, session handoffs, and project context.

## Phase 1: Discovery Interview

Ask the user the following questions **one at a time**, waiting for each answer before proceeding. Be conversational, not robotic.

1. **What are you building?** (Product name, one-sentence description)
2. **Who is it for?** (Target users/audience)
3. **What's the tech stack?** (Languages, frameworks, infrastructure)
4. **What exists already?** (Existing codebase, MVP, nothing yet, etc.)
5. **What are the top 3 priorities right now?** (What needs to happen first)
6. **Any hard constraints?** (Deadlines, budget, team size, platform requirements)
7. **What does "done" look like for the next milestone?** (Definition of success)

## Phase 2: Generate Brain Structure

After collecting answers, generate the following file structure. Every file should contain **real, actionable content** based on the user's answers — not empty templates.

### Directory Structure

```
BRAIN-INDEX.md
CLAUDE.md
Execution-Plan.md

00_Company/
  Company.md            (folder index)
  Vision.md
  Values.md

01_Engineering/
  Engineering.md        (folder index)
  Architecture.md
  Tech-Stack.md
  Conventions.md
  ADR/
    ADR.md              (folder index — Architecture Decision Records)

02_Product/
  Product.md            (folder index)
  MVP-Scope.md
  Feature-Priorities.md
  User-Stories.md

03_Operations/
  Operations.md         (folder index)
  Environments.md
  CI-CD.md
  Monitoring.md

Handoffs/
  Handoffs.md           (folder index)

Templates/
  Handoff-Template.md
  ADR-Template.md
  Feature-Spec-Template.md

Assets/
  (empty — for images, PDFs, reference files)
```

### File Content Rules

1. **BRAIN-INDEX.md** — Central hub. Starts with project name and one-line description. Links to every top-level folder and key file using `[[wikilinks]]`. This is the first file Claude reads every session.

2. **CLAUDE.md** — Brain DNA. Contains:
   - Project overview (from discovery answers)
   - Conventions and rules Claude must follow
   - File organization guide
   - Wikilink conventions: every file links back to its parent via `> Part of [[ParentIndex]]`
   - How to read and update the execution plan
   - How to create handoff documents
   - Instruction: "Always read BRAIN-INDEX.md and the latest handoff in Handoffs/ at the start of every session"

3. **Execution-Plan.md** — Structured roadmap. Format each phase as:
   ```markdown
   ## Phase 1: [Name]
   **Status:** not_started | in_progress | completed
   **Target:** [date or milestone]

   ### Step 1.1: [Name]
   - **Status:** not_started
   - **Effort:** S | M | L | XL
   - **Dependencies:** none | Step X.Y
   - **Description:** [1-2 sentences]
   - [ ] Task 1
   - [ ] Task 2
   - [ ] Task 3
   ```
   Generate 3-4 phases with 3-5 steps each, based on the user's priorities.

4. **Every folder index** (Company.md, Engineering.md, etc.) — Contains:
   - `> Part of [[BRAIN-INDEX]]`
   - Description of what this department covers
   - Links to all files in the folder
   - Status notes if relevant

5. **Every leaf file** — Contains:
   - `> Part of [[ParentIndex]]` (e.g., `> Part of [[Engineering]]`)
   - Real content derived from the discovery answers
   - Cross-links to related files using `[[wikilinks]]` where relevant

6. **Templates** — Ready-to-use templates with YAML frontmatter placeholders.

### Wikilink Rules
- Every file (except BRAIN-INDEX.md) must have a `> Part of [[X]]` backlink to its parent
- Use `[[filename]]` without paths — Obsidian resolves these automatically
- Cross-link related files (e.g., Architecture.md should link to Tech-Stack.md)
- BRAIN-INDEX.md links to all folder indexes

## Phase 3: Summary

After creating all files, display:
1. Total files created (count)
2. The brain structure as a tree
3. A quick "what's next" — suggest running `/resume` to start their first working session

Remind the user they can browse everything visually in Obsidian's graph view.
