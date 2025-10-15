#!/usr/bin/env bash
set -euo pipefail

# Intelligent Status Notification Hook v2.1 (Enhanced)
# - Minimal status footer every response (user knows system is alive)
# - Memory bloat detection
# - Map staleness detection
# - High-activity sync suggestions

ROOT="${CLAUDE_PROJECT_DIR:-.}"
MB="$ROOT/.claude/memory"
TOOL_TRACKING="$MB/conversations/tool-tracking"
CLAUDE_TMP="$ROOT/.claude/tmp"
CACHE_DIR="$ROOT/.claude/cache"

# Get today's activity count
today=$(date '+%Y-%m-%d')
tools_log="$TOOL_TRACKING/$today-tools.log"
activity_count=0

if [ -f "$tools_log" ]; then
  activity_count=$(wc -l < "$tools_log" 2>/dev/null || echo 0)
fi

# === MEMORY BLOAT DETECTION ===
detect_memory_bloat() {
  local session_count adr_count active_lines notification=""

  # Count session updates (use tail -1 to get last line only)
  if [ -f "$MB/activeContext.md" ]; then
    session_count=$(grep "^## 📊 Session Update" "$MB/activeContext.md" 2>/dev/null | wc -l)
    active_lines=$(wc -l < "$MB/activeContext.md" 2>/dev/null)
  else
    session_count=0
    active_lines=0
  fi

  # Count ADR entries
  if [ -f "$MB/decisionLog.md" ]; then
    adr_count=$(grep "^## \[" "$MB/decisionLog.md" 2>/dev/null | wc -l)
  else
    adr_count=0
  fi

  # CRITICAL: Session update bloat (>10 entries)
  if [ "${session_count:-0}" -gt 10 ]; then
    notification="🧹 Memory cleanup recommended: $session_count session updates in activeContext.md. Run /memory-cleanup to reduce bloat."
  # WARNING: File size growth (>200 lines)
  elif [ "${active_lines:-0}" -gt 200 ]; then
    notification="📏 activeContext.md is $active_lines lines (recommended: <100). Consider /memory-cleanup for optimization."
  fi

  echo "$notification"
}

bloat_notification=$(detect_memory_bloat)

# === MAP STALENESS DETECTION ===
detect_map_staleness() {
  local map_file="$CACHE_DIR/codebase-map.json"
  local notification=""

  if [ -f "$map_file" ]; then
    # Check map age in hours
    local current_time=$(date +%s)
    local file_time=$(stat -c %Y "$map_file" 2>/dev/null || echo 0)
    local age_hours=$(( (current_time - file_time) / 3600 ))

    if [ "$age_hours" -gt 24 ]; then
      notification="🗺️ Codebase map is ${age_hours}h old (stale). Suggest: /map-codebase --rebuild"
    fi
  fi

  echo "$notification"
}

map_notification=$(detect_map_staleness)

# === HIGH-ACTIVITY MEMORY BANK UPDATE SUGGESTION ===
detect_high_activity() {
  local notification=""
  local current_time=$(date +%s)
  local ten_minutes=600  # 10 minutes in seconds

  # Very high activity = >80 operations (major milestone)
  if [ "$activity_count" -gt 80 ]; then
    # Check if we notified in the last 10 minutes
    local update_notified_flag="$CLAUDE_TMP/update-notified-timestamp"
    local last_notified=0

    if [ -f "$update_notified_flag" ]; then
      last_notified=$(cat "$update_notified_flag" 2>/dev/null || echo 0)
    fi

    local time_since_notification=$((current_time - last_notified))

    if [ "$time_since_notification" -ge "$ten_minutes" ]; then
      notification="💾 Major development session ($activity_count ops). Consider: /update-memory-bank to preserve context"
      echo "$current_time" > "$update_notified_flag"
    fi
  # High activity = >50 operations (significant work)
  elif [ "$activity_count" -gt 50 ]; then
    # Check if we notified in the last 10 minutes
    local sync_notified_flag="$CLAUDE_TMP/sync-notified-timestamp"
    local last_notified=0

    if [ -f "$sync_notified_flag" ]; then
      last_notified=$(cat "$sync_notified_flag" 2>/dev/null || echo 0)
    fi

    local time_since_notification=$((current_time - last_notified))

    if [ "$time_since_notification" -ge "$ten_minutes" ]; then
      notification="🔄 High activity detected ($activity_count ops). Suggest: /update-memory-bank or /memory-sync"
      echo "$current_time" > "$sync_notified_flag"
    fi
  fi

  echo "$notification"
}

activity_notification=$(detect_high_activity)

