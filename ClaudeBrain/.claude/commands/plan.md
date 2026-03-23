# /plan — Break a Step Into Concrete Tasks

You are creating a detailed implementation plan for a specific execution plan step.

## Input

The user will specify which step to plan, either by:
- Name: `/plan authentication system`
- Step number: `/plan 2.3`
- Description: `/plan the API routes step`

If ambiguous, read `Execution-Plan.md` and ask the user to clarify which step they mean.

## Process

1. **Read context:** Load `Execution-Plan.md`, `[[Architecture]]`, `[[Tech-Stack]]`, `[[Conventions]]`, and any files relevant to this step.

2. **Generate the plan** with this structure:

```markdown
> Part of [[Execution-Plan]]

# Implementation Plan: [Step Name]

**Step:** [X.Y from execution plan]
**Phase:** [Phase name]
**Effort Estimate:** [S/M/L/XL] → [Revised estimate if different after analysis]
**Dependencies:** [List with status — completed/in_progress/blocked]
**Blocks:** [What this step unblocks once done]

## Overview
[2-3 sentences on what this step accomplishes and why it matters]

## Tasks

### Task 1: [Name]
- **Effort:** S/M/L
- **Files:** [files to create or modify]
- **Description:** [What to do, concretely]
- **Acceptance criteria:**
  - [ ] [Testable condition 1]
  - [ ] [Testable condition 2]

### Task 2: [Name]
[Same format]

### Task 3: [Name]
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
- [Libraries/tools needed]
- [Patterns to follow from [[Conventions]]]
- [Risks or unknowns]

## Definition of Done
- [ ] All tasks completed
- [ ] [Integration test / manual verification]
- [ ] Brain files updated ([[Architecture]], [[Tech-Stack]], etc.)
- [ ] Execution plan step marked as `completed`
```

3. **Save the plan** to the relevant department folder (usually `01_Engineering/`) with a descriptive filename like `Plan-Authentication.md`.

4. **Update the execution plan step** in `Execution-Plan.md` to include the detailed tasks from this plan (replace any placeholder tasks).

5. **Link it** — add the plan file to the relevant folder index and ensure the `> Part of` backlink exists.

## Output

Show the user:
1. The full plan
2. Recommended task order (what to start with)
3. Estimated total effort
4. Parallel opportunities
5. Suggest: "Ready to start? Pick a task and let's go."
