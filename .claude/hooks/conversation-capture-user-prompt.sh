#!/usr/bin/env bash
set -eu

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
    minutes_since_sync=$(( (current_time - last_sync_time) / 60 ))

    # High activity + no sync for 10+ minutes
    if [ "$minutes_since_sync" -gt 10 ]; then
      notifications="${notifications}🔄 High activity ($activity_count ops) + ${minutes_since_sync}m since last sync. Run /memory-sync --full. "
    fi
  else
    # No sync record exists - check when we last notified
    last_notification_file="$CLAUDE_TMP/last-sync-notification"

    if [ -f "$last_notification_file" ]; then
      last_notification=$(cat "$last_notification_file" 2>/dev/null || echo "0")
      minutes_since_notification=$(( (current_time - last_notification) / 60 ))

      # Show reminder every 10 minutes during high activity
      if [ "$minutes_since_notification" -gt 10 ]; then
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

# === BUILD ENHANCED STATUS FOOTER ===

# Get session duration
session_start_file="$CLAUDE_TMP/session-start-time"
session_duration="0m"
start_time=0

if [ -f "$session_start_file" ]; then
  # Use explicit session start time (v2.1+)
  start_time=$(cat "$session_start_file" 2>/dev/null || echo "0")
else
  # Fallback: Use context-loaded.flag timestamp (for old sessions)
  context_flag="$CLAUDE_TMP/context-loaded.flag"
  if [ -f "$context_flag" ]; then
    start_time=$(stat -c %Y "$context_flag" 2>/dev/null || stat -f %m "$context_flag" 2>/dev/null || echo "0")
  fi
fi

if [ "$start_time" -gt 0 ]; then
  current_time=$(date +%s)
  duration_seconds=$((current_time - start_time))
  duration_minutes=$((duration_seconds / 60))

  if [ "$duration_minutes" -lt 60 ]; then
    session_duration="${duration_minutes}m"
  else
    duration_hours=$((duration_minutes / 60))
    remaining_minutes=$((duration_minutes % 60))
    session_duration="${duration_hours}h ${remaining_minutes}m"
  fi
fi

# Get current profile
profile="default"
profile_file="$CLAUDE_TMP/current-profile"
if [ -f "$profile_file" ]; then
  profile=$(cat "$profile_file" 2>/dev/null || echo "default")
fi

