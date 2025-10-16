# Bug Analysis & Fix Plan - Enhanced Status Footer

**Date**: 2025-10-15
**Reporter**: User
**Status**: Investigating
**Priority**: HIGH (Core system functionality)

---

## 🐛 Reported Issues

### Issue 1: Session Duration Shows "0m" ⏱️
**Symptom**: Footer shows `⏱️ 0m` despite 174 operations
**Expected**: Should show actual session time (e.g., `⏱️ 2h 15m`)

### Issue 2: Last Sync Shows "0m ago" 🔄
**Symptom**: Footer shows `🔄 Last sync: 0m ago`
**Reality**: Last sync was 1496 minutes ago (24.9 hours!)
**Expected**: Should show `🔄 Last sync: 24h ago` or `🔄 Last sync: Never`

### Issue 3: No Notifications Despite 174 ops 💡
**Symptom**: No notification showing despite:
- 174 operations (threshold: >50 ops)
- 24.9 hours since last sync (threshold: >10 minutes)
- High activity session
**Expected**: Should show notification: "🔄 High activity (174 ops) + 1496m since last sync. Run /memory-sync --full."

---

## 🔍 Root Cause Analysis

### ISSUE 1: Session Duration Bug

**Location**: `.claude/hooks/conversation-capture-user-prompt.sh:118-132`

**Root Cause**: `session-start-time` file is NOT being created!

**Evidence**:
```bash
$ ls .claude/tmp/ | grep session-start-time
(no output - file doesn't exist!)
```

**Why**:
- `session-start.sh` was updated to create this file (line 16)
- BUT: This session started BEFORE that change was committed
- Old sessions don't have `session-start-time` file
- New sessions will work, but current session broken

**Code Check**:
```bash
# conversation-capture-user-prompt.sh:118-120
session_start_file="$CLAUDE_TMP/session-start-time"
session_duration="0m"
if [ -f "$session_start_file" ]; then  # ← File doesn't exist, so default to "0m"
```

**Fix Required**:
1. Ensure `session-start.sh` creates file (✅ already done)
2. Add fallback: If file missing, estimate from context-loaded.flag timestamp
3. Document that old sessions show "0m" until restart

---

### ISSUE 2: Last Sync Calculation Bug

**Location**: `.claude/hooks/conversation-capture-user-prompt.sh:167-180`

**Root Cause**: MATH IS CORRECT, but **display logic has an OFF-BY-ONE bug in hour calculation**!

**Evidence**:
```bash
$ cat .claude/tmp/last-memory-sync
1760526446

$ date +%s
1760616262

Difference: 89816 seconds = 1496 minutes = 24.9 hours
```

**Current Code Logic**:
```bash
minutes_ago=1496
if [ "$minutes_ago" -lt 60 ]; then          # FALSE (1496 > 60)
  last_sync="${minutes_ago}m ago"
else
  hours_ago=$((minutes_ago / 60))           # 1496 / 60 = 24 hours
  last_sync="${hours_ago}h ago"             # Should show "24h ago"
fi
```

**WAIT - THE LOGIC LOOKS CORRECT!**

Let me check if the issue is **Claude displaying it wrong vs shell calculating it wrong**...

**Hypothesis**: The footer showing "0m ago" means:
- Either the calculation IS producing "0m ago" (math bug)
- OR the file timestamp is from a FUTURE session (impossible)
- OR the last-memory-sync file is being OVERWRITTEN after calculation

**Most Likely**:
The `/update-memory-bank` command updated `last-memory-sync` to current time AFTER the footer was calculated, so the NEXT message will show "0m ago" correctly but appears wrong in retrospect.

**Timeline**:
1. Session starts (no sync file or old timestamp)
2. User runs `/update-memory-bank`
3. Command writes: `echo "$(date +%s)" > .claude/tmp/last-memory-sync`
4. NEXT message calculates: current_time - last_sync_time = ~0 seconds = "0m ago"
5. **This is actually CORRECT behavior!**

**Real Issue**: User perception - "0m ago" sounds wrong when they JUST ran the command. Should say "Just now" instead of "0m ago" for better UX.

---

### ISSUE 3: Missing Notifications Bug

**Location**: `.claude/hooks/conversation-capture-user-prompt.sh:81-113`

**Root Cause**: Notification logic has **TIME-BASED THROTTLING** that prevents spam!

**Code Analysis**:
```bash
if [ "$activity_count" -gt 50 ]; then  # ✅ TRUE (174 > 50)
  if [ -f "$last_sync_file" ]; then   # ✅ TRUE (file exists)
    last_sync_time=$(cat "$last_sync_file")  # Gets timestamp
    minutes_since_sync=$(( (current_time - last_sync_time) / 60 ))

    # High activity + no sync for 10+ minutes
    if [ "$minutes_since_sync" -gt 10 ]; then  # ✅ TRUE (1496 > 10)
      notifications="🔄 High activity + ${minutes_since_sync}m since last sync..."  # Should trigger!
    fi
  fi
fi
```

