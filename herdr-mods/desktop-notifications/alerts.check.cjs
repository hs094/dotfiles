const assert = require("node:assert/strict");

(async () => {
  const { message } = await import("./alerts.js");
  assert.equal(message({ program: { name: "Pi" } }, "done").icon, "mods/desktop-notifications/icons/pi.png");
  assert.equal(message({ program: { name: "Codex" } }, "done").icon, "mods/desktop-notifications/icons/codex.png");
  assert.equal(message({ app: "claude-code" }, "blocked").icon, "mods/desktop-notifications/icons/anthropic.png");
  assert.equal(message({ app: "copilot" }, "done").icon, null);
})().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
