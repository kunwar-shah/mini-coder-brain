---
description: Synchronize all memory bank files with current session context
argument-hint: "[--full] [--quick]"
allowed-tools: Read(*), Write(*), Edit(*), Bash(date:*), Bash(echo:*)
---

# Memory Sync — Universal Context Synchronization

Synchronizes all `.claude/memory/` files with current session state, ensuring perfect context preservation across sessions.

## Purpose

The `/memory-sync` command provides intelligent synchronization of your memory bank:
- Updates `activeContext.md` with current focus and progress
- Appends session summary to `progress.md`
- Records technical decisions in `decisionLog.md`
- Refreshes `productContext.md` if project scope changed
- Updates `systemPatterns.md` if new patterns emerged

## Usage

```bash
# Full synchronization (recommended after significant work)
/memory-sync --full

# Quick sync (active context only)
/memory-sync --quick

# Default: Smart sync based on session activity
/memory-sync
```

## What Gets Synchronized

### Always Updated
- **activeContext.md**: Current focus, recent achievements, next priorities, blockers
- Session timestamp and activity summary

### Conditionally Updated (--full flag)
- **progress.md**: Completed tasks, in-progress items, next sprint goals
- **decisionLog.md**: Technical decisions made during session (ADR format)
- **systemPatterns.md**: New patterns or conventions adopted
- **productContext.md**: Project overview if scope changed

## Synchronization Process

1. **Analyze Session Activity**
   - Count operations performed (Read, Write, Edit, Bash)
   - Identify files modified
   - Detect technical decisions made
   - Extract progress milestones

2. **Record Sync Timestamp** (IMPORTANT - do this FIRST)
   - Update `.claude/tmp/last-memory-sync` with current Unix timestamp: `date +%s > .claude/tmp/last-memory-sync`
   - This tracks when sync was performed for notification system

3. **Update Active Context**
   - Append session summary with timestamp
   - Update current focus if changed
   - Add new blockers discovered
   - Record achievements completed

4. **Update Progress (if --full)**
   - Move completed items to ✅ COMPLETED section
   - Update in-progress status
   - Add new pending tasks
   - Update sprint progress percentage

5. **Record Decisions (if --full)**
   - Extract technical decisions from conversation
   - Format as ADR (Architecture Decision Record)
   - Append to decisionLog.md with timestamp

6. **Update Patterns (if applicable)**
   - Detect new coding patterns adopted
   - Record architectural changes
   - Update technology stack if changed

## Examples

### After Feature Completion
```bash
/memory-sync --full
# Updates: activeContext, progress (marks feature complete), decisionLog (records decisions)
```

### After Bug Fix Session
```bash
/memory-sync
# Updates: activeContext with fix summary, maintains continuity
```

### Quick Context Update
```bash
/memory-sync --quick
# Updates: activeContext only, fastest sync
```

## Benefits

- ✅ **Perfect Continuity**: Next session starts with complete context
- ✅ **Historical Record**: Every session preserved with timestamps
- ✅ **Decision Tracking**: Technical decisions never lost
- ✅ **Progress Visibility**: Always know what's completed and what's next
- ✅ **Pattern Recognition**: Coding standards emerge and are recorded

## Automatic vs Manual Sync

### Automatic Sync (via hooks)
- **Session End**: Basic activeContext update via stop hook
- **Low Impact**: Minimal context updates only

### Manual Sync (this command)
- **Full Control**: Decide what to sync and when
- **Rich Context**: Detailed analysis and updates
- **After Significant Work**: When automatic sync isn't enough

## Best Practices

1. **Run after completing significant work**
   - Feature completion
   - Major refactoring
   - Technical decision made
   - Architecture change

2. **Use --full for milestone sessions**
   - End of day
   - End of sprint
   - After major achievement

3. **Use --quick for frequent updates**
   - Every few hours
   - After small tasks
   - Quick context preservation

4. **Trust automatic sync for minor work**
   - Small bug fixes
   - Documentation updates
   - Minor tweaks

## Integration with Other Commands

- **After `/map-codebase`**: Sync to record codebase mapping completion
- **After `/umb`**: `/memory-sync` is more comprehensive, `/umb` is faster
- **Before session end**: Ensure context is preserved before closing

## Output

```
🔄 Memory Sync Started...

✅ Analyzed session activity: 47 operations
✅ Updated activeContext.md (Current focus + session summary)
✅ Updated progress.md (2 tasks completed, 1 in progress)
✅ Updated decisionLog.md (1 technical decision recorded)

🎯 Memory Bank synchronized successfully!
📁 Context preserved in .claude/memory/

Next session will load with complete context awareness.
```

## Technical Notes

- Appends with UTC timestamps (never overwrites history)
- Preserves markdown formatting
- Validates files before writing
- Creates backups for safety
- Works offline (no external dependencies)

---

**Related Commands**: `/umb`, `/context-update`
**Frequency**: Run after significant work sessions
**Impact**: High - ensures perfect context continuity
