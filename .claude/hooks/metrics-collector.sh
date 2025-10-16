#!/usr/bin/env bash
set -eu

# Metrics Collector for Mini-CoderBrain v2.1
# Collects behavioral and performance metrics during session

ROOT="${CLAUDE_PROJECT_DIR:-.}"
METRICS_DIR="$ROOT/.claude/metrics"
SESSIONS_DIR="$METRICS_DIR/sessions"
CLAUDE_TMP="$ROOT/.claude/tmp"

# Ensure directories exist
mkdir -p "$SESSIONS_DIR" "$METRICS_DIR/aggregated" "$METRICS_DIR/archive"

# Get current session ID
session_flag="$CLAUDE_TMP/context-loaded.flag"
if [ -f "$session_flag" ]; then
  session_id=$(head -1 "$session_flag" 2>/dev/null || echo "unknown")
  session_timestamp=$(tail -1 "$session_flag" 2>/dev/null || date '+%Y-%m-%d %H:%M:%S')
else
  session_id="unknown"
  session_timestamp=$(date '+%Y-%m-%d %H:%M:%S')
fi

# Metrics file for this session
metrics_file="$SESSIONS_DIR/${session_id}.json"

# === FUNCTION: Initialize Metrics File ===
init_metrics() {
  local profile=$(grep -E "^behavior_profile:" "$ROOT/CLAUDE.md" 2>/dev/null | \
                  sed -E 's/^behavior_profile:[[:space:]]*"?([^"#[:space:]]+)"?.*/\1/' | \
                  head -1 || echo "default")

  cat > "$metrics_file" <<EOF
{
  "session_id": "$session_id",
  "timestamp": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "profile": "$profile",
  "metrics": {
    "behavioral": {
      "context_checks": {
        "total_responses": 0,
        "checks_performed": 0,
        "compliance_rate": 0.0
      },
      "banned_questions": {
        "count": 0,
        "examples": []
      },
      "proactive_suggestions": {
        "count": 0,
        "accepted": 0,
        "ignored": 0
      }
    },
    "profile_performance": {
      "token_estimate": 200,
      "token_actual": 0,
      "response_avg_length": 0,
      "tool_uses": 0
    },
    "tool_usage": {
      "Read": 0,
      "Edit": 0,
      "Write": 0,
      "Glob": 0,
      "Grep": 0,
      "Bash": 0,
      "Task": 0,
      "WebSearch": 0,
      "WebFetch": 0
    },
    "session_outcome": {
      "duration_minutes": 0,
      "tasks_completed": 0,
      "errors": 0,
      "user_corrections": 0
    }
  }
}
EOF
}

# === FUNCTION: Update Tool Usage Counter ===
increment_tool() {
  local tool="$1"

  if [ ! -f "$metrics_file" ]; then
    init_metrics
  fi

  # Use jq if available, otherwise simple increment
  if command -v jq >/dev/null 2>&1; then
    local temp_file="$metrics_file.tmp"
    jq ".metrics.tool_usage.${tool} += 1" "$metrics_file" > "$temp_file" 2>/dev/null || true
    mv "$temp_file" "$metrics_file" 2>/dev/null || true
  fi
}

# === FUNCTION: Update Total Operations ===
increment_operations() {
  local op_count="$1"

  if [ ! -f "$metrics_file" ]; then
    init_metrics
  fi

  if command -v jq >/dev/null 2>&1; then
    local temp_file="$metrics_file.tmp"
    jq ".metrics.profile_performance.tool_uses = $op_count" "$metrics_file" > "$temp_file" 2>/dev/null || true
    mv "$temp_file" "$metrics_file" 2>/dev/null || true
  fi
}

# === FUNCTION: Record Session End ===
finalize_session() {
  local duration="$1"

  if [ ! -f "$metrics_file" ]; then
    return
  fi

  if command -v jq >/dev/null 2>&1; then
    local temp_file="$metrics_file.tmp"
    jq ".metrics.session_outcome.duration_minutes = $duration" "$metrics_file" > "$temp_file" 2>/dev/null || true
    mv "$temp_file" "$metrics_file" 2>/dev/null || true
  fi
}

# === FUNCTION: Cleanup Old Metrics ===
cleanup_old_metrics() {
  # Archive metrics older than 30 days
  find "$SESSIONS_DIR" -name "*.json" -type f -mtime +30 -exec bash -c '
    for file; do
      month=$(date -r "$file" "+%Y-%m" 2>/dev/null || date "+%Y-%m")
      archive_dir="'"$METRICS_DIR"'/archive/$month"
      mkdir -p "$archive_dir"
      mv "$file" "$archive_dir/" 2>/dev/null || true
    done
  ' bash {} +
}

# === MAIN LOGIC ===
case "${1:-}" in
  init)
    init_metrics
    ;;

  tool)
    # Record tool usage: ./metrics-collector.sh tool Read
    if [ -n "${2:-}" ]; then
      increment_tool "$2"
    fi
    ;;

  operations)
    # Update total operations: ./metrics-collector.sh operations 47
    if [ -n "${2:-}" ]; then
      increment_operations "$2"
    fi
    ;;

  finalize)
    # Finalize session: ./metrics-collector.sh finalize 45
    if [ -n "${2:-}" ]; then
      finalize_session "$2"
    fi
    ;;

  cleanup)
    cleanup_old_metrics
    ;;

  *)
    # Default: initialize if not exists
    if [ ! -f "$metrics_file" ]; then
      init_metrics
    fi
    ;;
esac

exit 0
