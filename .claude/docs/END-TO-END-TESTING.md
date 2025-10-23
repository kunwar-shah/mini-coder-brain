# End-to-End Testing Guide

## Purpose
Verify Mini-CoderBrain works perfectly in a **fresh Claude Code session** with real usage scenarios.

---

## Prerequisites

✅ All hooks strengthened (16/16 complete)
✅ Integration tests passing (28/28 tests)
✅ Production verification passing (36/36 checks)
✅ Git commits up to date

---

## Testing Scenarios

### Scenario 1: Fresh Session Start (Critical)

**Objective**: Verify session-start hook loads context correctly

**Steps**:
1. Close current Claude Code session
2. Open new conversation in Claude Code
3. Type: "Hello, what project are we working on?"

**Expected Results**:
- ✅ Session-start hook displays boot status
- ✅ Claude knows project name (Mini-CoderBrain)
- ✅ Claude knows tech stack (Bash, Markdown)
- ✅ Claude knows current focus (from activeContext)
- ✅ No "SessionStart:compact hook error"
- ✅ Context loaded flag created (`.claude/tmp/context-loaded.flag`)

**Validation**:
```bash
# Check context was loaded
cat .claude/tmp/context-loaded.flag

# Check session start time recorded
cat .claude/tmp/session-start-time

# Check current profile set
cat .claude/tmp/current-profile
```

---

### Scenario 2: User Prompt Hook (Footer Injection)

**Objective**: Verify user-prompt-submit hook injects footer requirements

**Steps**:
1. In same session, ask: "What is 2+2?"
2. Check Claude's response for footer

**Expected Results**:
- ✅ Response includes footer at end
- ✅ Footer shows activity count (1 or 2 ops)
- ✅ Footer shows session duration (<5 minutes)
- ✅ Footer shows current focus
- ✅ Footer shows memory health
- ✅ If conditions met: notification displayed

**Validation**:
```bash
# Check tool tracking logged
today=$(date '+%Y-%m-%d')
cat .claude/memory/conversations/tool-tracking/${today}-tools.log
```

---

### Scenario 3: Tool Usage Tracking

**Objective**: Verify post-tool-use hook tracks operations

**Steps**:
1. Ask Claude: "Read CLAUDE.md and tell me the version"
2. Wait for response
3. Check activity count increases

**Expected Results**:
- ✅ Tool tracking file updated
- ✅ Activity count increases in next footer
- ✅ PostToolUse hook exits 0 (no errors)

**Validation**:
```bash
# Check tool log has entries
today=$(date '+%Y-%m-%d')
wc -l .claude/memory/conversations/tool-tracking/${today}-tools.log
```

---

### Scenario 4: High Activity Session

**Objective**: Verify notification triggers at 50+ ops

**Steps**:
1. Perform 50+ operations (read files, write code, edit multiple files)
2. Check if notification appears in footer

**Expected Results**:
- ✅ After 50+ ops: notification appears
- ✅ Notification: "High activity session (N ops, Xm since sync)"
- ✅ Suggests: "/memory-sync"

**Validation**:
```bash
# Check activity count
today=$(date '+%Y-%m-%d')
ops=$(wc -l < .claude/memory/conversations/tool-tracking/${today}-tools.log)
echo "Current activity: $ops ops"
```

---

### Scenario 5: Memory Cleanup Notification

**Objective**: Verify memory cleanup notification when >10 session updates

**Steps**:
1. Check current session update count
2. If >10: notification should appear
3. Run `/memory-cleanup` if suggested

**Expected Results**:
- ✅ Notification: "Memory cleanup recommended (N session updates)"
- ✅ `/memory-cleanup` command works
- ✅ Old session updates archived
- ✅ activeContext.md reduced in size

**Validation**:
```bash
# Check session update count
grep -c "## Session Update\|## 📊 Session Update" .claude/memory/activeContext.md

# Run cleanup
# (use /memory-cleanup command in Claude Code)

# Verify archive created
ls -la .claude/archive/activeContext/
```

---

### Scenario 6: Session End

**Objective**: Verify stop hook updates memory correctly

**Steps**:
1. End conversation (close Claude Code or switch conversation)
2. Check activeContext.md for session update

**Expected Results**:
- ✅ Stop hook executes without error
- ✅ activeContext.md has new session update
- ✅ Session update shows: activity count, duration, git changes
- ✅ Stop hook exits 0 (no crash)

**Validation**:
```bash
# Check last session update
tail -10 .claude/memory/activeContext.md
```

---

### Scenario 7: PreCompact Hook (Advanced)

**Objective**: Verify pre-compact hook preserves context

**Steps**:
1. Have a long conversation (50+ turns)
2. Wait for Claude Code to trigger compaction
3. Check if context preserved

