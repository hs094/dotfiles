(() => {
  const data = {
    highlights: [
      'IP-225: Confluence integration merged (PR #5769) - Atlassian OAuth 2.0 with token refresh + 14 read-only actions (search, pages, spaces, blogposts, comments, attachments); action-scoped authorization, migration + seed script, full React config UI with OAuth/Basic toggle',
      'Securonix case updates now warn instead of failing quietly (PR #5790, open) - IntegrationUnavailableError -> 409 + warning flag when a provider update is blocked by a missing active integration; warning toasts across SummaryCards, Metadata, InvestigationDetails, FindingCaseSection; current_assignee plumbed through send_comment; sender resolved from email',
      'User mapping gains First/Last name + display name support (PR #5790)',
      'Cato Stix Fix merged (PR #5786) - STIX translation correction for the Cato Networks integration',
      'Defender documentation update merged (PR #5781)'
    ],
    lowlights: [
      'PR #5790 (Securonix assignee fix) is CI-blocked - checkstyle and pr-template-check are FAILING and review is still required, so the Securonix assignee + user-mapping work cannot land'
    ],
    priorities: [
      'Fix failing CI on PR #5790 (checkstyle, pr-template-check) to unblock the merge',
      'Get PR #5790 reviewed and merged',
      'Land the Lookup IP Tool (IP-236, branch cato-lookup-tool-ip-236) - open a PR or finish the branch',
      'Clean up the leftover stash on jira-confluence-ip-225 (stale "index on ..." commit remains post-merge)'
    ],
    docs: [
      { link: 'https://github.com/simbianai/SimbianOS/pull/5769', desc: 'IP-225 Confluence integration - OAuth 2.0, 14 read-only actions, full config UI' },
      { link: 'https://github.com/simbianai/SimbianOS/pull/5790', desc: 'Securonix assignee fix - clear warnings when provider updates are blocked by missing integration (open, CI red)' },
      { link: 'https://github.com/simbianai/SimbianOS/pull/5786', desc: 'Cato Stix Fix - STIX translation correction for Cato Networks' }
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