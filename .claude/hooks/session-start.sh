#!/usr/bin/env bash
set -euo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-.}"
MB="$ROOT/.claude/memory"
CLAUDE_TMP="$ROOT/.claude/tmp"
ts="sessionstart-$(date +%s)"

# === LIGHTWEIGHT CLEANUP (after context will be loaded) ===
# Clean old tmp files and stale cache AFTER context loading is safe
{
  # Remove micro-context files older than 1 hour
  find "$CLAUDE_TMP" -name "micro-context*.md" -type f -mmin +60 -delete 2>/dev/null || true

  # Remove stale cache files older than 7 days
  find "$ROOT/.claude/cache" -type f -mtime +7 -delete 2>/dev/null || true

  # Clear old notification markers
  find "$CLAUDE_TMP" -name "*-notified" -type f -mtime +1 -delete 2>/dev/null || true
} >/dev/null 2>&1 &

# === UNIVERSAL PROJECT DETECTION ===
# Automatically detect project structure for universal command compatibility
if [ -f "$ROOT/src/claude-dev/hooks/project-structure-detector.sh" ]; then
  "$ROOT/src/claude-dev/hooks/project-structure-detector.sh" >/dev/null 2>&1 || true
elif [ -f "$ROOT/.claude/hooks/project-structure-detector.sh" ]; then
  "$ROOT/.claude/hooks/project-structure-detector.sh" >/dev/null 2>&1 || true
fi

# Extract minimal context (single line only)
# Get current focus (line after "## 🎯 Current Focus", skipping empty lines and separators)
current_focus=$(grep -A 5 "## 🎯 Current Focus" "$MB/activeContext.md" 2>/dev/null | grep -v "^#" | grep -v "^$" | grep -v "^---" | head -1 | sed 's/^\*\*//;s/\*\*$//' || echo "")

# Get project name from header
project_name=$(grep -m1 "^# Product Context — " "$MB/productContext.md" 2>/dev/null | sed 's/^# Product Context — //' || \
               grep -m1 "^# Active Context — " "$MB/activeContext.md" 2>/dev/null | sed 's/^# Active Context — //' || \
               echo "")

# Clean up placeholders (remove all brackets and trim whitespace)
project_name=$(echo "$project_name" | sed 's/\[//g;s/\]//g' | xargs)
current_focus=$(echo "$current_focus" | sed 's/\[//g;s/\]//g' | xargs)

# If placeholder detected, use fallbacks
if [[ -z "$project_name" ]] || [[ "$project_name" == "PROJECT_NAME" ]] || [[ "$project_name" == *"PROJECT_NAME"* ]]; then
  project_name=$(basename "$ROOT" 2>/dev/null || echo "My Project")
fi

if [[ -z "$current_focus" ]] || [[ "$current_focus" == "WHAT_YOU_ARE_WORKING_ON_RIGHT_NOW" ]] || [[ "$current_focus" == *"WHAT_YOU_ARE_WORKING_ON"* ]]; then
  current_focus="General Development"
fi

# Create context-loaded flag (signals to other hooks that context is in conversation)
echo "$(date +%s)" > "$CLAUDE_TMP/context-loaded.flag"

cat <<EOF
🧠 [MINI-CODERBRAIN: ACTIVE] - $project_name
🎯 Focus: $current_focus
📂 Context: .claude/memory/ (loaded)
⚡ Ready for development | Session: $ts
EOF
