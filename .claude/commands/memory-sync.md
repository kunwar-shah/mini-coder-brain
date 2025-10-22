---
description: Synchronize all memory bank files with current session context
argument-hint: "[--full] [--quick]"
allowed-tools: Read(*), Edit(*), Bash(date:*, echo:*)
---

# Memory Sync — Universal Context Synchronization

**CRITICAL INSTRUCTION**: YOU MUST complete ALL steps below IN EXACT ORDER. DO NOT SKIP any step. ONLY use Read, Edit, and Bash tools as specified.

Synchronizes all `.claude/memory/` files with current session state, ensuring perfect context preservation across sessions.

## Usage

```bash
# Full synchronization (recommended after significant work)
/memory-sync --full

# Quick sync (active context only)
/memory-sync --quick

# Default: Smart sync based on session activity
/memory-sync
```

---

## EXECUTION STEPS - MANDATORY

## STEP 1: Parse Arguments - MANDATORY

**ACTION**: Detect sync mode

**DETECT** (YOU MUST check for these EXACT strings):
- IF message contains `--full` → Set MODE="full" (sync all memory files)
- IF message contains `--quick` → Set MODE="quick" (activeContext only)
- IF neither → Set MODE="smart" (analyze session, decide what to sync)

**OUTPUT**: Tell user which mode activated:
- "Full synchronization mode (--full)"
- "Quick sync mode (--quick)"
- "Smart sync mode (analyzing session activity)"

---

## STEP 2: Record Sync Timestamp - MANDATORY

**YOU MUST USE Bash TOOL FIRST** before any other step

**EXACT COMMAND** (run this immediately):
```bash
date +%s > .claude/tmp/last-memory-sync
```

**WHY THIS IS CRITICAL**:
- Intelligent status notification system reads this file
- Footer shows "Last sync: Xm ago" based on this timestamp
- MUST update BEFORE syncing files (not after)

**VALIDATION**:
- ✅ Ran `date +%s > .claude/tmp/last-memory-sync` command
- ✅ Command executed successfully
- ✅ Did this BEFORE reading/editing any memory files

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT skip this step
- ❌ DO NOT do this AFTER syncing (must be BEFORE)
- ❌ DO NOT use different timestamp format

---

## STEP 3: Analyze Session Activity - MANDATORY

**YOU MUST ANALYZE**:
1. **Operations Count**: Count Read, Edit, Write, Bash operations THIS session
2. **Files Modified**: Which files were changed (check conversation history)
3. **Technical Decisions**: Were architecture/tech choices made?
4. **Progress Changes**: Were tasks completed or started?
5. **New Blockers**: Were blockers discovered?
6. **Pattern Changes**: Were new patterns adopted?

**OUTPUT** (show user the analysis):
```
📊 Session Analysis:
   - Operations: [count] (Read: X, Edit: Y, Bash: Z)
   - Files modified: [count] files
   - Technical decisions: [Y/N]
   - Tasks completed: [count]
   - New blockers: [count]
   - New patterns: [Y/N]

Sync mode: [full/quick/smart]
Will update: [list of files to sync]
```

**DETERMINE WHAT TO SYNC**:
- **IF MODE="quick"** → ONLY activeContext.md
- **IF MODE="full"** → ALL applicable memory files
- **IF MODE="smart"** → Decide based on session activity:
  - IF 50+ operations OR technical decisions → sync like --full
  - IF 10-49 operations → sync activeContext + progress
  - IF <10 operations → sync activeContext only

---

## STEP 4: Update activeContext.md - MANDATORY

**YOU MUST USE Edit TOOL** to update activeContext

**REQUIRED UPDATES**:

### Append Session Update:
**FORMAT**:
```markdown
---

## Session Update — YYYY-MM-DD HH:MM:SS UTC

**Session Duration**: [duration]
**Operations**: [count]
**Files Modified**: [list]

### Achievements This Session:
- [Achievement 1]
- [Achievement 2]

### Focus Changes:
- [What changed in focus, if anything]

### New Blockers:
- [Any new blockers discovered]

### Next Steps:
- [What to do next session]
```

