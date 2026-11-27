import { exec, window } from "herdr";

export async function handleLink({ link }) {
  const platform = window()?.platform;
  const command = platform === "macos" ? "open"
    : platform === "windows" ? "explorer.exe" : "xdg-open";
  await exec(command, [link.url]);
  return "handled";
}
