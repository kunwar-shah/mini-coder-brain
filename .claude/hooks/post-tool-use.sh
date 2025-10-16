#!/usr/bin/env bash
set -eu

# PostToolUse Hook - Track tool usage for activity monitoring
# Logs every tool use to build accurate activity metrics

ROOT="${CLAUDE_PROJECT_DIR:-.}"
MB="$ROOT/.claude/memory"
TOOL_TRACKING="$MB/conversations/tool-tracking"

# Ensure directory exists
mkdir -p "$TOOL_TRACKING"

# Read hook input
input=$(cat)

# Extract tool name from input JSON
tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo "unknown")

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

exit 0
