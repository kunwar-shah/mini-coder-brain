#!/usr/bin/env bash
set -euo pipefail

# Metrics Reporting for Mini-CoderBrain v2.1
# Generates human-readable reports from collected metrics

ROOT="${CLAUDE_PROJECT_DIR:-.}"
METRICS_DIR="$ROOT/.claude/metrics"
SESSIONS_DIR="$METRICS_DIR/sessions"

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
  echo "⚠️  jq not installed. Metrics reporting requires jq for JSON processing."
  echo "Install with: apt-get install jq  (or brew install jq on macOS)"
  exit 1
fi

# Ensure directories exist
mkdir -p "$SESSIONS_DIR"

# Get report type
REPORT_TYPE="${1:---session}"

# === FUNCTION: Current Session Report ===
report_session() {
  # Find most recent session file
  latest_session=$(ls -t "$SESSIONS_DIR"/*.json 2>/dev/null | head -1)

  if [ -z "$latest_session" ] || [ ! -f "$latest_session" ]; then
    echo "📊 METRICS - No session data available yet"
    echo ""
    echo "Metrics will be collected automatically during your development session."
    return
  fi

  # Extract metrics
  profile=$(jq -r '.profile' "$latest_session")
  tool_uses=$(jq -r '.metrics.profile_performance.tool_uses' "$latest_session")
  duration=$(jq -r '.metrics.session_outcome.duration_minutes' "$latest_session")

  # Tool usage
  read_count=$(jq -r '.metrics.tool_usage.Read' "$latest_session")
  edit_count=$(jq -r '.metrics.tool_usage.Edit' "$latest_session")
  grep_count=$(jq -r '.metrics.tool_usage.Grep' "$latest_session")
  glob_count=$(jq -r '.metrics.tool_usage.Glob' "$latest_session")
  bash_count=$(jq -r '.metrics.tool_usage.Bash' "$latest_session")
  write_count=$(jq -r '.metrics.tool_usage.Write' "$latest_session")

  # Output report
  cat <<EOF
📊 METRICS - Current Session

Profile: $profile
Duration: ${duration} minutes
Total Operations: $tool_uses

Tool Usage:
  Read: $read_count | Edit: $edit_count | Bash: $bash_count
  Grep: $grep_count | Glob: $glob_count | Write: $write_count

Behavioral Quality:
  ✅ Metrics collection active
  📊 Full metrics available at session end

---
Metrics file: $(basename "$latest_session")
EOF
}

# === FUNCTION: Weekly Summary ===
report_weekly() {
  # Find sessions from last 7 days
  sessions=$(find "$SESSIONS_DIR" -name "*.json" -type f -mtime -7 2>/dev/null | sort)

  if [ -z "$sessions" ]; then
    echo "📊 METRICS - No sessions in last 7 days"
    return
  fi

  session_count=$(echo "$sessions" | wc -l)

  # Aggregate tool usage
  total_read=0
  total_edit=0
  total_bash=0
  total_grep=0
  total_glob=0

  for session in $sessions; do
    total_read=$((total_read + $(jq -r '.metrics.tool_usage.Read // 0' "$session")))
    total_edit=$((total_edit + $(jq -r '.metrics.tool_usage.Edit // 0' "$session")))
    total_bash=$((total_bash + $(jq -r '.metrics.tool_usage.Bash // 0' "$session")))
    total_grep=$((total_grep + $(jq -r '.metrics.tool_usage.Grep // 0' "$session")))
    total_glob=$((total_glob + $(jq -r '.metrics.tool_usage.Glob // 0' "$session")))
  done

  cat <<EOF
📊 METRICS - Last 7 Days

Sessions: $session_count
Average: $(echo "scale=1; $session_count / 7" | bc 2>/dev/null || echo "~1") sessions/day

Top Tools:
  1. Read: $total_read uses
  2. Edit: $total_edit uses
  3. Bash: $total_bash uses
  4. Grep: $total_grep uses
  5. Glob: $total_glob uses

Profile Usage:
$(for session in $sessions; do jq -r '.profile' "$session"; done | sort | uniq -c | sort -nr | head -5)

---
Data from $session_count sessions
EOF
}

# === FUNCTION: Profile Comparison ===
report_profile() {
  # Find all sessions
  sessions=$(find "$SESSIONS_DIR" -name "*.json" -type f 2>/dev/null | sort)

  if [ -z "$sessions" ]; then
    echo "📊 METRICS - No session data for profile comparison"
    return
  fi

  echo "📊 METRICS - Profile Comparison"
  echo ""

  # Group by profile
  for profile in default focus research implementation; do
    profile_sessions=$(echo "$sessions" | xargs -I {} sh -c "jq -r '.profile' {} 2>/dev/null" | grep -c "^$profile$" 2>/dev/null || echo "0")

    if [ "$profile_sessions" -gt 0 ]; then
      echo "Profile: $profile ($profile_sessions sessions)"

      # Average tool uses
      avg_tools=0
      for session in $sessions; do
        if [ "$(jq -r '.profile' "$session")" == "$profile" ]; then
          tools=$(jq -r '.metrics.profile_performance.tool_uses // 0' "$session")
          avg_tools=$((avg_tools + tools))
        fi
      done

      if [ "$profile_sessions" -gt 0 ]; then
        avg_tools=$((avg_tools / profile_sessions))
      fi

      echo "  Avg Operations: $avg_tools/session"
      echo ""
    fi
  done

  echo "---"
  echo "Compare profiles to optimize workflow"
}

# === FUNCTION: Full Report ===
report_all() {
  echo "📊 MINI-CODERBRAIN METRICS - Full Report"
  echo "========================================"
  echo ""

  report_session
  echo ""
  echo "========================================"
  echo ""

  report_weekly
  echo ""
  echo "========================================"
  echo ""

  report_profile
}

# === MAIN ===
case "$REPORT_TYPE" in
  --session)
    report_session
    ;;

  --weekly)
    report_weekly
    ;;

  --profile)
    report_profile
    ;;

  --all)
    report_all
    ;;

  *)
    # Default: session report
    report_session
    ;;
esac

exit 0