# Get current focus from activeContext.md
current_focus="Development"
if [ -f "$MB/activeContext.md" ]; then
  # Extract first line after "## 🎯 Current Focus"
  focus_line=$(grep -A 1 "^## 🎯 Current Focus" "$MB/activeContext.md" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//' || echo "")
  if [ -n "$focus_line" ] && [ "$focus_line" != "## 🎯 Current Focus" ]; then
    # Truncate to 50 chars max
    current_focus=$(echo "$focus_line" | cut -c 1-50)
    if [ ${#focus_line} -gt 50 ]; then
      current_focus="${current_focus}..."
    fi
  fi
fi

# Get memory health indicator
memory_health="Healthy"
if [ -f "$MB/activeContext.md" ]; then
  session_count=$(grep "^## .* Session Update" "$MB/activeContext.md" 2>/dev/null | wc -l 2>/dev/null || echo "0")
  session_count=${session_count// /}
  if [ "${session_count:-0}" -gt 15 ] 2>/dev/null; then
    memory_health="Needs Cleanup"
  elif [ "${session_count:-0}" -gt 10 ] 2>/dev/null; then
    memory_health="Monitor"
  fi
fi

# Get last sync time
last_sync="Never"
last_sync_file="$CLAUDE_TMP/last-memory-sync"
if [ -f "$last_sync_file" ]; then
  last_sync_time=$(cat "$last_sync_file" 2>/dev/null || echo "0")
  current_time=$(date +%s)
  minutes_ago=$(( (current_time - last_sync_time) / 60 ))

  if [ "$minutes_ago" -eq 0 ]; then
    last_sync="Just now"
  elif [ "$minutes_ago" -lt 60 ]; then
    last_sync="${minutes_ago}m ago"
  elif [ "$minutes_ago" -lt 1440 ]; then
    hours_ago=$((minutes_ago / 60))
    last_sync="${hours_ago}h ago"
  else
    days_ago=$((minutes_ago / 1440))
    last_sync="${days_ago}d ago"
  fi
fi

# Get tool usage breakdown (top 3 tools)
tool_breakdown="None"
if [ -f "$tools_log" ]; then
  # Get unique tool names with counts
  tool_stats=$(awk '{print $NF}' "$tools_log" 2>/dev/null | sort | uniq -c | sort -rn | head -3)
  if [ -n "$tool_stats" ]; then
    tool_array=()
    while IFS= read -r line; do
      count=$(echo "$line" | awk '{print $1}')
      tool=$(echo "$line" | awk '{print $2}')
      tool_array+=("${tool}(${count})")
    done <<< "$tool_stats"
    tool_breakdown=$(IFS=' '; echo "${tool_array[*]}")
  fi
fi

# Build enhanced status footer
status_line="🧠 MINI-CODER-BRAIN STATUS\n"
status_line="${status_line}📊 Activity: ${activity_count} ops | 🗺️ Map: ${map_status} | ⚡ Context: Active\n"
status_line="${status_line}🎭 Profile: ${profile} | ⏱️ ${session_duration} | 🎯 Focus: ${current_focus}\n"
status_line="${status_line}💾 Memory: ${memory_health} | 🔄 Last sync: ${last_sync} | 🔧 Tools: ${tool_breakdown}"

if [ -n "$notifications" ]; then
  # Add notifications on new line with separator
  full_status="${status_line}\n\n💡 ${notifications}"
else
  full_status="${status_line}"
fi

if [ -f "$context_flag" ]; then
    # === ENHANCED FOOTER VALIDATION INJECTION (v2.2) ===
    # Make footer requirements UNMISSABLE by injecting explicit instructions

    # Build enhanced context with footer validation requirements
    enhanced_context="$full_status\n\n"
    enhanced_context="${enhanced_context}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
    enhanced_context="${enhanced_context}🔒 MANDATORY FOOTER VALIDATION (ENFORCED BY STOP HOOK)\n"
    enhanced_context="${enhanced_context}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

    # Check if notification is required
    notification_check=""
    if [ "$activity_count" -ge 50 ] && [ -f "$last_sync_file" ]; then
      last_sync_time=$(cat "$last_sync_file" 2>/dev/null || echo "0")
      current_time=$(date +%s)
      minutes_ago=$(( (current_time - last_sync_time) / 60 ))

      if [ "$minutes_ago" -ge 10 ]; then
        notification_check="⚠️ NOTIFICATION REQUIRED: High activity (${activity_count} ops, ${minutes_ago}m since sync)\n"
        notification_check="${notification_check}   You MUST add 5th line: 💡 🔄 High activity session (${activity_count} ops, ${minutes_ago}m since sync). Consider: /memory-sync.\n\n"
      fi
    fi

    # Add validation instructions
    enhanced_context="${enhanced_context}BEFORE ENDING YOUR RESPONSE, YOU MUST:\n\n"
    enhanced_context="${enhanced_context}1️⃣  USE the footer data above (already calculated by hook)\n"
    enhanced_context="${enhanced_context}2️⃣  DISPLAY footer EXACTLY as shown above\n"
    enhanced_context="${enhanced_context}3️⃣  DO NOT recalculate or estimate values\n"
    enhanced_context="${enhanced_context}4️⃣  DO NOT modify the format\n\n"

    if [ -n "$notification_check" ]; then
      enhanced_context="${enhanced_context}${notification_check}"
    fi

    enhanced_context="${enhanced_context}✅ Footer data is PRE-CALCULATED (Activity: ${activity_count} ops, Last sync: ${last_sync})\n"
    enhanced_context="${enhanced_context}✅ Stop hook will AUDIT footer requirements\n"
    enhanced_context="${enhanced_context}✅ Violations are LOGGED for debugging\n\n"
    enhanced_context="${enhanced_context}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Inject enhanced context with footer validation
    echo "{\"decision\": \"approve\", \"reason\": \"Context active\", \"additionalContext\": \"$enhanced_context\"}"
else
    # Edge case: flag missing
    echo '{"decision": "approve", "reason": "Session start hook will load context"}'
fi

exit 0