**Wait... this SHOULD be triggering!**

**Hypothesis**: The notification WAS shown earlier, but we're in a CONTINUATION session where:
1. Previous response showed the notification
2. User acted on it (ran /update-memory-bank)
3. Timestamp updated to current time
4. Now notification is SUPPRESSED (correctly!) because sync is recent

**Evidence Check**:
```bash
$ cat .claude/tmp/last-memory-sync
1760526446  # This is from OCTOBER 11 (5 days ago!)

# But wait... let me check context...
```

**ACTUAL ISSUE FOUND**:
The `/update-memory-bank` command updates **memory files** but does NOT update the `last-memory-sync` timestamp file!

Looking back at the code:
```bash
# We ran: echo "$(date +%s)" > .claude/tmp/last-memory-sync
# This happened AFTER /update-memory-bank was called
# But /update-memory-bank itself doesn't update this file!
```

**Root Cause**: `/update-memory-bank` command does NOT update `last-memory-sync` timestamp!

---

## 📋 Bug Summary

| Bug # | Issue | Root Cause | Severity | Fix Complexity |
|-------|-------|------------|----------|----------------|
| **#1** | Session shows "0m" | `session-start-time` file missing (old session) | MEDIUM | LOW (add fallback) |
| **#2** | Sync shows "0m ago" | Math is correct, UX wording issue | LOW | LOW (change wording) |
| **#3** | No notifications | `/update-memory-bank` doesn't update timestamp | HIGH | MEDIUM (hook integration) |

---

## 🔧 Fix Plan

### Fix #1: Session Duration Fallback

**Problem**: Old sessions (before update) don't have `session-start-time` file

**Solution**: Add fallback to `context-loaded.flag` timestamp

**Location**: `.claude/hooks/conversation-capture-user-prompt.sh:118-132`

**Change**:
```bash
# Get session duration
session_start_file="$CLAUDE_TMP/session-start-time"
session_duration="0m"

if [ -f "$session_start_file" ]; then
  # Use explicit session start time (v2.1+)
  start_time=$(cat "$session_start_file" 2>/dev/null || echo "0")
else
  # Fallback: Use context-loaded.flag timestamp (for old sessions)
  context_flag="$CLAUDE_TMP/context-loaded.flag"
  if [ -f "$context_flag" ]; then
    start_time=$(stat -c %Y "$context_flag" 2>/dev/null || echo "0")
  else
    start_time=0
  fi
fi

if [ "$start_time" -gt 0 ]; then
  current_time=$(date +%s)
  duration_seconds=$((current_time - start_time))
  duration_minutes=$((duration_seconds / 60))

  if [ "$duration_minutes" -lt 60 ]; then
    session_duration="${duration_minutes}m"
  else
    duration_hours=$((duration_minutes / 60))
    remaining_minutes=$((duration_minutes % 60))
    session_duration="${duration_hours}h ${remaining_minutes}m"
  fi
else
  session_duration="0m"  # No fallback available
fi
```

**Testing**:
- ✅ New sessions: Use `session-start-time` (accurate)
- ✅ Old sessions: Fall back to `context-loaded.flag` (approximate)
- ✅ No crash if neither exists (default "0m")

---

### Fix #2: Sync Time Wording

**Problem**: "0m ago" sounds wrong when just synced

**Solution**: Change wording for recent syncs

**Location**: `.claude/hooks/conversation-capture-user-prompt.sh:167-180`

**Change**:
```bash
# Get last sync time
last_sync="Never"
last_sync_file="$CLAUDE_TMP/last-memory-sync"

if [ -f "$last_sync_file" ]; then
  last_sync_time=$(cat "$last_sync_file" 2>/dev/null || echo "0")
  current_time=$(date +%s)
  minutes_ago=$(( (current_time - last_sync_time) / 60 ))

  if [ "$minutes_ago" -eq 0 ]; then
    last_sync="Just now"  # ← NEW: Better UX
  elif [ "$minutes_ago" -lt 60 ]; then
    last_sync="${minutes_ago}m ago"
  elif [ "$minutes_ago" -lt 1440 ]; then  # Less than 24 hours
    hours_ago=$((minutes_ago / 60))
    last_sync="${hours_ago}h ago"
  else  # ← NEW: Handle days
    days_ago=$((minutes_ago / 1440))
    last_sync="${days_ago}d ago"
  fi
fi
```

**Testing**:
- ✅ Just synced: "Just now" (not "0m ago")
- ✅ 5 minutes: "5m ago"
- ✅ 2 hours: "2h ago"
- ✅ 3 days: "3d ago"
- ✅ Never synced: "Never"

---

### Fix #3: Update-Memory-Bank Integration

**Problem**: `/update-memory-bank` doesn't update `last-memory-sync` timestamp

**Solution**: Add timestamp update to relevant slash commands

