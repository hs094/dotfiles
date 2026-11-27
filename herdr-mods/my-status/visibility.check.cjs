const assert = require("node:assert/strict");

(async () => {
  const { showPullRequest } = await import("./visibility.js");
  assert.equal(showPullRequest(null, false), false);
  assert.equal(showPullRequest({ state: "OPEN" }, false), true);
  assert.equal(showPullRequest({ state: "CLOSED" }, false), false);
  assert.equal(showPullRequest({ state: "MERGED" }, false), false);
  assert.equal(showPullRequest({ state: "CLOSED" }, true), true);
  assert.equal(showPullRequest({ state: "MERGED" }, true), true);
  console.log("workspace status PR visibility: ok");
})().catch((error) => { console.error(error); process.exitCode = 1; });
