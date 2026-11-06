# An #anchor must match a heading of its target as GitHub slugs it (punctuation dropped, a link reduced to its text, -1 on a repeat), or it is ANCHOR. A heading in a fence or an underlined (setext) one gives no anchor here, and anchors in code are not checked.
brain alpha
cat >> brain/products/alpha/Execution-Plan.md <<'EOF2'

## Phase 1: Foundation — completed
### Step 1.1: Set up [the repo](README.md) ##
## Notes
## Notes
```
## Phase 9: In a fence
```
Underlined
----------
EOF2
cat >> brain/products/alpha/README.md <<'EOF2'

## Links
- [Phase](Execution-Plan.md#phase-1-foundation--completed)
- [Step](Execution-Plan.md#step-11-set-up-the-repo)
- [Second notes](Execution-Plan.md#notes-1)
- [Here](#links)
- [Fenced](Execution-Plan.md#phase-9-in-a-fence)
- [Setext](Execution-Plan.md#underlined)
- [Old](Execution-Plan.md#phase-1)
- [Missing here](#nowhere)
- [Broken file](Gone.md#anything)
- `[In code](Execution-Plan.md#nowhere)`
EOF2
run check-links.sh brain