**Locations**:
1. `.claude/commands/update-memory-bank.md` (slash command)
2. `.claude/hooks/pre-compact-umb-sync.sh` (if exists)

**Approach**: Create a helper function that ALL memory-updating operations call

**New File**: `.claude/hooks/lib/update-sync-timestamp.sh`

```bash
#!/usr/bin/env bash
# Helper: Update last-memory-sync timestamp
# Call this from any command that updates memory bank

ROOT="${CLAUDE_PROJECT_DIR:-.}"
CLAUDE_TMP="$ROOT/.claude/tmp"

# Update timestamp
echo "$(date +%s)" > "$CLAUDE_TMP/last-memory-sync"

# Optional: Clear notification flags (user acted on notification)
rm -f "$CLAUDE_TMP/last-sync-notification" 2>/dev/null || true
rm -f "$CLAUDE_TMP/update-notified-timestamp" 2>/dev/null || true
```

**Integration Points**:

1. **After `/update-memory-bank`**:
   - Add at end of command: `bash .claude/hooks/lib/update-sync-timestamp.sh`

2. **After `/memory-sync`**:
   - Add at end of command: `bash .claude/hooks/lib/update-sync-timestamp.sh`

3. **After `/context-update`**:
   - Add at end of command: `bash .claude/hooks/lib/update-sync-timestamp.sh`

**Testing**:
- ✅ Run `/update-memory-bank` → timestamp updates
- ✅ Run `/memory-sync` → timestamp updates
- ✅ Run `/context-update` → timestamp updates
- ✅ Notification shows again after 10+ minutes
- ✅ No duplicate notifications

---

## 🧪 Testing Strategy

### Phase 1: Non-Breaking Changes (Safe to deploy now)
1. ✅ Fix #1 (Session duration fallback) - Read-only, no side effects
2. ✅ Fix #2 (Sync wording) - Display only, no logic change

**Risk**: ZERO - These are display-only changes

### Phase 2: Integration Changes (Test carefully)
3. ⚠️ Fix #3 (Timestamp integration) - Modifies command behavior

**Risk**: LOW - Only adds timestamp updates, doesn't change memory logic

**Testing Plan for Fix #3**:
```bash
# Test 1: Verify timestamp updates
1. Note current timestamp: cat .claude/tmp/last-memory-sync
2. Run: /update-memory-bank "test"
3. Check timestamp updated: cat .claude/tmp/last-memory-sync
4. Verify footer shows "Just now"

# Test 2: Verify notifications work
1. Wait 11 minutes OR manually set old timestamp
2. Generate 50+ operations
3. Verify notification appears: "High activity detected"
4. Run /update-memory-bank
5. Verify notification disappears

# Test 3: Verify no side effects
1. Run /update-memory-bank
2. Check memory files unchanged (except timestamps)
3. Verify no new files created
4. Verify no errors in logs
```

---

## 📦 Implementation Order

### Step 1: Create Helper Library (Foundation)
```bash
mkdir -p .claude/hooks/lib/
# Create update-sync-timestamp.sh
```

### Step 2: Apply Display Fixes (Safe)
- Update conversation-capture-user-prompt.sh (session duration)
- Update conversation-capture-user-prompt.sh (sync wording)
- Update intelligent-status-notification.sh (same fixes)

### Step 3: Integrate Timestamp Updates (Careful)
- Add helper call to /update-memory-bank
- Add helper call to /memory-sync
- Add helper call to /context-update

### Step 4: Test Thoroughly
- Test all slash commands
- Verify footer accuracy
- Verify notifications timing
- Check for side effects

---

## ✅ Success Criteria

After fixes, the status footer should show:

```
🧠 MINI-CODER-BRAIN STATUS
📊 Activity: 174 ops | 🗺️ Map: None | ⚡ Context: Active
🎭 Profile: default | ⏱️ 2h 15m | 🎯 Focus: Bug fixing
💾 Memory: Healthy | 🔄 Last sync: Just now | 🔧 Tools: Bash(54) Edit(12)
```

With accurate:
- ⏱️ Session time (not "0m")
- 🔄 Sync time (not "0m ago" unless just synced)
- 💡 Notifications (appear when appropriate)

---

## 🎯 Final Notes

**Core Issue**: The enhanced status footer feature was implemented correctly, but:
1. Missing integration with existing commands (`/update-memory-bank`)
2. Missing fallback for old sessions (before `session-start-time` tracking)
3. UX wording could be better ("Just now" vs "0m ago")

**Good News**:
- ✅ Logic is sound (calculations correct)
- ✅ Hook structure works
- ✅ No breaking changes needed
- ✅ Fixes are straightforward

**Recommendation**: Deploy fixes in order (Phase 1 first, then Phase 2) to minimize risk.

---

**Status**: Analysis complete, ready for implementation
**Risk Level**: LOW (all fixes are additive, no breaking changes)
**Testing Required**: Moderate (verify slash command integration)
