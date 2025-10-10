---
description: Synchronize current session into .claude/memory (decisions, progress, focus)
argument-hint: [optional note]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(cat:*)
---

## Context (auto)
- Pending UMB snapshot: @.claude/tmp/pending-umb.json
- Git status: !`git status -b --porcelain`
- Recent diff (filenames): !`git diff --name-only HEAD`

## Your task
Using the context above **and this conversation**, append updates to:

1) **.claude/memory/decisionLog.md** — only if significant decisions occurred  
   - Format:
     ```
     [${CURRENT_UTC}] ADR-AUTO — <Short Title>
     Decision: <one sentence>
     Rationale: <one line>
     Impact: <one line>
     ```
2) **.claude/memory/progress.md** — move items between **COMPLETED / IN PROGRESS / NEXT** with timestamps.
3) **.claude/memory/activeContext.md** — if focus/blockers/next steps changed, append bullets with timestamps under the proper section.

Rules:
- Append-only, concise, UTC timestamps.
- If provided, include operator note: "$ARGUMENTS".
- Do not overwrite any existing content.
