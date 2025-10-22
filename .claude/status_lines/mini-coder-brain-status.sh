#!/usr/bin/env bash
# Mini-CoderBrain Terminal Status Line
# Displays real-time footer data at bottom of terminal (no AI compliance needed!)

set -eu

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
MB="$ROOT/.claude/memory"
TMP="$ROOT/.claude/tmp"

# Read JSON input from stdin
input=$(cat)

# ===================================================================
# READ FOOTER DATA (same sources as footer-requirements.sh)
# ===================================================================

# 1. Activity Count
TODAY=$(date '+%Y-%m-%d')
tool_log="$MB/conversations/tool-tracking/${TODAY}-tools.log"
if [ -f "$tool_log" ]; then
  ops=$(wc -l < "$tool_log" 2>/dev/null || echo "0")
else
  ops=0
fi

# 2. Session Duration
if [ -f "$TMP/session-start-time" ]; then
  start_time=$(cat "$TMP/session-start-time")
  current_time=$(date +%s)
  total_minutes=$(( (current_time - start_time) / 60 ))

  if [ "$total_minutes" -lt 60 ]; then
    duration="${total_minutes}m"
  elif [ "$total_minutes" -lt 1440 ]; then
    hours=$(( total_minutes / 60 ))
    mins=$(( total_minutes % 60 ))
    duration="${hours}h${mins}m"
  else
    days=$(( total_minutes / 1440 ))
    remaining=$(( total_minutes % 1440 ))
    hours=$(( remaining / 60 ))
    duration="${days}d${hours}h"
  fi
else
  duration="?"
fi

# 3. Last Sync
if [ -f "$TMP/last-memory-sync" ]; then
  last_sync_time=$(cat "$TMP/last-memory-sync")
  current_time=$(date +%s)
  min_ago=$(( (current_time - last_sync_time) / 60 ))

  if [ "$min_ago" -eq 0 ]; then
    last_sync="now"
  elif [ "$min_ago" -lt 60 ]; then
    last_sync="${min_ago}m"
  elif [ "$min_ago" -lt 1440 ]; then
    hours=$(( min_ago / 60 ))
    last_sync="${hours}h"
  else
    days=$(( min_ago / 1440 ))
    last_sync="${days}d"
  fi
else
  last_sync="never"
  min_ago=999999
fi

# 4. Memory Health
if [ -f "$MB/activeContext.md" ]; then
  session_updates=$(grep -c "^## Session Update" "$MB/activeContext.md" 2>/dev/null || echo "0")

  if [ "$session_updates" -gt 15 ]; then
    memory_health="🚨"
    memory_label="Critical"
  elif [ "$session_updates" -gt 10 ]; then
    memory_health="⚠️"
    memory_label="Monitor"
  else
    memory_health="✅"
    memory_label="Healthy"
  fi
else
  memory_health="❓"
  memory_label="Unknown"
fi

# 5. Map Status
if [ -f "$ROOT/.claude/cache/codebase-map.json" ]; then
  map_age=$(( ($(date +%s) - $(stat -c %Y "$ROOT/.claude/cache/codebase-map.json" 2>/dev/null || echo "0")) / 3600 ))
  if [ "$map_age" -gt 24 ]; then
    map_status="📍Stale"
  else
    map_status="📍Fresh"
  fi
else
  map_status="📍None"
fi

# 6. Current Profile
if [ -f "$TMP/current-profile" ]; then
  profile=$(cat "$TMP/current-profile")
else
  profile="default"
fi

# 7. Current Focus (from activeContext.md)
current_focus="Development"
if [ -f "$MB/activeContext.md" ]; then
  focus_line=$(grep -A 1 "^## 🎯 Current Focus" "$MB/activeContext.md" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//' || echo "")
  if [ -n "$focus_line" ] && [ "$focus_line" != "## 🎯 Current Focus" ]; then
    # Truncate to 30 chars for status line
    current_focus=$(echo "$focus_line" | cut -c 1-30)
    if [ ${#focus_line} -gt 30 ]; then
      current_focus="${current_focus}..."
    fi
  fi
fi

# ===================================================================
# DETECT NOTIFICATION (same logic as footer validation)
# ===================================================================

notification=""
notification_icon=""

# Check memory cleanup needed
if [ "$session_updates" -gt 10 ]; then
  notification="🧹 Cleanup needed"
  notification_icon="🧹"
fi

# Check high activity (takes priority)
if [ "$ops" -ge 50 ] && [ "$min_ago" -ge 10 ]; then
  notification="🔄 Sync recommended (${ops} ops)"
  notification_icon="🔄"
fi

# ===================================================================
# BUILD COMPACT STATUS LINE
# ===================================================================

# Color codes (ANSI)
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BLUE="\033[34m"
GRAY="\033[90m"
BOLD="\033[1m"
RESET="\033[0m"

# Build status line components
parts=()

# Brand
parts+=("${CYAN}${BOLD}[🧠 MCB]${RESET}")

# Activity
if [ "$ops" -ge 100 ]; then
  parts+=("${YELLOW}📊 ${ops}${RESET}")
elif [ "$ops" -ge 50 ]; then
  parts+=("${GREEN}📊 ${ops}${RESET}")
else
  parts+=("${GRAY}📊 ${ops}${RESET}")
fi

# Memory Health
parts+=("${memory_health}")

# Last Sync (color-coded by age)
if [ "$min_ago" -ge 60 ]; then
  parts+=("${RED}🔄 ${last_sync}${RESET}")
elif [ "$min_ago" -ge 10 ]; then
  parts+=("${YELLOW}🔄 ${last_sync}${RESET}")
else
  parts+=("${GREEN}🔄 ${last_sync}${RESET}")
fi

# Session Duration
parts+=("${BLUE}⏱️ ${duration}${RESET}")

# Focus (truncated)
parts+=("${GRAY}🎯 ${current_focus}${RESET}")

# Map Status
parts+=("${GRAY}${map_status}${RESET}")

# Notification (if any)
if [ -n "$notification" ]; then
  parts+=("${YELLOW}💡 ${notification}${RESET}")
fi

# Join parts with separator
IFS=" | "
status_line="${parts[*]}"

# ===================================================================
# OUTPUT STATUS LINE
# ===================================================================

# Output to stdout (becomes terminal status line)
echo -e "$status_line"

# Log for debugging (optional)
if [ -n "${MCB_DEBUG:-}" ]; then
  echo "[$(date --iso-8601=seconds)] ${status_line}" >> "$TMP/status-line-debug.log"
fi

exit 0