# === BUILD ENHANCED STATUS FOOTER ===
build_status_footer() {
  local map_status="None"
  local map_age=""

  # Check map existence and age
  if [ -f "$CACHE_DIR/codebase-map.json" ]; then
    local current_time=$(date +%s)
    local file_time=$(stat -c %Y "$CACHE_DIR/codebase-map.json" 2>/dev/null || echo 0)
    local age_hours=$(( (current_time - file_time) / 3600 ))

    if [ "$age_hours" -lt 4 ]; then
      map_status="Fresh (${age_hours}h)"
    elif [ "$age_hours" -lt 24 ]; then
      map_status="OK (${age_hours}h)"
    else
      map_status="Stale (${age_hours}h)"
    fi
  fi

  # Get session duration
  local session_duration="0m"
  local session_start_file="$CLAUDE_TMP/session-start-time"
  if [ -f "$session_start_file" ]; then
    local start_time=$(cat "$session_start_file" 2>/dev/null || echo "0")
    local current_time=$(date +%s)
    local duration_seconds=$((current_time - start_time))
    local duration_minutes=$((duration_seconds / 60))
    if [ "$duration_minutes" -lt 60 ]; then
      session_duration="${duration_minutes}m"
    else
      local duration_hours=$((duration_minutes / 60))
      local remaining_minutes=$((duration_minutes % 60))
      session_duration="${duration_hours}h ${remaining_minutes}m"
    fi
  fi

  # Get current profile
  local profile="default"
  local profile_file="$CLAUDE_TMP/current-profile"
  if [ -f "$profile_file" ]; then
    profile=$(cat "$profile_file" 2>/dev/null || echo "default")
  fi

  # Get current focus from activeContext.md
  local current_focus="Development"
  if [ -f "$MB/activeContext.md" ]; then
    local focus_line=$(grep -A 1 "^## 🎯 Current Focus" "$MB/activeContext.md" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//' || echo "")
    if [ -n "$focus_line" ] && [ "$focus_line" != "## 🎯 Current Focus" ]; then
      current_focus=$(echo "$focus_line" | cut -c 1-50)
      if [ ${#focus_line} -gt 50 ]; then
        current_focus="${current_focus}..."
      fi
    fi
  fi

  # Get memory health
  local memory_health="Healthy"
  if [ -f "$MB/activeContext.md" ]; then
    local session_count=$(grep "^## 📊 Session Update" "$MB/activeContext.md" 2>/dev/null | wc -l)
    if [ "${session_count:-0}" -gt 15 ]; then
      memory_health="Needs Cleanup"
    elif [ "${session_count:-0}" -gt 10 ]; then
      memory_health="Monitor"
    fi
  fi

  # Get last sync time
  local last_sync="Never"
  local last_sync_file="$CLAUDE_TMP/last-memory-sync"
  if [ -f "$last_sync_file" ]; then
    local last_sync_time=$(cat "$last_sync_file" 2>/dev/null || echo "0")
    local current_time=$(date +%s)
    local minutes_ago=$(( (current_time - last_sync_time) / 60 ))
    if [ "$minutes_ago" -lt 60 ]; then
      last_sync="${minutes_ago}m ago"
    else
      local hours_ago=$((minutes_ago / 60))
      last_sync="${hours_ago}h ago"
    fi
  fi

  # Build enhanced footer
  echo "🧠 MINI-CODER-BRAIN STATUS"
  echo "📊 Activity: ${activity_count} ops | 🗺️ Map: ${map_status} | ⚡ Context: Active"
  echo "🎭 Profile: ${profile} | ⏱️ ${session_duration} | 🎯 Focus: ${current_focus}"
  echo "💾 Memory: ${memory_health} | 🔄 Last sync: ${last_sync}"
}

status_footer=$(build_status_footer)

# === NOTIFICATION DEDUPLICATION (Show Once Only) ===
bloat_notified_flag="$CLAUDE_TMP/bloat-notified"
map_notified_flag="$CLAUDE_TMP/map-notified"

# Build notification message (if any)
notification_msg=""

# Priority 1: Memory bloat (critical)
if [ -n "$bloat_notification" ] && [ ! -f "$bloat_notified_flag" ]; then
  notification_msg="$bloat_notification"
  echo "$bloat_notification" > "$bloat_notified_flag"
# Priority 2: High activity sync suggestion
elif [ -n "$activity_notification" ]; then
  notification_msg="$activity_notification"
# Priority 3: Map staleness (low priority)
elif [ -n "$map_notification" ] && [ ! -f "$map_notified_flag" ]; then
  notification_msg="$map_notification"
  echo "$map_notification" > "$map_notified_flag"
fi

# === JSON OUTPUT (Required by Claude Code) ===
if [ -n "$notification_msg" ]; then
  # Status footer + notification
  cat <<EOF
{
  "decision": "approve",
  "reason": "Session completed successfully",
  "additionalContext": "${status_footer}\n\n${notification_msg}"
}
EOF
else
  # Just status footer (every response)
  cat <<EOF
{
  "decision": "approve",
  "reason": "Session completed successfully",
  "additionalContext": "${status_footer}"
}
EOF
fi

# Log status check (silent, no stdout output)
status_log="$CLAUDE_TMP/status-checks.log"
echo "$(date --iso-8601=seconds): Status checked - $activity_count operations, bloat_check=$([ -n "$bloat_notification" ] && echo "notified" || echo "ok")" >> "$status_log" 2>/dev/null || true

exit 0
