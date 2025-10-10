# /memory-cleanup — Memory Bank Cleanup & Optimization

**Purpose**: Archive old session updates, deduplicate ADRs, clean temporary files to prevent "Prompt is too long" errors

**When to use**: Run when notified by intelligent-status-notification.sh, or manually when memory bloat is suspected

---

## Command Behavior

When you run `/memory-cleanup`, I will:

1. **Analyze current bloat sources**
   - Count session updates in activeContext.md
   - Count ADR entries in decisionLog.md
   - Check file sizes and tmp/ directory

2. **Archive old session updates** (keep last 5)
   - Move old updates to `.claude/archive/session-history-YYYY-MM.md`
   - Preserve all data (never delete)
   - Update activeContext.md with clean structure

3. **Deduplicate decision log**
   - Consolidate repetitive ADR entries
   - Keep first and last occurrence of each decision type
   - Archive duplicates to `.claude/archive/decisions-archive-YYYY-MM.md`

4. **Clean temporary files**
   - Remove micro-context files > 1 hour old
   - Clean stale cache files > 7 days old
   - Clear notification markers

5. **Report cleanup results**
   - Show before/after file sizes
   - Report tokens saved (~60% reduction expected)
   - Confirm data preserved in archives

---

## Configuration

Default cleanup thresholds (can be customized):
- **Session updates to keep**: 5 (most recent)
- **Tmp file max age**: 1 hour
- **Cache file max age**: 7 days
- **Archive location**: `.claude/archive/`

---

## Safety Features

- ✅ **Never deletes data** - everything archived
- ✅ **Atomic operations** - uses temp files + move
- ✅ **Dry-run available** - test without changes
- ✅ **Rollback capability** - archives allow restoration
- ✅ **Backup before cleanup** - optional safety net

---

## Example Usage

**Basic cleanup**:
```
User: /memory-cleanup
AI: Analyzing memory bloat...
    Found: 21 session updates (recommend: keep 5)
    Archiving 16 old session updates to .claude/archive/session-history-2025-10.md
    Deduplicating 8 repetitive ADRs
    Cleaning 0 tmp files

    ✅ Cleanup complete!
    Before: activeContext.md = 206 lines (~7000 tokens)
    After: activeContext.md = 82 lines (~2800 tokens)
    Saved: ~4200 tokens (60% reduction)

    All data preserved in .claude/archive/
```

**Dry-run mode** (test without changes):
```
User: /memory-cleanup --dry-run
AI: [Shows what would be cleaned without making changes]
```

**Full cleanup** (aggressive):
```
User: /memory-cleanup --full
AI: [Cleans everything, keeps only last 3 session updates]
```

---

## When to Run

- **Critical**: When notified "🧹 MEMORY CLEANUP RECOMMENDED"
- **Preventive**: After major development sessions (10+ operations)
- **Regular**: Once per week for active projects
- **Emergency**: When experiencing "Prompt is too long" errors

---

## Implementation

This command executes `.claude/hooks/memory-cleanup.sh` which performs the cleanup logic.

**Related hooks**:
- `intelligent-status-notification.sh` - Detects bloat and notifies
- `session-start.sh` - Lightweight tmp/ cleanup on startup

---

**Version**: 1.0
**Part of**: Mini-CoderBrain Memory Management System
