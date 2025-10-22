#!/usr/bin/env bash
# Footer Validator Stop Hook
# ENFORCES footer requirements by BLOCKING stop if footer is invalid
# Exit code 2 = BLOCKS Claude from stopping, forces continuation

set -eu

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
MB="$ROOT/.claude/memory"
TMP="$ROOT/.claude/tmp"

# Read hook input
input=$(cat)

# === FOOTER VALIDATION ===

# Run validation script to get required footer data
validation_output=$(bash "$ROOT/.claude/validation/footer-requirements.sh" 2>/dev/null || echo "VALIDATION_FAILED")

if [ "$validation_output" = "VALIDATION_FAILED" ]; then
  # Validation script failed - allow stop (don't block on script errors)
  exit 0
fi

# Extract required values from validation script
ops=$(echo "$validation_output" | grep "📊 Activity:" | awk '{print $3}')
required_notification=$(echo "$validation_output" | grep -A1 "🔔 REQUIRED NOTIFICATION:" | tail -1)

# Check if notification is required
notification_required=false
if [ "$required_notification" != "NONE - Display 4-line footer only" ]; then
  notification_required=true
fi

# === CHECK IF FOOTER WAS DISPLAYED IN RESPONSE ===
# We can't directly read AI's response, but we can check tool logs
# to see if validation was run

# Create validation checkpoint
checkpoint_file="$TMP/last-footer-validation-check"
current_time=$(date +%s)
echo "$current_time|$ops|$notification_required" > "$checkpoint_file"

# Check if ops count is suspiciously high (possible footer skipping)
if [ "${ops:-0}" -ge 50 ]; then
  # High activity - notification IS required

  # Get last sync time
  if [ -f "$TMP/last-memory-sync" ]; then
    last_sync=$(cat "$TMP/last-memory-sync")
    min_ago=$(( (current_time - last_sync) / 60 ))

    if [ "$min_ago" -ge 10 ]; then
      # CRITICAL: High activity + old sync = notification REQUIRED
      # We can't verify if notification was shown, but we can log this

      echo "VALIDATION: High activity session (${ops} ops, ${min_ago}m since sync)" >> "$TMP/footer-validation.log"
      echo "REQUIRED: 💡 🔄 High activity notification" >> "$TMP/footer-validation.log"
      echo "Timestamp: $(date --iso-8601=seconds)" >> "$TMP/footer-validation.log"
      echo "---" >> "$TMP/footer-validation.log"
    fi
  fi
fi

# === DECISION: Allow or Block Stop ===

# For v2.2: We LOG the requirement but DON'T block
# (Blocking would require reading AI's actual response text)
# This creates audit trail for debugging

exit 0

# === FUTURE: Response Text Validation (if Claude Code adds support) ===
# If Claude Code ever provides response text to stop hook:
#
# if ! echo "$response_text" | grep -q "🧠 MINI-CODER-BRAIN STATUS"; then
#   # Footer missing - BLOCK stop and force continuation
#   cat <<EOF
# {
#   "decision": "block",
#   "reason": "VALIDATION FAILED: You must display the status footer before stopping. Run: bash .claude/validation/footer-requirements.sh and display the exact footer data at the end of your response."
# }
# EOF
#   exit 2
# fi
#
# if [ "$notification_required" = "true" ]; then
#   if ! echo "$response_text" | grep -q "💡"; then
#     # Notification required but missing - BLOCK stop
#     cat <<EOF
# {
#   "decision": "block",
#   "reason": "VALIDATION FAILED: High activity notification required but missing. Activity: ${ops} ops. You must add 5th line: ${required_notification}"
# }
# EOF
#     exit 2
#   fi
# fi

# === END FUTURE VALIDATION ===
