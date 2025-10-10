# Archive Directory — Historical Memory Bank Data

This directory stores archived memory bank data to keep active context files lean and prevent "Prompt is too long" errors.

---

## What Gets Archived

### Session History Archives
**File Pattern**: `session-history-YYYY-MM.md`
**Content**: Old session update entries from `activeContext.md`
**Retention**: Keep last 5 session updates active, archive older ones
**When**: Automatically when `/memory-cleanup` is run

### Decision Log Archives
**File Pattern**: `decisions-archive-YYYY-MM.md`
**Content**: Deduplicated ADR entries from `decisionLog.md`
**Retention**: Consolidate repetitive entries, archive duplicates
**When**: Automatically when `/memory-cleanup` is run

---

## How Archiving Works

1. **Detection**: `intelligent-status-notification.sh` detects bloat (>10 session updates or >200 lines)
2. **Notification**: User notified to run `/memory-cleanup`
3. **Archiving**: `/memory-cleanup` command moves old data to monthly archive files
4. **Preservation**: All data preserved - nothing deleted, only moved
5. **Cleanup**: Active memory files reduced by ~60% (~4000 tokens saved)

---

## Archive File Structure

```
.claude/archive/
├── README.md (this file)
├── session-history-2025-09.md    # September session updates
├── session-history-2025-10.md    # October session updates
├── decisions-archive-2025-09.md  # September decision log
└── decisions-archive-2025-10.md  # October decision log
```

---

## Accessing Archived Data

Archives are regular markdown files you can:
- Read directly with any text editor
- Search with `grep` or IDE search
- Reference in commands: `@.claude/archive/session-history-2025-10.md`
- Restore if needed (copy back to memory/)

---

## Retention Policy

- **Active Context**: Last 5 session updates only
- **Archives**: Retained indefinitely (user can delete old months manually)
- **Tmp Files**: Auto-deleted after 1 hour (not archived)
- **Cache Files**: Auto-deleted after 7 days (not archived)

---

## Manual Management

You can safely:
- ✅ Read any archive file
- ✅ Delete old month archives (>6 months) to save disk space
- ✅ Restore archived sessions by copying back to `activeContext.md`
- ❌ Don't edit archives (they're historical records)

---

**Purpose**: Prevent memory bloat while preserving all development history
**Benefit**: Lean active context + complete historical archive = best of both worlds
