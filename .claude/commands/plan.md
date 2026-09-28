# /plan — Break a Step Into Concrete Tasks

You are creating a detailed implementation plan for one step of a product's execution plan.

## Brain Root

Every brain path in this command (`BRAIN-INDEX.md`, `products/...`, `templates/...`, `scripts/...`) is relative to the **brain root**, not to the working directory. The brain root is the directory that holds both `BRAIN-INDEX.md` and `products/`: either the working directory or one attached with `--add-dir`. Find it first. If no such directory is available, stop and tell the user to attach the brain with `claude --add-dir /path/to/brain`. If the brain's `CLAUDE.md` is not in context, read it from the brain root. Run the link checker as `<brain root>/scripts/check-links.sh <brain root>`.

## Input

- `/plan 2.3`
- `/plan authentication system`
- `/plan addon-manager 2.3` (leading token names the product)

Resolve the product per the Product Resolution rule in `CLAUDE.md`. If the step is ambiguous, read `products/<slug>/Execution-Plan.md` and ask the user which step they mean.

## Process

1. **Read context:** `products/<slug>/Execution-Plan.md`, `engineering/Architecture.md`, `engineering/Tech-Stack.md`, `engineering/Conventions.md`, and any files relevant to this step. If the code is accessible, look at what already exists before planning new work.

2. **Generate the plan** with this structure:

````markdown
> Part of [Execution Plan](../Execution-Plan.md)

# Implementation Plan: [Step Name]

**Step:** [X.Y from the execution plan]
**Phase:** [Phase name]
**Effort Estimate:** [S/M/L/XL] → [Revised estimate if different after analysis]
**Dependencies:** [List with status: completed / in_progress / blocked]
**Blocks:** [What this step unblocks once done]

## Overview
[2-3 sentences on what this step accomplishes and why it matters]

## Tasks

### Task 1: [Name]
- **Effort:** S/M/L
- **Files:** [code files to create or modify, in backticks]
- **Description:** [What to do, concretely]
- **Acceptance criteria:**
  - [ ] [Testable condition 1]
  - [ ] [Testable condition 2]

### Task 2: [Name]
[Same format]

[...continue for all tasks]

## Task Dependencies
```
Task 1 ──→ Task 3
Task 2 ──→ Task 3
Task 4 (independent)
```
[Note which tasks can be done in parallel]

## Technical Notes
- [Key technical decisions or constraints]
- [Libraries or tools needed]
- [Patterns to follow from [Conventions](Conventions.md)]
- [Risks or unknowns]

## Definition of Done
- [ ] All tasks completed
- [ ] [Integration test or manual verification]
- [ ] Brain files updated ([Architecture](Architecture.md), [Tech Stack](Tech-Stack.md), etc.)
- [ ] Execution plan step marked `completed`
````

3. **Save the plan** to `products/<slug>/engineering/Plan-[Step-Name].md`.

4. **Update the step** in `products/<slug>/Execution-Plan.md` with the detailed tasks from this plan, replacing any placeholder tasks. Link the plan file from the step: `- **Plan:** [Plan-Name](engineering/Plan-Name.md)`.

5. **Link it** from `engineering/README.md` and run `scripts/check-links.sh`.

## Output

Show the user:
1. The full plan
2. Recommended task order
3. Estimated total effort
4. Parallel opportunities
5. "Ready to start? Pick a task and let's go."
