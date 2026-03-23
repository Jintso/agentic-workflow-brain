# /feature — Plan and Implement a New Feature

You are helping the user plan, spec, and implement a new feature from scratch. This command handles the full lifecycle: spec → plan → execute → update brain.

## Input

The user specifies a feature:
- `/feature user authentication`
- `/feature real-time notifications`
- `/feature dark mode support`

If the description is vague, ask 2-3 clarifying questions before proceeding.

## Phase 1: Feature Spec

Read context from `[[Architecture]]`, `[[Tech-Stack]]`, `[[MVP-Scope]]`, `[[Feature-Priorities]]`, and `[[Conventions]]`.

Create a feature spec file:

**Filename:** `02_Product/Feature-[Name].md`

```markdown
> Part of [[Product]]

# Feature: [Name]

**Status:** planning | in_progress | completed
**Priority:** critical | high | medium | low
**Effort:** S | M | L | XL
**Added:** [today's date]

## Summary
[2-3 sentences: what it does, why it matters, who it's for]

## User Stories
- As a [user type], I want to [action] so that [benefit]
- As a [user type], I want to [action] so that [benefit]
- [Add more as needed]

## Requirements
### Must Have
- [Requirement 1]
- [Requirement 2]

### Nice to Have
- [Requirement 3]

### Out of Scope
- [Explicitly excluded items]

## Technical Approach
- **Architecture impact:** [How this fits into [[Architecture]]]
- **Key components:** [What needs to be built]
- **Data model changes:** [If any]
- **API changes:** [If any]
- **Dependencies:** [External libraries, services]

## UI/UX Notes
- [Interaction patterns]
- [Key screens or flows]

## Testing Strategy
- [Unit tests]
- [Integration tests]
- [Manual verification steps]

## Related
- [[Architecture]]
- [[Tech-Stack]]
- [Other related brain files]
```

## Phase 2: Implementation Plan

Break the feature into ordered tasks (same format as `/plan`):

```markdown
## Implementation Tasks

### Task 1: [Name] (S/M/L)
- Files: [list]
- What: [concrete description]
- Done when: [acceptance criteria]

### Task 2: [Name] (S/M/L)
[...]
```

Include a dependency graph showing parallel opportunities.

## Phase 3: Integrate With Execution Plan

1. **Add the feature to `Execution-Plan.md`** as a new step (or set of steps) in the appropriate phase
2. **Link the feature spec** from `[[Feature-Priorities]]` and `[[Product]]` index
3. **Add the `> Part of [[Product]]`** backlink in the feature spec
4. **Update `BRAIN-INDEX.md`** if this is a major feature

## Phase 4: Guide Implementation

After the spec and plan are created, ask the user:

"Feature spec and implementation plan are ready. You can review them in Obsidian. Want to start on Task 1 now?"

If they say yes, begin implementing. As you work:
- Check off tasks as they're completed
- Update the feature spec status field
- Note any deviations from the plan
- Cross-reference with `[[Conventions]]` for code style

## Phase 5: Completion

When all tasks are done:
1. Update the feature spec status to `completed`
2. Update the execution plan step to `completed`
3. Update `[[Architecture]]` if the architecture changed
4. Create an ADR in `01_Engineering/ADR/` if significant technical decisions were made
5. Suggest running `/wrap-up` to capture the session

## Important Behaviors

- **Scope check:** If the feature seems too large for one session, say so and suggest breaking it into a multi-session effort
- **Convention adherence:** Follow patterns from `[[Conventions]]` and `[[Tech-Stack]]`
- **Existing code awareness:** Check what already exists before planning new work
- **Cross-linking:** Make sure the feature spec links to and from all relevant brain files
