export const showPullRequest = (pr, showClosedPRs) =>
  Boolean(pr && (showClosedPRs || pr.state === "OPEN"));
