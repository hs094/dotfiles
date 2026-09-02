(() => {
  const data = {
    highlights: [
      "SOC-246 QRadar UI Fix merged — closing reasons now optional/configurable at setup, saved configs stay compatible (PR #6322 merged + backport #6325 to release-2.41.0, Sep 29)",
      "SOC-252 Freshservice case mapping fix — pass case creator as requester, resolve assignee separately; lowest-priority mapping + child tickets via parent endpoint (commit 26e39f1, PR #6350 open, review required)",
      "SOC-237 Events notification system — configurable integration/quota/rerun/investigation-failure email notifications with delivery options and tenant inheritance (commits 22ebc07, 9ac7b0a, 54b9a62b; PR #6323 open, +2177/-241)",
      "Case manager v2 custom status — async status-option lookup mock update, external case refresh stays opt-in (commit a482dfb, part of PR #6245)"
    ],
    lowlights: [
      "PR #6323 (SOC-237 Events) has Changes requested + checks pending — needs rework before merge",
      "PR #6245 (Case manager v2 custom status) has 1/4 checks failing, open since Sep 22 (~12 days) — CI failure blocking",
      "PR #6274 (Fetch fixtures) open since Sep 24 (~10 days) with checks pending — stale, needs review push",
      "Churn signal: multiple Fixes/Format Fix fixup commits (44fc154, 82de52a, 54b9a62b) on SOC-237 branch Sep 30–Oct 1"
    ],
    priorities: [
      "Address Changes requested on PR #6323 (SOC-237 Events) and re-run checks to unblock merge",
      "Fix failing check on PR #6245 (custom status) and push for review",
      "Get review and merge on PR #6350 (SOC-252 Freshservice fix, checks pending)",
      "Push PR #6274 (Fetch fixtures) for review or close if superseded",
      "Verify backported QRadar fix (#6325) on release-2.41.0"
    ],
    docs: [
      { link: "https://github.com/simbianai/SimbianOS/pull/6322", desc: "SOC-246 QRadar UI Fix — optional/configurable closing reasons (MERGED Sep 29)" },
      { link: "https://github.com/simbianai/SimbianOS/pull/6325", desc: "Backport QRadar fix to release-2.41.0 (MERGED Sep 29)" },
      { link: "https://github.com/simbianai/SimbianOS/pull/6350", desc: "SOC-252 Freshservice case mapping fix — requester/assignee + child tickets (OPEN, needs review)" },
      { link: "https://github.com/simbianai/SimbianOS/pull/6323", desc: "SOC-237 Events — quota/rerun/failure email notifications + inheritance (OPEN, changes requested)" }
    ]
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
      row.querySelectorAll('input').forEach(i => i.dispatchEvent(new Event('input', { bubbles: true })));
    });
  }

  fillSection('last_week', 'highlights', data.highlights);
  fillSection('lowlights', 'items', data.lowlights);
  fillSection('next_week', 'priorities', data.priorities);
  fillDocs(data.docs);

  console.log('Form filled! Review and click Submit Report.');
})();
