#!/usr/bin/env bash
set -euo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-.}"
MB="$ROOT/.claude/memory"
CLAUDE_TMP="$ROOT/.claude/tmp"
ts="sessionstart-$(date +%s)"

# === LIGHTWEIGHT CLEANUP (background) ===
{
  find "$CLAUDE_TMP" -name "micro-context*.md" -type f -mmin +60 -delete 2>/dev/null || true
  find "$ROOT/.claude/cache" -type f -mtime +7 -delete 2>/dev/null || true
  find "$CLAUDE_TMP" -name "*-notified" -type f -mtime +1 -delete 2>/dev/null || true
} >/dev/null 2>&1 &

# === UNIVERSAL PROJECT DETECTION ===
if [ -f "$ROOT/.claude/hooks/project-structure-detector.sh" ]; then
  "$ROOT/.claude/hooks/project-structure-detector.sh" >/dev/null 2>&1 || true
fi

# === CONTEXT LOADING (Session Start Only) ===
# Load essential context files to conversation history
# This happens ONCE per session, persists naturally

# Get project name
project_name=$(grep -m1 "^# Product Context — " "$MB/productContext.md" 2>/dev/null | sed 's/^# Product Context — //' || \
               basename "$ROOT" 2>/dev/null || echo "My Project")
project_name=$(echo "$project_name" | sed 's/\[//g;s/\]//g' | xargs)

if [[ -z "$project_name" ]] || [[ "$project_name" == "PROJECT_NAME" ]]; then
  project_name=$(basename "$ROOT" 2>/dev/null || echo "My Project")
fi

# Output context to conversation (THIS IS CRITICAL)
cat <<EOF
# 🧠 Mini-CoderBrain Context Loading

EOF

# Load productContext.md
if [ -f "$MB/productContext.md" ]; then
  cat "$MB/productContext.md"
  echo ""
fi

# Load activeContext.md
if [ -f "$MB/activeContext.md" ]; then
  cat "$MB/activeContext.md"
  echo ""
fi

# Load systemPatterns.md
if [ -f "$MB/systemPatterns.md" ]; then
  cat "$MB/systemPatterns.md"
  echo ""
fi

# NOTE: progress.md and decisionLog.md are read on-demand (can be very long)
# Claude can use Read tool to access them when needed

# Create context-loaded flag AFTER loading
echo "$(date +%s)" > "$CLAUDE_TMP/context-loaded.flag"

# Show session start status
cat <<EOF
---

🧠 [MINI-CODERBRAIN: ACTIVE] - $project_name
📂 Context: productContext, activeContext, systemPatterns (loaded)
📝 On-demand: progress, decisionLog (use Read tool)
⚡ Ready for development | Session: $ts
EOF
