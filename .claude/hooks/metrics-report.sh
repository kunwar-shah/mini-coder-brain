#!/usr/bin/env bash
set -eu

# Metrics Reporting for Mini-CoderBrain v2.1
# Generates human-readable reports from collected metrics
# Works with or without jq - graceful fallback to basic tool logs

ROOT="${CLAUDE_PROJECT_DIR:-.}"
METRICS_DIR="$ROOT/.claude/metrics"
SESSIONS_DIR="$METRICS_DIR/sessions"
MB="$ROOT/.claude/memory"
TOOL_TRACKING="$MB/conversations/tool-tracking"
CLAUDE_TMP="$ROOT/.claude/tmp"

# Check if jq is available (optional)
HAS_JQ=false
if command -v jq >/dev/null 2>&1; then
  HAS_JQ=true
fi

# Ensure directories exist
mkdir -p "$SESSIONS_DIR" 2>/dev/null || true

# Get report type
REPORT_TYPE="${1:---session}"

# === FUNCTION: Basic Session Report (No jq required) ===
report_session_basic() {
  TODAY=$(date '+%Y-%m-%d')
  tools_log="$TOOL_TRACKING/$TODAY-tools.log"

  echo "📊 MINI-CODER-BRAIN METRICS REPORT"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📅 Session Date: $TODAY"

  # Session duration
  if [ -f "$CLAUDE_TMP/session-start-time" ]; then
    start_time=$(cat "$CLAUDE_TMP/session-start-time")
    current_time=$(date +%s)
    duration_min=$(( (current_time - start_time) / 60 ))
    duration_hours=$(( duration_min / 60 ))
    duration_rem=$(( duration_min % 60 ))
    if [ "$duration_hours" -gt 0 ]; then
      echo "⏱️  Session Duration: ${duration_hours}h ${duration_rem}m"
    else
      echo "⏱️  Session Duration: ${duration_min}m"
    fi
  elif [ -f "$CLAUDE_TMP/context-loaded.flag" ]; then
    flag_time=$(stat -c %Y "$CLAUDE_TMP/context-loaded.flag" 2>/dev/null || stat -f %m "$CLAUDE_TMP/context-loaded.flag" 2>/dev/null || echo "0")
    if [ "$flag_time" -gt 0 ]; then
      current_time=$(date +%s)
      duration_min=$(( (current_time - flag_time) / 60 ))
      duration_hours=$(( duration_min / 60 ))
      duration_rem=$(( duration_min % 60 ))
      if [ "$duration_hours" -gt 0 ]; then
        echo "⏱️  Session Duration: ~${duration_hours}h ${duration_rem}m (approx)"
      else
        echo "⏱️  Session Duration: ~${duration_min}m (approx)"
      fi
    fi
  else
    echo "⏱️  Session Duration: Unknown"
  fi

  # Profile
  profile="default"
  if [ -f "$CLAUDE_TMP/current-profile" ]; then
    profile=$(cat "$CLAUDE_TMP/current-profile" 2>/dev/null || echo "default")
  fi
  echo "🎭 Profile: $profile"
  echo ""

  # Tool usage
  echo "🔧 TOOL USAGE"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ -f "$tools_log" ] && [ -s "$tools_log" ]; then
    total=$(wc -l < "$tools_log" | tr -d ' ')
    echo "📊 Total Operations: $total"
    echo ""

    # Count by tool
    echo "Tool Breakdown:"
    awk '{print $NF}' "$tools_log" | sort | uniq -c | sort -rn | while read count tool; do
      percent=$(( count * 100 / total ))
      printf "  %-12s: %3d uses (%2d%%)\n" "$tool" "$count" "$percent"
    done
  else
    echo "📊 Total Operations: 0 (no activity today)"
    echo ""
    echo "Tool Breakdown:"
    echo "  No operations recorded yet"
  fi
  echo ""

  # Memory health
  echo "💾 MEMORY HEALTH"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ -f "$MB/activeContext.md" ]; then
    session_count=$(grep -c "^## .* Session Update" "$MB/activeContext.md" 2>/dev/null || echo "0")
    active_lines=$(wc -l < "$MB/activeContext.md" 2>/dev/null | tr -d ' ')

    if [ "$session_count" -gt 15 ]; then
      health="🔴 Needs Cleanup"
    elif [ "$session_count" -gt 10 ]; then
      health="🟡 Monitor"
    else
      health="🟢 Healthy"
    fi

    echo "Status: $health"
    echo "Session Updates: $session_count"
    echo "ActiveContext Size: $active_lines lines"
  else
    echo "Status: 🟢 Healthy (no data)"
  fi
  echo ""

  # Last sync
  echo "🔄 SYNCHRONIZATION"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ -f "$CLAUDE_TMP/last-memory-sync" ]; then
    last_sync_time=$(cat "$CLAUDE_TMP/last-memory-sync" 2>/dev/null || echo "0")
    current_time=$(date +%s)
    minutes_ago=$(( (current_time - last_sync_time) / 60 ))

    if [ "$minutes_ago" -eq 0 ]; then
      echo "Last Sync: Just now"
    elif [ "$minutes_ago" -lt 60 ]; then
      echo "Last Sync: ${minutes_ago}m ago"
    elif [ "$minutes_ago" -lt 1440 ]; then
      hours_ago=$((minutes_ago / 60))
      echo "Last Sync: ${hours_ago}h ago"
    else
      days_ago=$((minutes_ago / 1440))
      echo "Last Sync: ${days_ago}d ago"
    fi
  else
    echo "Last Sync: Never"
  fi
  echo ""

  # Codebase map
  echo "🗺️  CODEBASE MAP"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ -f "$ROOT/.claude/cache/codebase-map.json" ]; then
    map_time=$(stat -c %Y "$ROOT/.claude/cache/codebase-map.json" 2>/dev/null || stat -f %m "$ROOT/.claude/cache/codebase-map.json" 2>/dev/null || echo "0")
    if [ "$map_time" -gt 0 ]; then
      current_time=$(date +%s)
      age_hours=$(( (current_time - map_time) / 3600 ))

      if [ "$age_hours" -lt 4 ]; then
        echo "Status: 🟢 Fresh (${age_hours}h old)"
      elif [ "$age_hours" -lt 24 ]; then
        echo "Status: 🟡 OK (${age_hours}h old)"
      else
        echo "Status: 🔴 Stale (${age_hours}h old)"
      fi
    else
      echo "Status: ⚫ Not Created"
    fi
  else
    echo "Status: ⚫ Not Created"
    echo "Tip: Run /map-codebase to enable instant file access"
  fi
  echo ""

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ "$HAS_JQ" = true ]; then
    echo "💡 jq detected - advanced metrics available with --weekly"
  else
    echo "💡 Install jq for advanced weekly/profile metrics"
    echo "   apt-get install jq  (or brew install jq on macOS)"
  fi
  echo ""
}

