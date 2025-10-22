#!/usr/bin/env bash
set -u

# Pre-Compact Hook - Preserve context before conversation compaction
# Runs automatically when Claude Code is about to compact the conversation
# Philosophy: Graceful degradation - prefer fallback over failure

ROOT="${CLAUDE_PROJECT_DIR:-.}"
LIB="$ROOT/.claude/hooks/lib/hook-patterns.sh"

# Source bulletproof patterns library
source "$LIB"

# Setup safe exit trap (CRITICAL: ensures we always exit 0)
setup_safe_exit_trap

MB="$ROOT/.claude/memory"
CLAUDE_TMP="$ROOT/.claude/tmp"

# Ensure directories exist (using safe pattern)
ensure_dir "$MB/conversations/compact-summaries"
ensure_dir "$MB"
ensure_dir "$CLAUDE_TMP/precompact"

# Ensure memory files exist
touch "$MB/progress.md" "$MB/activeContext.md" "$MB/decisionLog.md" 2>/dev/null || true

# Timestamp
ts="precompact-$(date +%Y%m%d-%H%M%S)"
dt="$(date --iso-8601=seconds)"

# Read hook input (SAFE: never crash on empty/invalid stdin)
input=$(read_stdin_safe "{}")

# Extract reason field (SAFE: no jq dependency, pure bash)
reason=$(extract_json_field "$input" "reason" "conversation_length")

# Create pre-compact summary to preserve session context
compact_summary="$MB/conversations/compact-summaries/$ts.md"
local_backup="$CLAUDE_TMP/precompact/$ts.md"

cat > "$compact_summary" <<EOF
# Pre-Compact Session Context — $ts

**Timestamp**: $dt
**Reason**: $reason
**Session Phase**: Mid-session context preservation

## Current Development Focus
$(grep -A 5 "🎯 Current Focus" "$MB/activeContext.md" 2>/dev/null | tail -4 || echo "Check activeContext.md for current objectives")

## Session Accomplishments So Far
$(tail -10 "$MB/progress.md" 2>/dev/null | grep -E "✅.*$(date '+%Y-%m-%d')" | tail -5 || echo "- No recent completions found")

## Technical Context at Compaction
- **Memory-bank files**: $(find "$MB" -name "*.md" -type f | wc -l) total
- **Hook activity**: All hooks operational
- **Development state**: $(grep -o "Ready for.*" "$MB/activeContext.md" 2>/dev/null | head -1 || echo "Development in progress")

## Immediate Next Steps (Pre-Compact)
$(grep -A 8 "🚀 Next Priorities" "$MB/activeContext.md" 2>/dev/null | head -6 | tail -5 || echo "- Continue current development focus")

---
**Pre-compact preservation** • **Context continuity maintained** • **Ready for conversation compaction**
EOF

# Local backup for visibility
cp "$compact_summary" "$local_backup" 2>/dev/null || true

# Log compaction event
{
  echo ""
  echo "## 🔄 SESSION COMPACTION @ $(date '+%Y-%m-%d %H:%M UTC')"
  echo "- **Context preserved**: $ts.md"
  echo "- **Reason**: $reason"
  echo "- **Continuity**: Context maintained post-compaction"
} >> "$CLAUDE_TMP/session-compaction.log" || true

# Add to decisionLog for tracking
{
  echo ""
  echo "## [$(date '+%Y-%m-%d %H:%M:%S UTC')] ADR-COMPACT-$(date +%Y%m%d) — Session Context Preservation"
  echo "**Decision**: Preserve session context before conversation compaction"
  echo "**Rationale**: Maintain development continuity during long sessions"
  echo "**Impact**: Enhanced context awareness and seamless transitions"
  echo "**Context preserved**: compact-summaries/$ts.md"
} >> "$MB/decisionLog.md" || true

# Cleanup old compact summaries (keep last 20)
find "$MB/conversations/compact-summaries/" -name "precompact-*.md" -type f 2>/dev/null | sort | head -n -20 | xargs -r rm -f 2>/dev/null || true

# Log to hook activity
{
  echo "$(date --iso-8601=seconds) PRECOMPACT Hook executed"
  echo "  - Summary: $ts.md"
  echo "  - Reason: $reason"
  echo "  - Backup: .claude/tmp/precompact/$ts.md"
} >> "$CLAUDE_TMP/hook-activity.log" 2>/dev/null || true

# Update sync timestamp (Fix #3: Status footer integration)
bash "$ROOT/.claude/hooks/lib/update-sync-timestamp.sh" 2>/dev/null || true

# CRITICAL: Always exit 0, never crash the session
safe_exit
