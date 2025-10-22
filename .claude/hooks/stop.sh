#!/usr/bin/env bash
set -u

# Mini-CoderBrain Stop Hook (Bash)
# Updates memory bank at session end
# Philosophy: Graceful degradation - prefer fallback over failure

ROOT="${CLAUDE_PROJECT_DIR:-.}"
LIB="$ROOT/.claude/hooks/lib/hook-patterns.sh"

# Source bulletproof patterns library
source "$LIB"

# Setup safe exit trap (CRITICAL: ensures we always exit 0)
setup_safe_exit_trap

MB="$ROOT/.claude/memory"
CLAUDE_TMP="$ROOT/.claude/tmp"

# Read JSON input (SAFE: never crash on empty/invalid stdin)
input=$(read_stdin_safe "{}")

# Extract session_id (SAFE: fallback to "unknown")
session_id=$(extract_json_field "$input" "session_id" "unknown")

# Log stop event
log_hook_event "stop" "session_end"

# Get activity count
get_activity_count() {
  local today=$(date '+%Y-%m-%d')
  local tool_log="$MB/conversations/tool-tracking/${today}-tools.log"

  if [ -f "$tool_log" ]; then
    wc -l < "$tool_log" 2>/dev/null || echo "0"
  else
    echo "0"
  fi
}

# Get session duration in minutes
get_session_duration() {
  local start_file="$CLAUDE_TMP/session-start-time"

  if [ -f "$start_file" ]; then
    local start_time=$(read_file_safe "$start_file" "0")
    local current_time=$(date +%s)
    local duration_sec=$((current_time - start_time))
    local duration_min=$((duration_sec / 60))
    echo "$duration_min"
  else
    echo "0"
  fi
}

# Get uncommitted git changes count
get_git_changes() {
  if command_exists git; then
    local changes=$(git_safe status --porcelain | wc -l 2>/dev/null || echo "0")
    echo "$changes"
  else
    echo "0"
  fi
}

# Update activeContext.md with session summary
update_active_context() {
  local ops="$1"
  local duration_min="$2"
  local git_changes="$3"

  local ac_path="$MB/activeContext.md"

  if [ ! -f "$ac_path" ]; then
    return 0
  fi

  # Build session update
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')
  local session_update=""

  session_update="${session_update}\n## 📊 Session Update - ${timestamp}"
  session_update="${session_update}\n- Activity: ${ops} operations"
  session_update="${session_update}\n- Duration: ${duration_min} minutes"

  if [ "$git_changes" -gt 0 ]; then
    session_update="${session_update}\n- Git: ${git_changes} uncommitted changes"
  fi

  session_update="${session_update}\n"

  # Check if "## Session Updates" section exists
  if grep -q "^## Session Updates" "$ac_path" 2>/dev/null || \
     grep -q "^## 📜 Session Updates" "$ac_path" 2>/dev/null; then
    # Append to existing section
    echo -e "$session_update" >> "$ac_path" 2>/dev/null || true
  else
    # Create new section
    echo -e "\n\n## 📜 Session Updates" >> "$ac_path" 2>/dev/null || true
    echo -e "$session_update" >> "$ac_path" 2>/dev/null || true
  fi
}

# Get session metrics
ops=$(get_activity_count)
duration_min=$(get_session_duration)
git_changes=$(get_git_changes)

# Update activeContext.md if activity threshold met (>5 ops)
if [ "$ops" -ge 5 ]; then
  update_active_context "$ops" "$duration_min" "$git_changes"
fi

# CRITICAL: Always exit 0, never crash the session
safe_exit