**Expected Results**:
- ✅ PreCompact hook creates summary
- ✅ Summary saved to `.claude/memory/conversations/compact-summaries/`
- ✅ No "SessionStart:compact hook error"
- ✅ Context continuity maintained

**Validation**:
```bash
# Check compact summaries
ls -la .claude/memory/conversations/compact-summaries/

# View latest summary
latest=$(ls -t .claude/memory/conversations/compact-summaries/*.md | head -1)
cat "$latest"
```

---

### Scenario 8: Multiple Sessions (Context Persistence)

**Objective**: Verify context persists across sessions

**Steps**:
1. Session 1: Ask Claude to remember "favorite color is blue"
2. Close conversation
3. Session 2: Ask "What's my favorite color?"

**Expected Results**:
- ✅ Session 1: activeContext updated with info
- ✅ Session 2: Claude remembers from activeContext
- ✅ Context persistence working across sessions

---

## Automated Verification

Run automated tests before manual testing:

```bash
# 1. Run integration tests
bash .claude/tests/integration/run-all.sh

# 2. Run production verification
bash .claude/tests/production-verification.sh

# 3. Check all hooks exit 0
for hook in .claude/hooks/session-start.sh .claude/hooks/stop.sh \
            .claude/hooks/user-prompt-submit.sh .claude/hooks/post-tool-use.sh \
            .claude/hooks/pre-compact-umb-sync.sh .claude/hooks/session-end.sh; do
  echo "Testing: $hook"
  echo '{}' | bash "$hook" >/dev/null 2>&1 && echo "✅ PASS" || echo "❌ FAIL"
done
```

---

## Success Criteria

### Must Pass (Critical):
- ✅ Session starts without errors
- ✅ Context loads correctly (Claude knows project)
- ✅ Footer appears in every response
- ✅ Tool tracking works (activity count increases)
- ✅ Stop hook updates activeContext
- ✅ No "SessionStart:compact hook error"
- ✅ No "Stop hook error"

### Should Pass (Important):
- ✅ Notifications appear at correct thresholds
- ✅ PreCompact hook preserves context
- ✅ Memory cleanup works when triggered
- ✅ Context persists across sessions

### Nice to Have (Optional):
- ✅ Status line shows correct info
- ✅ Metrics tracking working
- ✅ Git integration working

---

## Failure Scenarios

### If Session Start Fails:
```bash
# Check session-start hook directly
bash .claude/hooks/session-start.sh

# Check for errors
cat logs/session-start.jsonl | tail -5

# Verify hook-patterns library exists
ls -la .claude/hooks/lib/hook-patterns.sh
```

### If Footer Missing:
```bash
# Check user-prompt-submit hook
echo '{"session_id":"test","prompt":"test"}' | bash .claude/hooks/user-prompt-submit.sh

# Check hook registered in settings
grep "user-prompt-submit" .claude/settings.json
```

### If Tools Not Tracked:
```bash
# Check post-tool-use hook
echo '{"tool_name":"Read"}' | bash .claude/hooks/post-tool-use.sh

# Check tool log created
today=$(date '+%Y-%m-%d')
ls -la .claude/memory/conversations/tool-tracking/${today}-tools.log
```

---

## Reporting Results

After completing all scenarios, create a summary:

**Session 1 Results**:
- ✅ Session start: PASS
- ✅ Footer injection: PASS
- ✅ Tool tracking: PASS
- ✅ Notifications: PASS
- ✅ Session end: PASS

**Overall Verdict**:
- 🎉 Production ready: All scenarios passed
- ⚠️  Minor issues: Some scenarios failed (document below)
- ❌ Not ready: Critical failures (fix before deploying)

---

## Next Steps After Testing

### If All Tests Pass:
1. ✅ Tag release v2.2
2. ✅ Deploy to 5-8 waiting projects
3. ✅ Push to GitHub
4. ✅ Announce to community

### If Some Tests Fail:
1. Document failures
2. Fix critical issues
3. Re-run tests
4. Verify fixes in fresh session

### If Critical Failures:
1. Revert to last known good state
2. Debug with production-verification.sh
3. Check logs for errors
4. Run integration tests to isolate issue

---

## Support

**Logs Location**: `logs/*.jsonl`
**Test Scripts**: `.claude/tests/`
**Verification**: `.claude/tests/production-verification.sh`
**Integration Tests**: `.claude/tests/integration/run-all.sh`

**Debug Mode**:
```bash
# Enable debug logging
export MCB_DEBUG=1

# Run hooks manually
bash .claude/hooks/session-start.sh

# Check debug logs
cat .claude/tmp/status-line-debug.log
```
