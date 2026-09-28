# /feature — Plan and Implement a New Feature

You are helping the user plan, spec and implement a new feature from scratch. This command handles the full lifecycle: spec → plan → execute → update brain.

## Brain Root

Every brain path in this command (`BRAIN-INDEX.md`, `products/...`, `templates/...`, `scripts/...`) is relative to the **brain root**, not to the working directory. The brain root is the directory that holds both `BRAIN-INDEX.md` and `products/`: either the working directory or one attached with `--add-dir`. Find it first. If no such directory is available, stop and tell the user to attach the brain with `claude --add-dir /path/to/brain`. If the brain's `CLAUDE.md` is not in context, read it from the brain root. Run the link checker as `<brain root>/scripts/check-links.sh <brain root>`.

## Input

- `/feature user authentication`
- `/feature addon-manager real-time notifications` (leading token names the product)

Resolve the product per the Product Resolution rule in `CLAUDE.md`. If the description is vague, ask 2–3 clarifying questions before proceeding.

## Phase 1: Feature Spec

Read `products/<slug>/MVP-Scope.md`, `Feature-Priorities.md`, `User-Stories.md`, and `products/<slug>/engineering/Architecture.md`, `Tech-Stack.md`, `Conventions.md`. If the code is accessible, check what already exists.

Create `products/<slug>/features/Feature-[Name].md` from `templates/Feature-Spec-Template.md`:

```markdown
> Part of [Features](README.md)

# Feature: [Name]

**Status:** planning | in_progress | completed
**Priority:** critical | high | medium | low
**Effort:** S | M | L | XL
**Added:** [today's date]

## Summary
[2-3 sentences: what it does, why it matters, who it's for]

## User Stories
- As a [user type], I want to [action] so that [benefit]

## Requirements
### Must Have
- [Requirement]

### Nice to Have
- [Requirement]

### Out of Scope
- [Explicitly excluded items]

## Technical Approach
- **Architecture impact:** [How this fits into [Architecture](../engineering/Architecture.md)]
- **Key components:** [What needs to be built]
- **Data model changes:** [If any]
- **API changes:** [If any]
- **Dependencies:** [External libraries, services]

## UI/UX Notes
- [Interaction patterns, key screens or flows]

## Implementation Tasks

### Task 1: [Name] (S/M/L)
- Files: [code files, in backticks]
- What: [concrete description]
- Done when: [acceptance criteria]

### Task 2: [Name] (S/M/L)
[...]

Dependency graph:
```
Task 1 ──→ Task 3
Task 2 (independent)
```

## Testing Strategy
- [Unit tests, integration tests, manual verification steps]

## Related
- [Architecture](../engineering/Architecture.md)
- [Tech Stack](../engineering/Tech-Stack.md)
- [Feature Priorities](../Feature-Priorities.md)
- [User Stories](../User-Stories.md)
```

## Phase 2: Integrate With the Execution Plan

1. Add the feature to `products/<slug>/Execution-Plan.md` as a new step (or steps) in the appropriate phase, linking the spec: `- **Spec:** [Feature-Name](features/Feature-Name.md)`
2. Link the spec from `features/README.md` and `Feature-Priorities.md`
3. Run `scripts/check-links.sh`

## Phase 3: Guide Implementation

Ask: "Spec and plan are ready at `products/<slug>/features/Feature-[Name].md`. Want to start on Task 1 now?"

If the product's code location is neither the working directory nor an attached directory, say so and give the start command under *Code Location* in `CLAUDE.md` before continuing.

As you work:
- Check off tasks as they complete
- Update the spec's status field
- Note deviations from the plan in the spec
- Follow `engineering/Conventions.md`

## Phase 4: Completion

When all tasks are done:
1. Set the spec status to `completed`
2. Mark the execution plan step `completed`
3. Update `engineering/Architecture.md` if the architecture changed
4. Create an ADR in `engineering/adr/` if significant technical decisions were made, and list it in `engineering/adr/README.md`
5. Suggest `/wrap-up`

## Important Behaviors

- **Scope check:** if the feature is too large for one session, say so and break it into a multi-session effort.
- **Convention adherence:** follow `engineering/Conventions.md` and `engineering/Tech-Stack.md`.
- **Existing code awareness:** check what exists before planning new work.
- **Cross-linking:** the spec links to and from every relevant brain file.
