# /status — Full Project Health Dashboard

You are generating a comprehensive project health dashboard. Read the brain files and present a clear overview of everything.

## Data Collection

Read these files:
1. **BRAIN-INDEX.md**
2. **Execution-Plan.md**
3. **All handoff files** in `Handoffs/`
4. **All folder indexes** (Company.md, Engineering.md, Product.md, Operations.md)
5. **CLAUDE.md**

## Dashboard Output

### 🏗️ Project: [Name]
[One-line description from BRAIN-INDEX]

---

### 📊 Execution Plan Progress

Show each phase:
```
Phase 1: [Name]     [========--]  80%  (4/5)   ← in_progress
Phase 2: [Name]     [===-------]  30%  (3/10)  ← in_progress
Phase 3: [Name]     [----------]   0%  (0/5)   ← not_started
─────────────────────────────────────────────
Overall:            [=====-----]  46%  (7/15)
```

### 🔄 In Progress
List all steps currently `in_progress`:
- Step X.Y: [Name] — [X/Y tasks done] — [brief note on what remains]

### 🚫 Blocked
List all `blocked` steps:
- Step X.Y: [Name] — Blocked by: [reason]

### ✅ Recently Completed
List steps completed in the last 3 handoffs:
- Step X.Y: [Name] — Completed in session [N]

### 🔓 Ready to Start
List `not_started` steps whose dependencies are all met, ranked by impact:
- Step X.Y: [Name] — Effort: [S/M/L/XL] — Unblocks: [list or "nothing"]

---

### 📁 Brain Health

| Department | Files | Status |
|-----------|-------|--------|
| 00_Company | [count] | [healthy/needs-update/sparse] |
| 01_Engineering | [count] | [healthy/needs-update/sparse] |
| 02_Product | [count] | [healthy/needs-update/sparse] |
| 03_Operations | [count] | [healthy/needs-update/sparse] |
| Handoffs | [count] | [up-to-date/stale] |
| Templates | [count] | — |

**Total brain files:** [count]
**Wikilinks found:** [approximate count of `[[X]]` references across files]
**Potential issues:**
- [Orphan files not linked from any index]
- [Broken wikilinks pointing to non-existent files]
- [Files with TODO/FIXME/placeholder markers]
- [If none: "Brain looks healthy."]

---

### 📅 Session Timeline
List the last 5 handoffs:
| Session | Date | Focus | Steps Completed |
|---------|------|-------|-----------------|
| [N] | [date] | [summary] | [list] |

**Total sessions:** [count]
**Average session output:** [steps completed per session]

---

### 💡 Recommendations
Based on the current state, suggest 3 concrete next actions:
1. [Highest impact action] — why
2. [Second priority] — why
3. [Maintenance/health action if needed] — why

If the brain has health issues (orphans, broken links, stale content), recommend running `/sync` first.
