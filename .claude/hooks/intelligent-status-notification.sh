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

# === HIGH-ACTIVITY SYNC SUGGESTION ===
detect_high_activity() {
  local notification=""

  # High activity = >50 operations
  if [ "$activity_count" -gt 50 ]; then
    # Check if we already notified about sync today
    local sync_notified_flag="$CLAUDE_TMP/sync-notified-$today"
    if [ ! -f "$sync_notified_flag" ]; then
      notification="🔄 High activity detected ($activity_count ops). Suggest: /memory-sync --full"
      touch "$sync_notified_flag"
    fi
  fi

  echo "$notification"
}

activity_notification=$(detect_high_activity)

# === BUILD STATUS FOOTER (Minimal, Every Response) ===
build_status_footer() {
  local map_status="None"
  local map_age=""

  # Check map existence and age
  if [ -f "$CACHE_DIR/codebase-map.json" ]; then
    local current_time=$(date +%s)
    local file_time=$(stat -c %Y "$CACHE_DIR/codebase-map.json" 2>/dev/null || echo 0)
    local age_hours=$(( (current_time - file_time) / 3600 ))

    if [ "$age_hours" -lt 4 ]; then
      map_status="Fresh"
      map_age="${age_hours}h"
    elif [ "$age_hours" -lt 24 ]; then
      map_status="OK"
      map_age="${age_hours}h"
    else
      map_status="Stale"
      map_age="${age_hours}h"
    fi
  fi

  # Build minimal footer: 🧠 Context: Active | Activity: 12 ops | Map: Fresh (2h)
  echo "🧠 Context: Active | Activity: ${activity_count} ops | Map: ${map_status}$([ -n "$map_age" ] && echo " (${map_age})" || echo "")"
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
