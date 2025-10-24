# Testing Plan for Real Project Development with Mini-CoderBrain v2.2

**Project**: Claude-Chats v1.1 Phase 1
**MCB Version**: v2.2
**Date**: 2025-10-24

---

## ✅ Initial Verification (COMPLETED)

You've already tested these components:

- ✅ **Status Line** - Working with fallbacks
- ✅ **Footer** - Fixed "99999m" bug, showing proper metrics
- ✅ **init-memory-bank** - Auto mode 100%, argument modes fixed
- ✅ **validate-context** - Looking good
- ✅ **map-codebase** - Working fine

**Verdict**: All core systems operational! Ready for phase 1 development.

---

## 🚀 Phase 1 Development Testing Plan

### Pre-Development Setup (5 minutes)

**1. Initialize Memory Bank for Claude-Chats**
```bash
cd /home/boss/claude-chats
/init-memory-bank
```

**Expected**:
- Detects project name, tech stack, features
- Quality score 60-80%
- Creates all 5 memory files

**Verify**:
- [ ] productContext.md has correct project name
- [ ] systemPatterns.md has coding conventions
- [ ] activeContext.md shows "Project initialization complete"

**2. Map Codebase**
```bash
/map-codebase
```

**Expected**:
- Maps 15-20 key files
- Identifies entry points
- Shows file structure

**Verify**:
- [ ] .claude/cache/codebase-map.json created
- [ ] Status line shows "Map: Fresh"

**3. Update Active Context for Phase 1**
```bash
/context-update focus "Claude-Chats v1.1 Phase 1 - [describe phase 1 goal]"
```

**Expected**:
- activeContext.md updated with current focus
- Footer shows new focus (truncated to 50 chars)

---

### During Development (Continuous Testing)

**Every 30-60 minutes**: Check these metrics

**A. Status Line Verification**
```bash
# Just observe status line in Claude Code
```

**Watch for**:
- [ ] Activity ops increasing (shows tool tracking works)
- [ ] Session duration accurate
- [ ] Focus matches your current work
- [ ] Memory health status (Healthy/Monitor/Critical)

**B. Footer Verification**
```bash
# Check at end of every Claude response
```

**Must show**:
- [ ] Activity count (ops)
- [ ] Map status (Fresh/Stale/None)
- [ ] Profile (default)
- [ ] Session duration
- [ ] Current focus (50 chars)
- [ ] Memory health
- [ ] Last sync time
- [ ] Tool usage (top 3 tools)

**Notifications to watch**:
- [ ] Memory cleanup notification (>10 session updates)
- [ ] High activity notification (>=50 ops, >=10min since sync)

**C. Context Awareness Testing**

**Test every 2-3 hours**:
1. Ask Claude: "What project are we working on?"
2. Ask Claude: "What's our current focus?"
3. Ask Claude: "What tech stack are we using?"

**Expected**:
- [ ] Answers correctly without re-reading files
- [ ] Uses context from conversation history
- [ ] No redundant file reads

---

### After Major Milestones (End of Day/Feature)

**Run these commands**:

**1. Update Memory Bank**
```bash
/update-memory-bank "Completed [feature name]"
```

**Expected**:
- [ ] activeContext.md updated with achievement
- [ ] Session summary appended
- [ ] Footer shows recent sync time

**2. Memory Cleanup (if notified)**
```bash
/memory-cleanup
```

**Expected**:
- [ ] Archives old session updates (keep last 5)
- [ ] Reports token savings
- [ ] All data preserved in archive/

**Optional validation**:
```bash
bash .claude/hooks/memory-cleanup.sh --dry-run
```

**Expected**:
- [ ] Shows what would be cleaned (should be minimal after AI cleanup)

**3. Validate Context Quality**
```bash
/validate-context
```

**Expected**:
- [ ] Quality score 70-90%
- [ ] Identifies missing information (if any)
- [ ] Suggests improvements

---

### Edge Cases to Test

**A. Long Session (>2 hours)**

**Watch for**:
- [ ] Memory health goes from Healthy → Monitor → Critical
- [ ] Cleanup notification appears
- [ ] Footer shows increasing session updates count

**Action**: Run /memory-cleanup when notified

**B. High Activity (>50 ops)**

**Watch for**:
- [ ] High activity notification in footer
- [ ] Suggestion to run /memory-sync

**Action**: Run /memory-sync at natural breakpoint

**C. Context Amnesia Test**

**Stop session, restart, then ask**:
- "What were we working on?"
- "What's our tech stack?"
- "What progress did we make?"

**Expected**:
- [ ] Session-start hook loads context
- [ ] Boot status shows last focus
- [ ] Claude remembers project details
- [ ] No "I don't have that information" responses

**D. Map Staleness**

**After 24+ hours**:
- [ ] Status line shows "Map: Stale"
- [ ] Consider: /map-codebase --rebuild