# === FUNCTION: Weekly Summary (jq required) ===
report_weekly() {
  if [ "$HAS_JQ" = false ]; then
    echo "⚠️  Weekly metrics require jq"
    echo ""
    echo "Basic weekly summary (last 7 days):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Count tool logs from last 7 days
    total_ops=0
    days_with_activity=0
    for i in $(seq 0 6); do
      check_date=$(date -d "$i days ago" '+%Y-%m-%d' 2>/dev/null || date -v -${i}d '+%Y-%m-%d' 2>/dev/null || echo "")
      if [ -n "$check_date" ] && [ -f "$TOOL_TRACKING/$check_date-tools.log" ]; then
        ops=$(wc -l < "$TOOL_TRACKING/$check_date-tools.log" 2>/dev/null | tr -d ' ')
        total_ops=$((total_ops + ops))
        days_with_activity=$((days_with_activity + 1))
      fi
    done

    echo "Active Days: $days_with_activity / 7"
    echo "Total Operations: $total_ops"
    if [ "$days_with_activity" -gt 0 ]; then
      avg_ops=$((total_ops / days_with_activity))
      echo "Avg Operations/Active Day: $avg_ops"
    fi
    echo ""
    echo "Install jq for detailed weekly metrics:"
    echo "  apt-get install jq  (or brew install jq)"
    return
  fi

  # Full weekly report with jq
  sessions=$(find "$SESSIONS_DIR" -name "*.json" -type f -mtime -7 2>/dev/null | sort)

  if [ -z "$sessions" ]; then
    echo "📊 METRICS - No detailed sessions in last 7 days"
    echo ""
    echo "Note: Session JSON files are created at session end"
    return
  fi

  session_count=$(echo "$sessions" | wc -l | tr -d ' ')

  # Aggregate tool usage
  total_read=0
  total_edit=0
  total_bash=0

  for session in $sessions; do
    total_read=$((total_read + $(jq -r '.metrics.tool_usage.Read // 0' "$session" 2>/dev/null || echo "0")))
    total_edit=$((total_edit + $(jq -r '.metrics.tool_usage.Edit // 0' "$session" 2>/dev/null || echo "0")))
    total_bash=$((total_bash + $(jq -r '.metrics.tool_usage.Bash // 0' "$session" 2>/dev/null || echo "0")))
  done

  cat <<EOF
📊 METRICS - Last 7 Days

Sessions: $session_count
Average: $(echo "scale=1; $session_count / 7" | bc 2>/dev/null || echo "~1") sessions/day

Top Tools:
  Read: $total_read uses
  Edit: $total_edit uses
  Bash: $total_bash uses

---
Data from $session_count detailed sessions
EOF
}

# === FUNCTION: Profile Comparison (jq required) ===
report_profile() {
  if [ "$HAS_JQ" = false ]; then
    echo "⚠️  Profile comparison requires jq"
    echo ""
    echo "Current profile: $(cat "$CLAUDE_TMP/current-profile" 2>/dev/null || echo "default")"
    echo ""
    echo "Install jq for profile comparison metrics:"
    echo "  apt-get install jq  (or brew install jq)"
    return
  fi

  sessions=$(find "$SESSIONS_DIR" -name "*.json" -type f 2>/dev/null | sort)

  if [ -z "$sessions" ]; then
    echo "📊 METRICS - No session data for profile comparison"
    echo ""
    echo "Note: Profile metrics collected at session end"
    return
  fi

  echo "📊 METRICS - Profile Comparison"
  echo ""

  for profile in default focus research implementation; do
    profile_sessions=$(echo "$sessions" | xargs -I {} sh -c "jq -r '.profile' {} 2>/dev/null" | grep -c "^$profile$" 2>/dev/null || echo "0")

    if [ "$profile_sessions" -gt 0 ]; then
      echo "Profile: $profile ($profile_sessions sessions)"
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

  report_session_basic
  echo ""
  echo "========================================"
  echo ""

  if [ "$HAS_JQ" = true ]; then
    report_weekly
    echo ""
    echo "========================================"
    echo ""
    report_profile
  else
    report_weekly
  fi
}

# === MAIN ===
case "$REPORT_TYPE" in
  --session|--basic)
    report_session_basic
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
    # Default: basic session report (no jq required)
    report_session_basic
    ;;
esac

exit 0
