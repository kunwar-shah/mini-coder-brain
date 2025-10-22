#!/usr/bin/env bash
# Pre-Response Footer Validation
# Calculates EXACT footer data and required notifications
# AI MUST use this data (not estimate)

set -euo pipefail

MB=".claude/memory"
TMP=".claude/tmp"
TODAY=$(date '+%Y-%m-%d')

# =====================================================
# CALCULATE ALL FOOTER DATA
# =====================================================

# 1. Activity Count
tool_log="$MB/conversations/tool-tracking/${TODAY}-tools.log"
if [ -f "$tool_log" ]; then
  ops=$(wc -l < "$tool_log" 2>/dev/null || echo "0")
else
  ops=0
fi

# 2. Session Duration
if [ -f "$TMP/session-start-time" ]; then
  start_time=$(cat "$TMP/session-start-time")
  current_time=$(date +%s)
  total_minutes=$(( (current_time - start_time) / 60 ))

  if [ "$total_minutes" -lt 60 ]; then
    duration="${total_minutes}m"
  elif [ "$total_minutes" -lt 1440 ]; then
    hours=$(( total_minutes / 60 ))
    mins=$(( total_minutes % 60 ))
    duration="${hours}h ${mins}m"
  else
    days=$(( total_minutes / 1440 ))
    remaining=$(( total_minutes % 1440 ))
    hours=$(( remaining / 60 ))
    duration="${days}d ${hours}h"
  fi
else
  duration="Unknown"
fi

# 3. Last Sync
if [ -f "$TMP/last-memory-sync" ]; then
  last_sync=$(cat "$TMP/last-memory-sync")
  current_time=$(date +%s)
  min_ago=$(( (current_time - last_sync) / 60 ))

  if [ "$min_ago" -eq 0 ]; then
    last_sync_display="Just now"
  elif [ "$min_ago" -lt 60 ]; then
    last_sync_display="${min_ago}m ago"
  elif [ "$min_ago" -lt 1440 ]; then
    hours=$(( min_ago / 60 ))
    last_sync_display="${hours}h ago"
  else
    days=$(( min_ago / 1440 ))
    last_sync_display="${days}d ago"
  fi
else
  last_sync_display="Never"
  min_ago=999999  # Force notification
fi

# 4. Current Profile
if [ -f "$TMP/current-profile" ]; then
  profile=$(cat "$TMP/current-profile")
else
  profile="default"
fi

# 5. Memory Health
if [ -f "$MB/activeContext.md" ]; then
  session_updates=$(grep -c "^## Session Update" "$MB/activeContext.md" 2>/dev/null || echo "0")

  if [ "$session_updates" -gt 15 ]; then
    memory_health="Needs Cleanup"
  elif [ "$session_updates" -gt 10 ]; then
    memory_health="Monitor"
  else
    memory_health="Healthy"
  fi
else
  session_updates=0
  memory_health="Unknown"
fi

# 6. Map Status
if [ -f ".claude/cache/codebase-map.json" ]; then
  map_age=$(( ($(date +%s) - $(stat -c %Y ".claude/cache/codebase-map.json" 2>/dev/null || echo "0")) / 3600 ))
  if [ "$map_age" -gt 24 ]; then
    map_status="Stale"
  else
    map_status="Fresh"
  fi
else
  map_status="None"
fi

# =====================================================
# DETECT REQUIRED NOTIFICATIONS
# =====================================================

notification=""

# CONDITION 1: Memory Cleanup
if [ "$session_updates" -gt 10 ]; then
  notification="💡 🧹 Memory cleanup recommended (${session_updates} session updates). Run /memory-cleanup."
fi

# CONDITION 2: High Activity (takes priority over memory cleanup)
if [ "$ops" -ge 50 ] && [ "$min_ago" -ge 10 ]; then
  notification="💡 🔄 High activity session (${ops} ops, ${min_ago}m since sync). Consider: /memory-sync."
fi

# CONDITION 3: Stale Map
if [ "$map_status" = "Stale" ]; then
  # Only show if no higher priority notification
  if [ -z "$notification" ]; then
    notification="💡 🗺️ Codebase map is stale. Run /map-codebase --rebuild to refresh."
  fi
fi

# =====================================================
# OUTPUT EXACT FOOTER DATA
# =====================================================

cat <<EOF
================================================================================
🎯 FOOTER REQUIREMENTS (YOU MUST USE THIS EXACT DATA)
================================================================================

📊 Activity: ${ops} ops
🗺️ Map: ${map_status}
⚡ Context: Active
🎭 Profile: ${profile}
⏱️ Duration: ${duration}
💾 Memory: ${memory_health} (${session_updates} session updates)
🔄 Last sync: ${last_sync_display}

🔔 REQUIRED NOTIFICATION:
${notification:-NONE - Display 4-line footer only}

================================================================================
VALIDATION CHECKLIST (YOU MUST VERIFY):
================================================================================
✅ Footer shows EXACT activity count: ${ops} ops (not estimated)
✅ Footer shows EXACT last sync: ${last_sync_display} (not "N/A")
✅ Footer shows memory health: ${memory_health}
$([ -n "$notification" ] && echo "✅ Footer includes 5th line with notification" || echo "✅ Footer is 4 lines only (no notification required)")

❌ FORBIDDEN:
❌ DO NOT estimate activity count
❌ DO NOT skip notification when required
❌ DO NOT show "N/A" for values that exist
❌ DO NOT add notification when none required

================================================================================
EOF
