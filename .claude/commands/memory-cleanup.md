# /memory-cleanup — Memory Bank Cleanup & Optimization

**CRITICAL INSTRUCTION**: YOU MUST complete ALL steps below IN EXACT ORDER. DO NOT SKIP any step. ONLY use Read, Edit, and Bash tools as specified.

**Purpose**: Archive old session updates, deduplicate ADRs, clean temporary files to prevent "Prompt is too long" errors

**When to use**: Run when notified by intelligent-status-notification.sh, or manually when memory bloat is suspected

---

## EXECUTION STEPS - MANDATORY

When you run `/memory-cleanup`, YOU MUST:

## STEP 1: Analyze Bloat Sources - MANDATORY

**YOU MUST USE Read TOOL** to analyze these files:
- `.claude/memory/activeContext.md`
- `.claude/memory/decisionLog.md`

**DETECT**:
- Count session updates in activeContext.md (search for "## Session Update" headers)
- Count ADR entries in decisionLog.md (search for "ADR-" patterns)
- Calculate file sizes

**OUTPUT** (show user):
```
📊 Memory Bloat Analysis:
   - activeContext.md: [size]KB, [N] session updates
   - decisionLog.md: [size]KB, [N] ADRs
   - Recommendation: [Keep last 5 updates / Clean needed / No action]
```

**VALIDATION**:
- ✅ Used Read tool on both files
- ✅ Counted session updates accurately
- ✅ Reported findings to user

---

## STEP 2: Archive Old Session Updates - MANDATORY

**CONDITION**: IF session updates > 5

**YOU MUST USE Edit TOOL** to archive old updates

**METHOD**:
1. Read activeContext.md (already done in STEP 1)
2. Identify session updates to archive (all except last 5)
3. Extract old updates to archive file
4. Remove old updates from activeContext.md (keep last 5)

**ARCHIVE FORMAT**:
File: `.claude/archive/session-history-YYYY-MM.md`
Content: Old session updates with timestamps

**VALIDATION**:
- ✅ Used Edit tool (not Write)
- ✅ Kept exactly 5 most recent updates
- ✅ Archived old updates (never deleted)
- ✅ Preserved all data

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT delete any session updates
- ❌ DO NOT keep more than 5 updates
- ❌ DO NOT lose any historical data
- ❌ DO NOT use Write tool (will overwrite file)

**IF session updates ≤ 5** → Skip to STEP 3

---

## STEP 3: Clean Temporary Files - MANDATORY

**YOU MUST USE Bash TOOL** to clean temp files

**EXACT COMMANDS**:
```bash
# Clean old micro-context files (>1 hour)
find .claude/tmp -name "micro-context-*.md" -mmin +60 -delete 2>/dev/null || true

# Clean stale cache files (>7 days)
find .claude/cache -type f -mtime +7 -delete 2>/dev/null || true

# Clear notification markers
rm -f .claude/tmp/notification-* 2>/dev/null || true
```

**VALIDATION**:
- ✅ Ran all cleanup commands
- ✅ No errors occurred
- ✅ Temporary files cleaned

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT delete memory bank files
- ❌ DO NOT delete hooks
- ❌ DO NOT delete archive folder
- ❌ DO NOT delete project files

---

## STEP 4: Report Cleanup Results - MANDATORY

**YOU MUST OUTPUT** in this EXACT format:

```
🧹 Memory Cleanup Complete!

📊 Before/After:
   - activeContext.md: [before]KB → [after]KB ([saved]KB saved)
   - Session updates: [before] → 5 ([archived] archived)
   - Temp files cleaned: [count] files

💾 Data Preserved:
   ✅ Old session updates archived to: .claude/archive/session-history-YYYY-MM.md
   ✅ All historical data preserved (nothing deleted)

📈 Token Efficiency:
   - Estimated tokens saved: ~[N] tokens ([percentage]% reduction)
   - activeContext.md now optimized for session loading

💡 Next: Continue development with optimized context!
```

---

## CRITICAL VALIDATIONS - MANDATORY

**BEFORE CLAIMING SUCCESS**, verify:
- ✅ Completed ALL applicable steps (1-4) in exact order
- ✅ Used Edit tool for file modifications (not Write)
- ✅ Archived old data (never deleted)
- ✅ Kept exactly 5 recent session updates
- ✅ Cleaned temporary files only
- ✅ Reported accurate before/after stats

**IF ANY VALIDATION FAILS** → Report: "❌ Failed at STEP [X]: [reason]"

---

## ABSOLUTELY FORBIDDEN

- ❌ DO NOT delete any memory bank content
- ❌ DO NOT use Write tool (will overwrite - use Edit)
- ❌ DO NOT keep more than 5 session updates
- ❌ DO NOT clean memory bank files
- ❌ DO NOT delete hooks or commands
- ❌ DO NOT lose historical data
- ❌ DO NOT claim success if validations fail

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

## Hybrid Approach - AI + Shell Script Safety Net

**Architecture**: This command uses a **hybrid intelligent design**:

### Primary: AI-Driven Cleanup (Flexible)
- Uses mental model instructions with Read, Edit, Bash tools
- Adapts to edge cases and explains actions
- Interactive feedback during cleanup
- Handles complex scenarios

### Safety Net: Shell Script Backup (Deterministic)
- File: `.claude/hooks/memory-cleanup.sh`
- Carefully designed for exact folder structure
- Deterministic, reliable edge case handling
- Can run independently if AI skips something

### When to Use Shell Script Directly

**Run shell script manually**:
```bash
bash .claude/hooks/memory-cleanup.sh              # Standard cleanup
bash .claude/hooks/memory-cleanup.sh --dry-run    # Preview changes
bash .claude/hooks/memory-cleanup.sh --full       # Aggressive cleanup (keep 3)
bash .claude/hooks/memory-cleanup.sh --keep 10    # Custom retention
```

**Use cases for direct shell script**:
1. **After AI cleanup** - Validate AI didn't miss anything
2. **Automated scripts** - CI/CD, cron jobs, automation workflows
3. **Emergency** - AI fails or behaves unexpectedly
4. **Paranoid mode** - Double-check AI work with deterministic script

### Recommended Workflow

**Standard**: `/memory-cleanup` (AI-driven, interactive)
**Validation**: `bash .claude/hooks/memory-cleanup.sh --dry-run` (verify nothing missed)
**Emergency**: `bash .claude/hooks/memory-cleanup.sh` (bypass AI, direct execution)

**Best of both worlds**: AI intelligence + Shell script reliability!

---

**Version**: 1.0
**Part of**: Mini-CoderBrain Memory Management System
