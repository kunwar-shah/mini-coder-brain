#!/usr/bin/env bash
# Helper: Update last-memory-sync timestamp
# Call this from any command that updates memory bank
#
# Usage:
#   bash .claude/hooks/lib/update-sync-timestamp.sh
#
# Purpose:
#   - Updates last-memory-sync timestamp to current time
#   - Clears notification flags (user acted on notification)
#   - Ensures status footer shows accurate "Last sync" time

set -euo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-.}"
CLAUDE_TMP="$ROOT/.claude/tmp"

# Update timestamp to current time
echo "$(date +%s)" > "$CLAUDE_TMP/last-memory-sync"

# Clear notification flags (user has acted on notifications)
rm -f "$CLAUDE_TMP/last-sync-notification" 2>/dev/null || true
rm -f "$CLAUDE_TMP/update-notified-timestamp" 2>/dev/null || true
rm -f "$CLAUDE_TMP/sync-notified-timestamp" 2>/dev/null || true

# Optional: Log the update (for debugging)
# echo "[$(date --iso-8601=seconds)] Memory sync timestamp updated" >> "$CLAUDE_TMP/sync-updates.log"

exit 0
