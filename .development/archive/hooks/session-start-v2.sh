#!/usr/bin/env bash
set -eu

# Session-Aware Context Loading (v2.0 Fix)
# Loads context ONLY when starting a NEW conversation/session

ROOT="${CLAUDE_PROJECT_DIR:-.}"
MB="$ROOT/.claude/memory"
CLAUDE_TMP="$ROOT/.claude/tmp"

# Generate unique session ID for this conversation
session_id="sessionstart-$(date +%s)"
context_flag="$CLAUDE_TMP/context-loaded.flag"

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

# === SESSION-AWARE CONTEXT LOADING ===
# Check if context already loaded in THIS session/conversation
should_load_context=true

if [ -f "$context_flag" ]; then
    # Read stored session ID
    stored_session_id=$(head -1 "$context_flag" 2>/dev/null || echo "")

    if [ "$stored_session_id" == "$session_id" ]; then
        # Same session - context already in conversation history
        should_load_context=false
    else
        # Different session - this is a NEW conversation
        # Need to load context for this new conversation
        should_load_context=true
    fi
else
    # No flag exists - first time ever
    should_load_context=true
fi

# === LOAD CONTEXT IF NEEDED (New Conversation) ===
if [ "$should_load_context" == "true" ]; then
    # This is a new conversation, load context into conversation history

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

    # NOTE: progress.md and decisionLog.md are intentionally NOT loaded
    # (they can be very long, read on-demand using Read tool)

    # Store session ID in flag
    echo "$session_id" > "$context_flag"
    echo "$(date '+%Y-%m-%d %H:%M:%S')" >> "$context_flag"

    context_status="loaded"
else
    # Context already in conversation history from earlier in this session
    context_status="in history"
fi

# === OUTPUT SESSION STATUS ===
# Extract project name and current focus
project_name=$(grep -m1 "^# Product Context — " "$MB/productContext.md" 2>/dev/null | sed 's/^# Product Context — //' || \
               basename "$ROOT" 2>/dev/null || echo "My Project")
project_name=$(echo "$project_name" | sed 's/\[//g;s/\]//g' | xargs)

current_focus=$(grep -A 5 "## 🎯 Current Focus" "$MB/activeContext.md" 2>/dev/null | grep -v "^#" | grep -v "^$" | grep -v "^---" | head -1 | sed 's/^\*\*//;s/\*\*$//' || echo "General Development")
current_focus=$(echo "$current_focus" | sed 's/\[//g;s/\]//g' | xargs)

# Clean up placeholders
if [[ -z "$project_name" ]] || [[ "$project_name" == "PROJECT_NAME" ]]; then
  project_name=$(basename "$ROOT" 2>/dev/null || echo "My Project")
fi

if [[ -z "$current_focus" ]] || [[ "$current_focus" == *"WHAT_YOU_ARE_WORKING_ON"* ]]; then
  current_focus="General Development"
fi

# Output status
cat <<EOF
🧠 [MINI-CODERBRAIN: ACTIVE] - $project_name
🎯 Focus: $current_focus
📂 Context: .claude/memory/ ($context_status)
⚡ Ready for development | Session: $session_id
EOF
