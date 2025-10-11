#!/usr/bin/env bash
set -euo pipefail

# Conversation Capture - User Prompt Hook (OPTIMIZED - Zero Duplication)
# Part of CoderBrain conversation intelligence system

# Find project root
if [[ -n "${CLAUDE_PROJECT_DIR:-}" ]]; then
  ROOT="$CLAUDE_PROJECT_DIR"
else
  ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

CLAUDE_TMP="$ROOT/.claude/tmp"

# Read hook input (required by Claude Code)
input=$(cat)

# === ZERO INJECTION STRATEGY ===
# Context already loaded by session-start.sh and persists in conversation history
# No need to re-inject - Claude Code maintains conversation context naturally

context_flag="$CLAUDE_TMP/context-loaded.flag"

# === BUILD MICRO-STATUS (Lightweight, for Claude's awareness) ===
MB="$ROOT/.claude/memory"
TOOL_TRACKING="$MB/conversations/tool-tracking"
CACHE_DIR="$ROOT/.claude/cache"

today=$(date '+%Y-%m-%d')
tools_log="$TOOL_TRACKING/$today-tools.log"
activity_count=0

if [ -f "$tools_log" ]; then
  activity_count=$(wc -l < "$tools_log" 2>/dev/null || echo 0)
fi

# Check map status
map_status="None"
age_hours=9999  # Default: no map

if [ -f "$CACHE_DIR/codebase-map.json" ]; then
  current_time=$(date +%s)
  file_time=$(stat -c %Y "$CACHE_DIR/codebase-map.json" 2>/dev/null || echo 0)
  age_hours=$(( (current_time - file_time) / 3600 ))

  if [ "$age_hours" -lt 4 ]; then
    map_status="Fresh (${age_hours}h)"
  elif [ "$age_hours" -lt 24 ]; then
    map_status="OK (${age_hours}h)"
  else
    map_status="Stale (${age_hours}h)"
  fi
fi

# === INTELLIGENT NOTIFICATIONS ===
notifications=""

# Check memory bloat
if [ -f "$MB/activeContext.md" ]; then
  session_count=$(grep "^## .* Session Update" "$MB/activeContext.md" 2>/dev/null | wc -l 2>/dev/null || echo "0")
  session_count=${session_count// /}  # Remove spaces
  active_lines=$(wc -l < "$MB/activeContext.md" 2>/dev/null || echo "0")
  active_lines=${active_lines// /}  # Remove spaces

  if [ "${session_count:-0}" -gt 10 ] 2>/dev/null; then
    notifications="${notifications}🧹 Memory cleanup recommended ($session_count session updates). Run /memory-cleanup. "
  elif [ "${active_lines:-0}" -gt 200 ] 2>/dev/null; then
    notifications="${notifications}📏 activeContext.md is $active_lines lines (recommended: <100). Consider /memory-cleanup. "
  fi
fi

# Check map staleness (only if age > 24h)
if [ -f "$CACHE_DIR/codebase-map.json" ]; then
  if [ "$age_hours" -gt 24 ]; then
    notifications="${notifications}🗺️ Codebase map is ${age_hours}h old. Suggest: /map-codebase --rebuild. "
  fi
fi

# Check high activity with time-based sync reminder
if [ "$activity_count" -gt 50 ]; then
  # Check last memory sync time
  last_sync_file="$CLAUDE_TMP/last-memory-sync"
  current_time=$(date +%s)

  if [ -f "$last_sync_file" ]; then
    last_sync_time=$(cat "$last_sync_file" 2>/dev/null || echo "0")
    hours_since_sync=$(( (current_time - last_sync_time) / 3600 ))

    # High activity + no sync for 2+ hours
    if [ "$hours_since_sync" -gt 2 ]; then
      notifications="${notifications}🔄 High activity ($activity_count ops) + ${hours_since_sync}h since last sync. Run /memory-sync --full. "
    fi
  else
    # No sync record exists - check when we last notified
    last_notification_file="$CLAUDE_TMP/last-sync-notification"

    if [ -f "$last_notification_file" ]; then
      last_notification=$(cat "$last_notification_file" 2>/dev/null || echo "0")
      hours_since_notification=$(( (current_time - last_notification) / 3600 ))

      # Show reminder every 2 hours during high activity
      if [ "$hours_since_notification" -gt 2 ]; then
        notifications="${notifications}🔄 High activity ($activity_count ops) - no sync record. Consider /memory-sync --full. "
        echo "$current_time" > "$last_notification_file"
      fi
    else
      # First notification
      notifications="${notifications}🔄 High activity detected ($activity_count ops). Consider /memory-sync --full. "
      echo "$current_time" > "$last_notification_file"
    fi
  fi
fi

# Build status line with notifications
status_line="🧠 Context: Active | Activity: ${activity_count} ops | Map: ${map_status}"
if [ -n "$notifications" ]; then
  # Add notifications on new line
  full_status="${status_line}\n\n${notifications}"
else
  full_status="${status_line}"
fi

if [ -f "$context_flag" ]; then
    # Inject micro-status for Claude's awareness
    echo "{\"decision\": \"approve\", \"reason\": \"Context active\", \"additionalContext\": \"$full_status\"}"
else
    # Edge case: flag missing
    echo '{"decision": "approve", "reason": "Session start hook will load context"}'
fi

exit 0
