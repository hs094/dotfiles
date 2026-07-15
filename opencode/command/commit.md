---
description: Commit staged files with a professional message
agent: git-commit
---

---

Create exactly one professional Git commit from the staged changes supplied below.

Do not ask for confirmation or clarification. Do not modify or stage files. If nothing is staged, respond exactly:

`Nothing staged. Use git add <files> first.`

Otherwise, generate the commit title and body according to your agent instructions and immediately execute the commit.

The body must use real newlines (line breaks) between bullet points — never `<br>`, `\n`, or inline separators.

## Current branch

!`git branch --show-current`

## Staged changes summary

!`git diff --cached --stat`

## Complete staged diff

!`git diff --cached`
