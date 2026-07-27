---
name: weekly-report
description: >
  Generates and fills the weekly Pulse report form from real git activity.
  Use when user says "fill weekly report", "weekly report", "pulse report",
  or invokes /weekly-report. Grounds all content in actual commits, PRs, and
  branch activity from the current week.
---

# Weekly Report Generator

Generate a grounded weekly report from git history and fill the Pulse form via a browser script.

## Grounding Rules

Every piece of content in the report MUST trace to a real git artifact. Never fabricate.

- **Highlights**: derived from merged PRs and significant commits (non-format, non-merge)
- **Lowlights/Blockers**: derived from PR state (open too long, CI failures, repeated fix commits)
- **Priorities**: derived from open PRs needing review, unfinished branch work
- **PRs to Highlight**: only PRs that actually exist in the repo

If git data is sparse, say so. A short honest report beats a long fabricated one.

## Workflow

### Step 1: Gather Git Data

Run these commands from the repo root. Collect ALL output — this is the source of truth.

```bash
# Date range: Monday of current week to today (Friday)
WEEK_START=$(date -v-monday +%Y-%m-%d)
WEEK_END=$(date -v+1d +%Y-%m-%d)

# 1. All commits this week (author: current user)
git log --all --author="$(git config user.name)" \
  --since="$WEEK_START" --until="$WEEK_END" \
  --format="%H %s (%ar)" --no-merges

# 2. Commit graph with branch context
git log --all --author="$(git config user.name)" \
  --since="$WEEK_START" --until="$WEEK_END" \
  --oneline --graph

# 3. Current branch and its diff from main
git branch --show-current
git diff --stat main...HEAD

# 4. All PRs by current user (requires gh CLI)
gh pr list --author "@me" --state all \
  --json number,title,state,headRefName,createdAt,url \
  --limit 20

# 5. Branches with recent activity
git branch -a --sort=-committerdate | head -20
```

### Step 2: Analyze and Categorize

From the gathered data, classify each item:

| Category | Derivation |
|----------|-----------|
| **Highlight** | Merged PRs, significant feature commits, bug fixes with impact |
| **Lowlight/Blocker** | PRs stuck open >3 days, repeated format/fix commits, CI failures |
| **Priority** | Open PRs needing review, in-progress branch work, next logical steps |
| **PR to Highlight** | Merged or open PRs with meaningful scope (not trivial fixes) |

Group related commits into single highlight entries. For example, 5 commits about "Defender async client" = 1 highlight.

### Step 3: Draft Report Sections

**Highlights** (up to 5, ordered by impact):
```
1. [What was built/merged] — [scope/details] (PR #NNN, status)
2. ...
```

**Lowlights** (only if real issues exist):
```
1. [What went wrong] — [impact]
2. ...
```

**Priorities** (up to 5):
```
1. [Action] — [specific target]
2. ...
```

**PRs to Highlight** (only real PRs):
```
| Link | What's interesting |
|------|-------------------|
| https://github.com/.../pull/NNN | [One-line description] |
```

### Step 4: Generate Browser Script

After drafting content, generate a JavaScript file that fills the Pulse form.

The script must:

1. Define the report data in a `data` object
2. Use the form's existing `addGroupRow(section, fieldId)` function to create rows
3. Set input values and dispatch `input` events
4. Target these form field names (from the Pulse form DOM):
   - Highlights: section=`last_week`, field=`highlights`, input=`last_week.highlights.__IDX__.item`
   - Lowlights: section=`lowlights`, field=`items`, input=`lowlights.items.__IDX__.item`
   - Priorities: section=`next_week`, field=`priorities`, input=`next_week.priorities.__IDX__.item`
   - PRs: section=`design_docs_prs`, field=`items`, inputs=`design_docs_prs.items.__IDX__.link` and `.description`

5. Write the script to `~/.agents/skills/weekly-report/fill_report.js`

**Script template:**

```javascript
(() => {
  const data = {
    highlights: [ /* strings */ ],
    lowlights: [ /* strings */ ],
    priorities: [ /* strings */ ],
    docs: [ { link: "url", desc: "text" } /* objects */ ]
  };

  function fillSection(section, fieldId, values) {
    values.forEach(val => {
      addGroupRow(section, fieldId);
      const container = document.getElementById(`group-${section}-${fieldId}`);
      const row = container.lastElementChild;
      const input = row.querySelector('input');
      input.value = val;
      input.dispatchEvent(new Event('input', { bubbles: true }));
    });
  }

  function fillDocs(docs) {
    docs.forEach(doc => {
      addGroupRow('design_docs_prs', 'items');
      const container = document.getElementById('group-design_docs_prs-items');
      const row = container.lastElementChild;
      row.querySelector('input[name*="link"]').value = doc.link;
      row.querySelector('input[name*="description"]').value = doc.desc;
    });
  }

  fillSection('last_week', 'highlights', data.highlights);
  fillSection('lowlights', 'items', data.lowlights);
  fillSection('next_week', 'priorities', data.priorities);
  fillDocs(data.docs);

  console.log('Form filled! Review and click Submit Report.');
})();
```

### Step 5: Present and Execute

1. Show the drafted report to the user for review
2. Write the script to `~/.agents/skills/weekly-report/fill_report.js`
3. Tell the user:
   - Open the Pulse form URL in a browser
   - Open DevTools console (F12 → Console)
   - Paste the script contents and press Enter
   - Review the filled form, then click Submit

## Error Handling

- If `gh` CLI is not authenticated, skip PR gathering and note it in the report
- If no commits found for the week, report "No activity this week" — do not fabricate
- If the form URL is not provided, ask the user for it
- If the form DOM structure has changed (function names differ), detect this and adapt

## Customization

User can override defaults:

- `--week "Jun 15 - Jun 19, 2026"` — custom date range
- `--url <pulse-url>` — pre-fill the form URL
- `--author <name>` — override git author (default: `git config user.name`)
