#!/usr/bin/env bash
set -u

# Mini-CoderBrain UserPromptSubmit Hook (Bash)
# Tracks tool usage and injects footer requirements
# Philosophy: Graceful degradation - prefer fallback over failure

ROOT="${CLAUDE_PROJECT_DIR:-.}"
LIB="$ROOT/.claude/hooks/lib/hook-patterns.sh"

# Source bulletproof patterns library
source "$LIB"

# Setup safe exit trap (CRITICAL: ensures we always exit 0)
setup_safe_exit_trap

MB="$ROOT/.claude/memory"
CLAUDE_TMP="$ROOT/.claude/tmp"
TOOL_TRACKING="$MB/conversations/tool-tracking"

# Read JSON input (SAFE: fallback if empty)
input=$(read_stdin_safe "{}")

# Extract session_id (SAFE: no jq dependency)
session_id=$(extract_json_field "$input" "session_id" "unknown")

# Log user prompt event
log_hook_event "user-prompt-submit" "prompt_received"

# Track tool usage in daily log
ensure_dir "$TOOL_TRACKING"
today=$(date '+%Y-%m-%d')
timestamp=$(date --iso-8601=seconds)
tool_log="$TOOL_TRACKING/$today-tools.log"
echo "$timestamp" >> "$tool_log" 2>/dev/null || true

# ============================================================================
# GATHER FOOTER DATA
# ============================================================================

# 1. Activity Count
get_activity_count() {
  local today=$(date '+%Y-%m-%d')
  local tool_log="$TOOL_TRACKING/$today-tools.log"

  if [ -f "$tool_log" ]; then
    wc -l < "$tool_log" 2>/dev/null || echo "0"
  else
    echo "0"
  fi
}

# 2. Session Duration
get_session_duration() {
  local start_file="$CLAUDE_TMP/session-start-time"

  if [ ! -f "$start_file" ]; then
    echo "Unknown"
    return
  fi

  local start_time=$(read_file_safe "$start_file" "0")
  local current_time=$(date +%s)
  local total_minutes=$(( (current_time - start_time) / 60 ))

  if [ "$total_minutes" -lt 60 ]; then
    echo "${total_minutes}m"
  elif [ "$total_minutes" -lt 1440 ]; then
    local hours=$(( total_minutes / 60 ))
    local mins=$(( total_minutes % 60 ))
    echo "${hours}h ${mins}m"
  else
    local days=$(( total_minutes / 1440 ))
    local remaining=$(( total_minutes % 1440 ))
    local hours=$(( remaining / 60 ))
    echo "${days}d ${hours}h"
  fi
}

# 3. Last Sync Time
get_last_sync() {
  local sync_file="$CLAUDE_TMP/last-memory-sync"

  if [ ! -f "$sync_file" ]; then
    echo "Never"
    echo "0"
    return
  fi

  local last_sync_time=$(read_file_safe "$sync_file" "0")
  local current_time=$(date +%s)
  local min_ago=$(( (current_time - last_sync_time) / 60 ))

  if [ "$min_ago" -eq 0 ]; then
    echo "Just now"
    echo "$min_ago"
  elif [ "$min_ago" -lt 60 ]; then
    echo "${min_ago}m ago"
    echo "$min_ago"
  elif [ "$min_ago" -lt 1440 ]; then
    local hours=$(( min_ago / 60 ))
    echo "${hours}h ago"
    echo "$min_ago"
  else
    local days=$(( min_ago / 1440 ))
    echo "${days}d ago"
    echo "$min_ago"
  fi
}

# 4. Memory Health
get_memory_health() {
  local ac_path="$MB/activeContext.md"

  if [ ! -f "$ac_path" ]; then
    echo "Unknown"
    echo "0"
    return
  fi

  local content=$(read_file_safe "$ac_path" "")
  local session_updates=$(echo "$content" | grep -c "## Session Update\|## 🗓️ Session Update\|## 📊 Session Update" 2>/dev/null || echo "0")

  if [ "$session_updates" -gt 15 ]; then
    echo "Critical"
    echo "$session_updates"
  elif [ "$session_updates" -gt 10 ]; then
    echo "Needs Cleanup"
    echo "$session_updates"
  elif [ "$session_updates" -gt 8 ]; then
    echo "Monitor"
    echo "$session_updates"
  else
    echo "Healthy"
    echo "$session_updates"
  fi
}

# 5. Current Profile
get_current_profile() {
  local profile_file="$CLAUDE_TMP/current-profile"

  if [ -f "$profile_file" ]; then
    read_file_safe "$profile_file" "default"
  else
    echo "default"
  fi
}

