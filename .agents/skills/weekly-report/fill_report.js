(() => {
  const data = {
    highlights: [
      'IP-218: Securonix sync state machine — refactored status transitions with explicit state machine, is_escalated guard, ticketing update pre-DB persist, escalation support (PR #5569)',
      'ManageEngine ServiceDesk Plus ITSM integration — new integration with OAuth 2.0 refresh token flow',
      'Integration framework docs — comprehensive docstrings and README for the integration framework (doc-update branch, 4.6k lines added)',
      'Cato Networks enhancements backport (#5563) — merged',
      'Backports merged: FreshService ticketing + Harness Config (#5482), Wiz CNAPP (#5484), Securonix LSTM (#5485), ja.json fix (#5488)'
    ],
    lowlights: [
      'Format/fix churn — 4 cleanup commits (Format Fix, Fix for Import, Restore Certain Parts x2)',
      'PR #5483 (Submodule Updates) closed without merge'
    ],
    priorities: [
      'Get IP-218 Securonix sync PR #5569 reviewed and merged',
      'Push doc-update branch changes to origin'
    ],
    docs: [
      { link: 'https://github.com/simbianai/SimbianOS/pull/5569', desc: 'IP-218 Securonix sync — status state machine refactor, escalation guard, ticketing pre-DB persist' },
      { link: 'https://github.com/simbianai/SimbianOS/pull/5426', desc: 'Elastic dialect support — aws.cloudtrail + azure audit/signin STIX mappings with per-index dialect config' },
      { link: 'https://github.com/simbianai/SimbianOS/pull/5409', desc: 'FreshService ticketing integration — new provider, harness config consolidation, dynamic MCP tool exposure' }
    ]
  };

  function fillSection(section, fieldId, values) {
    values.forEach(val => {
      addGroupRow(section, fieldId);
      const container = document.getElementById('group-' + section + '-' + fieldId);
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
      const linkInput = row.querySelector('input[name*="link"]');
      const descInput = row.querySelector('input[name*="description"]');
      linkInput.value = doc.link;
      linkInput.dispatchEvent(new Event('input', { bubbles: true }));
      descInput.value = doc.desc;
      descInput.dispatchEvent(new Event('input', { bubbles: true }));
    });
  }

  fillSection('last_week', 'highlights', data.highlights);
  fillSection('lowlights', 'items', data.lowlights);
  fillSection('next_week', 'priorities', data.priorities);
  fillDocs(data.docs);

  console.log('Form filled! Review and click Submit Report.');
})();
