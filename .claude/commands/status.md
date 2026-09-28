# /status — Project Health Dashboard

You are generating a health dashboard from the brain. Three modes:

| Invocation | Output |
|------------|--------|
| `/status` | The working directory is a product's code location, or the brain has one product → product dashboard. Otherwise → portfolio dashboard, then offer a product dashboard. |
| `/status <slug>` | Product dashboard for that product |
| `/status all` | Portfolio dashboard followed by a product dashboard for every product |

## Brain Root

Every brain path in this command (`BRAIN-INDEX.md`, `products/...`, `templates/...`, `scripts/...`) is relative to the **brain root**, not to the working directory. The brain root is the directory that holds both `BRAIN-INDEX.md` and `products/`: either the working directory or one attached with `--add-dir`. Find it first. If no such directory is available, stop and tell the user to attach the brain with `claude --add-dir /path/to/brain`. If the brain's `CLAUDE.md` is not in context, read it from the brain root. Run the link checker as `<brain root>/scripts/check-links.sh <brain root>`.

## Data Collection

**Portfolio:** `BRAIN-INDEX.md`, `products/README.md`, and for each product its `README.md`, `Execution-Plan.md` and latest handoff. Run `scripts/check-links.sh`.

**Product:** that product's `README.md`, `Execution-Plan.md`, every file in `handoffs/`, the product-level docs (`MVP-Scope.md`, `Feature-Priorities.md`, `User-Stories.md`), and the folder READMEs (`features/`, `engineering/`, `operations/`, `handoffs/`).

## Portfolio Dashboard

### 🏢 [Organisation Name]
[One-line description from BRAIN-INDEX]

---

### 📦 Products

| Product | Status | Phase | Progress | In progress | Blocked | Last session |
|---------|--------|-------|----------|-------------|---------|--------------|
| [Name] | active | 2 — Core Build | 46% (7/15) | 2 | 0 | 2026-09-20 |

Flag underneath:
- `active` products with no handoff in the last 30 days
- Products with any `blocked` step
- Products whose row in `products/README.md` disagrees with their own `README.md`

### 📁 Brain Health
Summarise `scripts/check-links.sh`: files, links, and the count of each issue type. If clean: "Brain looks healthy."

### 💡 Recommendations
Three concrete next actions across the portfolio, each with a one-line why. If the brain has structural issues, recommend `/sync` first.

## Product Dashboard

### 🏗️ [Product Name]
[One-line description] — **Status:** [status] — **Code:** [location]

---

### 📊 Execution Plan Progress

```
Phase 1: [Name]     [========--]  80%  (4/5)   ← in_progress
Phase 2: [Name]     [===-------]  30%  (3/10)  ← in_progress
Phase 3: [Name]     [----------]   0%  (0/5)   ← not_started
─────────────────────────────────────────────
Overall:            [=====-----]  46%  (7/15)
```

### 🔄 In Progress
- Step X.Y: [Name] — [X/Y tasks done] — [what remains]

### 🚫 Blocked
- Step X.Y: [Name] — Blocked by: [reason]

### ✅ Recently Completed
Steps completed in the last 3 handoffs:
- Step X.Y: [Name] — Completed in session [N]

### 🔓 Ready to Start
`not_started` steps whose dependencies are all met, ranked by impact:
- Step X.Y: [Name] — Effort: [S/M/L/XL] — Unblocks: [list or "nothing"]

---

### 📁 Brain Health

| Folder | Files | Status |
|--------|-------|--------|
| product docs (root) | [count] | [healthy / needs-update / sparse] |
| features/ | [count] | [healthy / needs-update / sparse] |
| engineering/ | [count] | [healthy / needs-update / sparse] |
| operations/ | [count] | [healthy / needs-update / sparse] |
| handoffs/ | [count] | [up-to-date / stale] |

**Potential issues:**
- Findings from `scripts/check-links.sh` that touch this product
- Files with TODO / FIXME / placeholder markers
- *Current Status* in the product README out of step with the execution plan
- If none: "Brain looks healthy."

---

### 📅 Session Timeline
Last 5 handoffs:

| Session | Date | Focus | Steps Completed |
|---------|------|-------|-----------------|
| [N] | [date] | [summary] | [list] |

**Total sessions:** [count]
**Average session output:** [steps completed per session]

---

### 💡 Recommendations
Three concrete next actions for this product:
1. [Highest impact action] — why
2. [Second priority] — why
3. [Maintenance or health action if needed] — why
