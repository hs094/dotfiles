(() => {
  const data = {
    highlights: [
      "Securonix user mapping (IP-218): CSV user-mapping upload for assignee resolution, assignee sync from Securonix, escalation gated on terminal case status, fixed assignee loading state stuck on update error (PR #5647, merged + backported #5651)",
      "Securonix escalation error handling & toast UX: extracted roster assignment into shared helper, sanitized error messages, improved toast UX (PRs #5604, #5611, #5615, all merged + backported to release-2.32.0)",
      "ServiceDesk Plus (Manage Engine, IP-210) in progress: webhook consumer + tests, typed models with shared ValueMap refactor, SDP request schemas (PR #5613, open)",
      "Shipped 4 feature/fix PRs to main + 4 backports to release-2.32.0: Securonix user mapping, escalation UX fixes, roster assignment helper, Sx fixes"
    ],
    lowlights: [
      "Lint churn: 'Format Fix' and ruff TC003/E402 fix commits were needed after initial pushes",
      "Follow-up needed on user-mapping fix: #5657 'Small Fix' backport merged, but #5656 'Incorrect Function Fix' still open"
    ],
    priorities: [
      "Get #5656 (Incorrect Function Fix) reviewed, merged, and backported to release-2.32.0",
      "Push #5613 Manage Engine integration (IP-210) through review",
      "Finish ServiceDesk Plus webhook consumer + frontend integration docs",
      "Close out doc-update PR #5570"
    ],
    docs: [
      { link: "https://github.com/simbianai/SimbianOS/pull/5647", desc: "Securonix user mapping + assignee sync (IP-218) — merged" },
      { link: "https://github.com/simbianai/SimbianOS/pull/5615", desc: "Improve escalation error handling and toast UX — merged" },
      { link: "https://github.com/simbianai/SimbianOS/pull/5613", desc: "Manage engine integration (IP-210) — open, in review" },
      { link: "https://github.com/simbianai/SimbianOS/pull/5651", desc: "Backport: Sx users mapping to release-2.32.0 — merged" }
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
    });
  }

  fillSection('last_week', 'highlights', data.highlights);
  fillSection('lowlights', 'items', data.lowlights);
  fillSection('next_week', 'priorities', data.priorities);
  fillDocs(data.docs);

  console.log('Form filled! Review and click Submit Report.');
})();