**VALIDATION**:
- ✅ Used Edit tool (not Write)
- ✅ Appended session update (didn't overwrite)
- ✅ UTC timestamp in format: YYYY-MM-DD HH:MM:SS UTC
- ✅ All sections present (Achievements, Focus Changes, Blockers, Next Steps)

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT use Write tool (will erase all history)
- ❌ DO NOT skip timestamp
- ❌ DO NOT remove old session updates
- ❌ DO NOT invent fake achievements

**IF MODE="quick"** → Skip to STEP 9 (show summary)

---

## STEP 5: Update progress.md (if MODE="full" or MODE="smart" with >10 ops) - CONDITIONAL

**CONDITION**: IF MODE="full" OR (MODE="smart" AND operations > 10)

**YOU MUST USE Edit TOOL** to update progress

**ACTIONS**:
1. **Move Completed Tasks**: Tasks in "IN PROGRESS" that are now done → move to "COMPLETED"
2. **Add New Tasks**: Tasks started this session → add to "IN PROGRESS"
3. **Update Sprint Status**: IF sprint milestone reached

**FORMAT**:
```markdown
### ✅ COMPLETED (This Sprint)
- **YYYY-MM-DD** ✅ [Task description]

### 🔄 IN PROGRESS (Today)
- **YYYY-MM-DD** 🔄 [Task description]
```

**VALIDATION**:
- ✅ Used Edit tool
- ✅ Added timestamps to all entries
- ✅ Preserved existing content
- ✅ Only updated what actually changed

**IF CONDITION FALSE** → Skip to STEP 6

---

## STEP 6: Update decisionLog.md (if MODE="full" AND decisions exist) - CONDITIONAL

**CONDITION**: IF MODE="full" AND technical decisions were made

**YOU MUST USE Edit TOOL** to append decisions

**EXACT FORMAT**:
```markdown
[YYYY-MM-DDTHH:MM:SSZ] ADR-YYYYMMDD-NN — [Decision Title]

**Decision**: [What was decided]
**Rationale**: [Why this decision]
**Impact**: [Expected consequences]
**Implementation**: [How to implement]
**Follow-ups**: [Next steps]
```

**VALIDATION**:
- ✅ UTC timestamp in ISO 8601 format
- ✅ All 5 sections present
- ✅ ADR number is unique (increment from last)

**IF NO DECISIONS** → Skip to STEP 7

---

## STEP 7: Update systemPatterns.md (if new patterns discovered) - CONDITIONAL

**CONDITION**: IF new coding patterns or conventions emerged

**YOU MUST USE Edit TOOL** to append patterns

**VALIDATION**:
- ✅ Pattern is genuinely new (not already in file)
- ✅ Pattern has clear description and example
- ✅ Used Edit tool (not Write)

**IF NO PATTERNS** → Skip to STEP 8

---

## STEP 8: Update productContext.md (if scope changed) - CONDITIONAL

**CONDITION**: IF project scope/features/architecture changed significantly

**YOU MUST USE Edit TOOL** to update relevant sections

**VALIDATION**:
- ✅ Only update if genuinely needed (rare)
- ✅ Preserve existing structure
- ✅ Used Edit tool

---

## STEP 9: Show Summary - MANDATORY

**YOU MUST OUTPUT** in this EXACT format:

```
🔄 Memory Sync Complete!

📊 Session Activity:
   - Operations: [count]
   - Duration: [time]
   - Sync mode: [mode]

📝 Memory Bank Updates:
✅ activeContext.md - Updated with session summary
[if updated] ✅ progress.md - [changes made]
[if updated] ✅ decisionLog.md - [N decisions recorded]
[if updated] ✅ systemPatterns.md - [N patterns added]
[if updated] ✅ productContext.md - [changes made]

💾 Sync timestamp recorded: YYYY-MM-DD HH:MM:SS UTC

📊 Summary:
   - Files synchronized: [N]
   - Session updates recorded: [N]
   - Total operations: [count]

🎯 Next session will load with complete context awareness!
```

---

## CRITICAL VALIDATIONS - MANDATORY

**BEFORE CLAIMING SUCCESS**, verify:
- ✅ Completed STEP 2 (timestamp) BEFORE all other steps
- ✅ Used Edit tool for ALL modifications (NEVER Write)
- ✅ All timestamps in correct format (UTC)
- ✅ Preserved all existing content (append-only)
- ✅ Updated ONLY files with actual changes
- ✅ Session summary appended to activeContext.md

**IF ANY VALIDATION FAILS** → Report: "❌ Failed at STEP [X]: [reason]"

---

## ABSOLUTELY FORBIDDEN

- ❌ DO NOT use Write tool (will erase history - use Edit)
- ❌ DO NOT skip STEP 2 (timestamp must be set FIRST)
- ❌ DO NOT remove old content from memory files
- ❌ DO NOT invent fake progress or decisions
- ❌ DO NOT update productContext unless scope truly changed
- ❌ DO NOT claim success if validations fail

---

## Purpose

The `/memory-sync` command provides intelligent synchronization of your memory bank:
- Updates `activeContext.md` with current focus and progress
- Appends session summary to `progress.md`
- Records technical decisions in `decisionLog.md`
- Refreshes `productContext.md` if project scope changed
- Updates `systemPatterns.md` if new patterns emerged

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
