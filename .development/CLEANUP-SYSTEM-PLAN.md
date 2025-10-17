# Memory Bank Cleanup System - Implementation Plan

**Version**: 1.0
**Date**: 2025-10-02
**Purpose**: Prevent memory bloat and "Prompt is too long" errors

---

## 🎯 CLEANUP SYSTEM ARCHITECTURE

### Three-Tier Approach

#### Tier 1: Automatic Lightweight Cleanup (Session Start)
**Hook**: `session-start.sh`
**Trigger**: Every session start (after context loaded)
**Target**: Temporary files only
**Risk**: ZERO - cleans after loading

```bash
# Clean tmp/ directory after context loaded
find .claude/tmp -name "*.md" -mmin +60 -delete
find .claude/cache -mtime +7 -delete
```

#### Tier 2: Intelligent Notification System (Stop Hook)
**Hook**: `intelligent-status-notification.sh`
**Trigger**: After every AI response (Stop hook)
**Target**: Detect bloat and notify user
**Risk**: ZERO - notification only

**Detection Logic**:
```bash
# Count session updates in activeContext.md
session_count=$(grep -c "^## 📊 Session Update" "$MB/activeContext.md")

# Count ADR entries in decisionLog.md
adr_count=$(grep -c "^## \[" "$MB/decisionLog.md")

# File size check
active_size=$(wc -l < "$MB/activeContext.md")

# Notify if bloat detected
if [ "$session_count" -gt 10 ] || [ "$active_size" -gt 200 ]; then
  echo "🧹 CLEANUP RECOMMENDED: Run /memory-cleanup to reduce memory bloat"
fi
```

#### Tier 3: Deep Cleanup Command (Manual)
**Command**: `/memory-cleanup`
**Trigger**: User runs command (notified by Tier 2)
**Target**: Archive old session updates, deduplicate ADRs
**Risk**: LOW - preserves data in archives

---

## 📊 BLOAT DETECTION THRESHOLDS

### activeContext.md
- **Warning**: 10+ session updates (70+ lines of session data)
- **Critical**: 200+ total lines
- **Action**: Archive old session updates (keep last 5)

### decisionLog.md
- **Warning**: 20+ ADR entries
- **Critical**: Duplicate ADRs detected
- **Action**: Deduplicate and consolidate

### tmp/ Directory
- **Warning**: 10+ files
- **Critical**: 50+ files or files > 1 hour old
- **Action**: Auto-cleanup on session start

### cache/ Directory
- **Warning**: Files > 7 days old
- **Action**: Auto-cleanup on session start

---

## 🔔 INTELLIGENT NOTIFICATION SYSTEM

### Integration Point
**File**: `intelligent-status-notification.sh`
**Hook**: Stop (runs after every AI response)

### Notification Triggers

#### High Priority (Every Response Check)
```bash
# Check 1: Session update bloat
session_count=$(grep -c "^## 📊 Session Update" "$MB/activeContext.md" 2>/dev/null || echo 0)

if [ "$session_count" -gt 10 ]; then
  echo ""
  echo "🧹 MEMORY CLEANUP RECOMMENDED"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 Detected: $session_count session updates in activeContext.md"
  echo "⚠️  Memory bloat detected - may cause 'Prompt is too long' errors"
  echo ""
  echo "🎯 RECOMMENDED ACTION:"
  echo "   Run: /memory-cleanup"
  echo ""
  echo "✅ This will:"
  echo "   • Archive old session updates (keep last 5)"
  echo "   • Preserve all data in .claude/archive/"
  echo "   • Reduce context tokens by ~60%"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
fi
```

#### Medium Priority (Every 5th Response)
```bash
# Check 2: File size growth
active_lines=$(wc -l < "$MB/activeContext.md" 2>/dev/null || echo 0)

if [ "$active_lines" -gt 200 ] && [ $((activity_count % 5)) -eq 0 ]; then
  echo "📏 Large memory file detected: activeContext.md ($active_lines lines)"
  echo "💡 Consider: /memory-cleanup to optimize"
  echo ""
fi
```

#### Low Priority (Once per session)
```bash
# Check 3: tmp/ directory accumulation
tmp_count=$(find "$ROOT/.claude/tmp" -name "*.md" 2>/dev/null | wc -l)

if [ "$tmp_count" -gt 20 ] && [ ! -f "$CLAUDE_TMP/cleanup-notified" ]; then
  echo "🗑️  Temporary files accumulating ($tmp_count files)"
  echo "ℹ️  Auto-cleanup will run on next session start"
  touch "$CLAUDE_TMP/cleanup-notified"
  echo ""
fi
```