# 6. Current Focus
get_current_focus() {
  local ac_path="$MB/activeContext.md"

  if [ ! -f "$ac_path" ]; then
    echo "Development"
    return
  fi

  local focus=$(grep -A 3 "## 🎯 Current Focus\|## Current Focus" "$ac_path" 2>/dev/null | \
                grep -v "^#" | grep -v "^$" | grep -v "^---" | head -1 | \
                sed 's/^\*\*//;s/\*\*$//' | xargs)

  if [ -n "$focus" ]; then
    echo "$focus" | cut -c1-50
  else
    echo "Development"
  fi
}

# 7. Map Status
check_map_status() {
  local map_file="$ROOT/.claude/cache/codebase-map.json"

  if [ ! -f "$map_file" ]; then
    echo "None"
    return
  fi

  local age_seconds=$(( $(date +%s) - $(stat -c %Y "$map_file" 2>/dev/null || echo "0") ))
  local age_hours=$(( age_seconds / 3600 ))

  if [ "$age_hours" -gt 24 ]; then
    echo "Stale"
  else
    echo "Fresh"
  fi
}

# 8. Detect Notifications
detect_notifications() {
  local ops="$1"
  local min_ago="$2"
  local session_updates="$3"

  local notifications=()

  # CONDITION 1: Memory cleanup needed
  if [ "$session_updates" -gt 10 ]; then
    notifications+=("💡 🧹 Memory cleanup recommended ($session_updates session updates). Run /memory-cleanup.")
  fi

  # CONDITION 2: High activity without sync (takes priority)
  if [ "$ops" -ge 50 ] && [ "$min_ago" -ge 10 ]; then
    notifications+=("💡 🔄 High activity session ($ops ops, ${min_ago}m since sync). Consider: /memory-sync.")
  fi

  # Return highest priority notification (high activity > memory cleanup)
  if [ "${#notifications[@]}" -ge 2 ]; then
    echo "${notifications[1]}"  # High activity takes priority
  elif [ "${#notifications[@]}" -eq 1 ]; then
    echo "${notifications[0]}"
  fi
}

# ============================================================================
# COLLECT ALL DATA
# ============================================================================

ops=$(get_activity_count)
duration=$(get_session_duration)

# Last sync returns 2 lines (display format, minutes)
last_sync_data=$(get_last_sync)
last_sync_display=$(echo "$last_sync_data" | head -1)
min_ago=$(echo "$last_sync_data" | tail -1)

# Memory health returns 2 lines (status, count)
memory_data=$(get_memory_health)
memory_health=$(echo "$memory_data" | head -1)
session_updates=$(echo "$memory_data" | tail -1)

profile=$(get_current_profile)
focus=$(get_current_focus)
map_status=$(check_map_status)

# Detect notifications
notification=$(detect_notifications "$ops" "$min_ago" "$session_updates")

# ============================================================================
# BUILD FOOTER
# ============================================================================

footer_text=""
footer_text="${footer_text}\n🧠 MINI-CODER-BRAIN STATUS"
footer_text="${footer_text}\n📊 Activity: ${ops} ops | 🗺️ Map: ${map_status} | ⚡ Context: Active"
footer_text="${footer_text}\n🎭 Profile: ${profile} | ⏱️ ${duration} | 🎯 Focus: ${focus}"
footer_text="${footer_text}\n💾 Memory: ${memory_health} | 🔄 Last sync: ${last_sync_display} | 🔧 Tools: N/A"

if [ -n "$notification" ]; then
  footer_text="${footer_text}\n\n${notification}"
fi

# ============================================================================
# BUILD ENHANCED CONTEXT WITH FOOTER REQUIREMENTS
# ============================================================================

enhanced_context=""
enhanced_context="${enhanced_context}${footer_text}\n\n"
enhanced_context="${enhanced_context}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
enhanced_context="${enhanced_context}🔒 MANDATORY FOOTER VALIDATION (v2.2 3-LAYER ENFORCEMENT)\n"
enhanced_context="${enhanced_context}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
enhanced_context="${enhanced_context}BEFORE ENDING YOUR RESPONSE, YOU MUST:\n\n"
enhanced_context="${enhanced_context}1️⃣  DISPLAY the status footer shown above\n"
enhanced_context="${enhanced_context}2️⃣  DO NOT modify the format\n"
enhanced_context="${enhanced_context}3️⃣  DO NOT recalculate values\n"
enhanced_context="${enhanced_context}4️⃣  ALWAYS include at end of EVERY response\n\n"

if [ -n "$notification" ]; then
  enhanced_context="${enhanced_context}⚠️  NOTIFICATION DETECTED - You MUST include the 5th line:\n"
  enhanced_context="${enhanced_context}    ${notification}\n\n"
fi

# ============================================================================
# OUTPUT JSON
# ============================================================================

# Build JSON output (SAFE: no jq dependency, manual construction)
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "$(echo -e "$enhanced_context" | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')"
  }
}
EOF

# CRITICAL: Always exit 0, never crash the session
safe_exit
