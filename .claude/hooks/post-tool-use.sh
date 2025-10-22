#!/usr/bin/env bash
set -u

# PostToolUse Hook - Track tool usage for activity monitoring
# Logs every tool use to build accurate activity metrics
# Philosophy: Graceful degradation - prefer fallback over failure

ROOT="${CLAUDE_PROJECT_DIR:-.}"
LIB="$ROOT/.claude/hooks/lib/hook-patterns.sh"

# Source bulletproof patterns library
source "$LIB"

# Setup safe exit trap (CRITICAL: ensures we always exit 0)
setup_safe_exit_trap

MB="$ROOT/.claude/memory"
TOOL_TRACKING="$MB/conversations/tool-tracking"

# Ensure directory exists (SAFE: never crash)
ensure_dir "$TOOL_TRACKING"

# Read hook input (SAFE: fallback if empty)
input=$(read_stdin_safe "{}")

# Extract tool name from input JSON (SAFE: no jq dependency)
tool_name=$(extract_json_field "$input" "tool_name" "unknown")

# Get today's date
today=$(date '+%Y-%m-%d')
timestamp=$(date --iso-8601=seconds)

# Log to daily tools file (simple count)
tools_log="$TOOL_TRACKING/$today-tools.log"
echo "$tool_name" >> "$tools_log"

# Log to detailed JSONL file (for analysis)
detailed_log="$TOOL_TRACKING/$today-detailed.jsonl"
echo "{\"timestamp\":\"$timestamp\",\"tool\":\"$tool_name\"}" >> "$detailed_log"

# Always approve (no blocking)
echo '{"decision": "approve"}'

# CRITICAL: Always exit 0, never crash the session
safe_exit
