> Part of [Brain Index](../BRAIN-INDEX.md)

# Templates

Reusable templates. Copy one, fill in the placeholders, and fix the parent line for wherever the new file lives.

| Template | Used by | Creates |
|----------|---------|---------|
| [Handoff-Template](Handoff-Template.md) | `/wrap-up` | `products/<slug>/handoffs/handoff-NNN.md` |
| [ADR-Template](ADR-Template.md) | `/wrap-up`, `/feature` | `products/<slug>/engineering/adr/ADR-NNN-topic.md` |
| [Feature-Spec-Template](Feature-Spec-Template.md) | `/feature` | `products/<slug>/features/Feature-Name.md` |
| `CLAUDE.md` | `/init-brain` | `CLAUDE.md` at the brain root |

The link checker skips this folder, so placeholder links here are fine.