---

### Stress Testing Scenarios

**1. Rapid Development (Many Edits)**

**Do**: Make 20+ file edits in 30 minutes

**Watch**:
- [ ] Activity count increases correctly
- [ ] Tool usage shows Edit(X) in footer
- [ ] No slowdown or errors

**2. Documentation Heavy**

**Do**: Read 10+ large files

**Watch**:
- [ ] Activity count tracks Read operations
- [ ] Tool usage shows Read(X) in footer
- [ ] Context doesn't bloat

**3. Mixed Operations**

**Do**: Mix Read, Write, Edit, Bash, Grep operations

**Watch**:
- [ ] All tools tracked in activity count
- [ ] Footer shows top 3 most-used tools
- [ ] No tool tracking errors in logs

---

### Bug Reporting Checklist

**If you find issues, collect**:

1. **What happened**:
   - [ ] Screenshot of error/issue
   - [ ] Exact command or action that triggered it
   - [ ] Expected vs actual behavior

2. **Context**:
   - [ ] Activity count when issue occurred
   - [ ] Session duration
   - [ ] Recent commands run
   - [ ] Footer status (screenshot)

3. **Logs**:
   ```bash
   # Check error logs
   ls -la logs/*.jsonl | tail -5
   cat logs/stop.jsonl | tail -20
   ```

4. **Environment**:
   - [ ] MCB version (v2.2)
   - [ ] OS (Linux/macOS)
   - [ ] Claude Code version

---

### Success Metrics

**At end of Phase 1, you should observe**:

**Context Quality**:
- [ ] 85%+ quality score in /validate-context
- [ ] Zero "I don't have that information" responses
- [ ] Claude remembers project details across sessions

**Memory Management**:
- [ ] Zero "Prompt too long" errors
- [ ] activeContext.md stays under 200 lines
- [ ] Session updates archived regularly

**Tool Tracking**:
- [ ] Activity count matches actual operations
- [ ] Footer always shows current metrics
- [ ] Status line reflects real-time state

**Notifications**:
- [ ] Cleanup notification appears when needed (>10 updates)
- [ ] High activity notification accurate (>=50 ops)
- [ ] No false notifications

**Performance**:
- [ ] No noticeable slowdown
- [ ] Hooks execute without errors
- [ ] Context loads in <1 second at session start

---

## 🐛 Known Issues to Watch For

**From v2.2 Development**:

1. ✅ **FIXED**: Footer "99999m since sync" → Now shows "Never" or proper time
2. ✅ **FIXED**: init-memory-bank missing src with arguments → Now always runs auto-detection
3. ✅ **FIXED**: CRLF line endings → All converted to LF
4. ✅ **FIXED**: Status line integer expression errors → Whitespace cleaned

**Not Yet Tested in Production**:
- Memory cleanup edge cases with very large archives
- Map codebase with >100 files
- Context quality with incomplete documentation

---

## 📊 Daily Testing Routine

**Morning** (Session Start):
1. Check status line boots correctly
2. Verify footer shows in first response
3. Run /validate-context (check quality score)

**During Work** (Every hour):
1. Observe activity count increasing
2. Check footer metrics match reality
3. Test context awareness (ask Claude about project)

**Evening** (Session End):
1. Run /update-memory-bank with progress notes
2. If notified: /memory-cleanup
3. Verify stop hook updated activeContext.md

---

## 🚀 Phase 1 Development Workflow

**Recommended workflow for building Phase 1**:

**1. Start Session**
```bash
# MCB auto-loads context
# Check boot status
# Verify status line shows "Setup" or your sprint name
```

**2. Define Phase 1 Goal**
```bash
/context-update focus "Phase 1: [specific goal]"
/context-update priority "[top 3 priorities]"
```

**3. Development Loop**
```
Write code → Test → Commit → Update context (every 1-2 hours)
```

**4. Context Updates**
```bash
# When completing tasks
/context-update achievement "Completed [feature]"

# When blocked
/context-update blocker "Issue with [X]"

# When changing focus
/context-update focus "Now working on [Y]"
```

**5. End of Day**
```bash
/update-memory-bank "Phase 1 progress: [summary]"
# If cleanup notified: /memory-cleanup
```

**6. Next Session**
```
MCB loads context → Shows last focus → Continue where you left off
```

---

## 📝 Notes

**What to Test Most**:
- Context persistence across sessions (most critical)
- Footer compliance (should be 85-92%)
- Memory cleanup (prevents bloat)
- Tool tracking accuracy

**What's Already Proven**:
- All core commands work
- Hybrid AI + shell architecture
- Status line fallbacks
- Footer notification detection

**Your Unique Test**:
- Real project development over multiple days
- High-activity sessions
- Context quality in production use

---

**Good luck with Claude-Chats v1.1 Phase 1!** 🚀

Report any issues to v2.2-development branch for immediate fixes.