### Notification Strategy
- **Non-intrusive**: Shows after status display, doesn't block workflow
- **Actionable**: Provides exact command to run (`/memory-cleanup`)
- **Informative**: Explains why cleanup needed and what it does
- **Contextual**: Different messages based on bloat severity

---

## 🛠️ IMPLEMENTATION COMPONENTS

### Component A: Cleanup Detection Function
**File**: `intelligent-status-notification.sh`
**Location**: Add after line 75 (after status display)

```bash
# === MEMORY BLOAT DETECTION & NOTIFICATION ===
detect_memory_bloat() {
  local bloat_detected=false
  local session_count adr_count active_lines decision_lines

  # Count session updates
  session_count=$(grep -c "^## 📊 Session Update" "$MB/activeContext.md" 2>/dev/null || echo 0)

  # Count ADR entries
  adr_count=$(grep -c "^## \[" "$MB/decisionLog.md" 2>/dev/null || echo 0)

  # File size checks
  active_lines=$(wc -l < "$MB/activeContext.md" 2>/dev/null || echo 0)
  decision_lines=$(wc -l < "$MB/decisionLog.md" 2>/dev/null || echo 0)

  # High priority: Session update bloat (CRITICAL)
  if [ "$session_count" -gt 10 ]; then
    bloat_detected=true
    echo ""
    echo "🧹 MEMORY CLEANUP RECOMMENDED"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 Session Updates: $session_count entries in activeContext.md"
    echo "⚠️  Memory bloat detected - may cause 'Prompt is too long' errors"
    echo ""
    echo "🎯 RECOMMENDED ACTION: /memory-cleanup"
    echo ""
    echo "✅ Benefits:"
    echo "   • Archive old session updates (keep last 5)"
    echo "   • Preserve all history in .claude/archive/"
    echo "   • Reduce context tokens by ~60%"
    echo "   • Prevent 'Prompt is too long' errors"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
  # Medium priority: File size growth (WARNING)
  elif [ "$active_lines" -gt 200 ]; then
    bloat_detected=true
    echo ""
    echo "📏 MEMORY SIZE NOTICE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📄 activeContext.md: $active_lines lines (recommended: <100)"
    echo "💡 Suggested: /memory-cleanup for optimization"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
  fi

  # Low priority: ADR bloat (INFO)
  if [ "$adr_count" -gt 20 ] && [ ! -f "$CLAUDE_TMP/adr-cleanup-notified" ]; then
    echo "📋 Decision log growing: $adr_count entries"
    echo "💡 Tip: /memory-cleanup can deduplicate similar ADRs"
    touch "$CLAUDE_TMP/adr-cleanup-notified"
    echo ""
  fi
}

# Run bloat detection
detect_memory_bloat
```

### Component B: /memory-cleanup Command
**File**: `.claude/commands/memory-cleanup.md`
**Purpose**: User-triggered deep cleanup

### Component C: Cleanup Script
**File**: `.claude/hooks/memory-cleanup.sh`
**Purpose**: Core cleanup logic (called by command)

### Component D: Archive System
**Directory**: `.claude/archive/`
**Purpose**: Preserve historical data

---

## 📋 IMPLEMENTATION CHECKLIST

- [ ] Add bloat detection to `intelligent-status-notification.sh`
- [ ] Create `/memory-cleanup` command
- [ ] Create `memory-cleanup.sh` hook script
- [ ] Create `.claude/archive/` directory structure
- [ ] Add lightweight cleanup to `session-start.sh`
- [ ] Create `cleanup-config.json` configuration
- [ ] Test notification triggers
- [ ] Test cleanup command
- [ ] Update SRS documentation
- [ ] Apply to both mini and full CoderBrain

---

## ✅ FINAL ARCHITECTURE

```
User Experience Flow:
1. Work on project normally
2. Stop hook detects bloat after response
3. Notification displayed: "🧹 Run /memory-cleanup"
4. User runs: /memory-cleanup
5. Cleanup script archives old data
6. Memory bank optimized (~60% reduction)
7. Continue working without "Prompt is too long" errors

Technical Flow:
Stop Hook → Detect Bloat → Notify User → User Runs Command → Cleanup Script → Archive Data → Optimized Memory
```

**Key Insight**: Since slash commands can't run from hooks, intelligent notification bridges the gap - hooks detect, user executes.

---

**End of Implementation Plan**
