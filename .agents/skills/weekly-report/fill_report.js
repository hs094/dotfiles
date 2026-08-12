(() => {
  const data = {
    highlights: [
      "Advanced Hunting support for Microsoft Defender integration - built and merged (#5733), plus a follow-up fix to alert conversion (#5738); release backport open as #5734",
      "Jira JQL issue search + Investigation Enrichment tag (IP-225) - read-only Jira search with enrichment tagging, merged as #5724",
      "ManageEngine ServiceDesk Plus integration - built with priority fixes (#5671) and backported (#5683)",
      "Securonix synchronization - cron-sync of existing incidents to findings/cases, per-field update results, and template comments on resolution (#5687/5688 merged; per-field results #5686 open)",
      "Block escalation for terminal case statuses when provider opts in - merged and backported (#5702/#5703)"
    ],
    lowlights: [
      "Palo Alto XSIAM XQL work (#5709) was closed and re-limited; new branch palo-alto-xsiam-tis-pov carries the reworked XQL filtering with some helper format/fix checkpoint commits",
      "Multiple small 'Format Fix' helper commits scattered through the week added review noise"
    ],
    priorities: [
      "Merge XQL filter-expression support for Palo Alto Cortex XSIAM (branch palo-alto-xsiam-tis-pov)",
      "Land the Microsoft Defender Advanced Hunting backport into the release branch (#5734)",
      "Close out the Securonix per-field case update results PR (#5686)",
      "Continue extending threat-intel integration coverage (XSIAM/Defender XQL flow)"
    ],
    docs: [
      { link: "https://github.com/simbianai/SimbianOS/pull/5733", desc: "Advanced Hunting support in Microsoft Defender integration (IP-215)" },
      { link: "https://github.com/simbianai/SimbianOS/pull/5724", desc: "Jira JQL issue search + Investigation Enrichment tag (IP-225)" },
      { link: "https://github.com/simbianai/SimbianOS/pull/5703", desc: "Block escalation for terminal case statuses when provider opts in" },
      { link: "https://github.com/simbianai/SimbianOS/pull/5698", desc: "Stix Shifter update" },
      { link: "https://github.com/simbianai/SimbianOS/pull/5671", desc: "ManageEngine ServiceDesk Plus integration priority fixes" }
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