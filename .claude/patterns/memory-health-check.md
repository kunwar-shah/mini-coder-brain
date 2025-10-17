# Memory Health Check Pattern

**Purpose**: Proactive memory maintenance to prevent token bloat and "Prompt too long" errors

**Token Cost**: 0 (read on-demand only)

---

## 🎯 Problem Statement

**Issue**: Over time, activeContext.md accumulates session update entries, causing:
- Increased token usage at session start (30-50% bloat)
- "Prompt too long" errors after multiple sessions
- Frequent context compactions
- Degraded conversation continuity

**Root Cause**:
- Hooks append session updates to activeContext.md
- Session-start loads entire activeContext.md
- Without cleanup, this compounds exponentially

---

## 🧠 Memory Health Levels

### ✅ Healthy (0-5 session updates)
**Status**: Optimal
**Action**: None needed
**Token Impact**: Minimal

### 💡 Monitor (6-8 session updates)
**Status**: Slightly elevated
**Action**: Consider cleanup after next major milestone
**Token Impact**: +15-20% at session start

### ⚠️ Needs Cleanup (9-12 session updates)
**Status**: Approaching bloat
**Action**: Run /memory-cleanup recommended
**Token Impact**: +30-40% at session start

### 🚨 Critical (13+ session updates)
**Status**: Token bloat
**Action**: Run /memory-cleanup before continuing
**Token Impact**: +50%+ at session start, risk of "Prompt too long"

---

## 📋 When to Check Memory Health

### 1. Session Start (Automatic)
**Trigger**: session-start hook displays status
**Action**:
- If 9+ updates → Show "💡 Memory cleanup recommended"
- If 13+ updates → Show "⚠️ Memory bloat detected"
- AI acknowledges and suggests /memory-cleanup

**Example**:
```
🧠 [MINI-CODERBRAIN: ACTIVE] - MyProject
🎯 Focus: API development
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default
⚡ Ready for development | Session: sessionstart-1234567890

⚠️  Memory bloat detected (13 session updates). Run /memory-cleanup before continuing.
```

**AI Response**:
```
[MINI-CODER-BRAIN: ACTIVE]

I see memory bloat detected (13 session updates). Before we continue, I recommend running:

/memory-cleanup

This will:
✅ Archive old session updates (keep last 5)
✅ Reduce token usage by ~40%
✅ Prevent "Prompt too long" errors
✅ Maintain conversation continuity

Would you like me to explain what /memory-cleanup does, or should we run it now?
```

---

### 2. During High Activity Sessions
**Trigger**: 80+ operations in one session
**Action**: Suggest /memory-sync or /memory-cleanup at end of session

**AI Behavior**:
```
After completing major feature implementation:

"Great work! This was a high-activity session (127 operations).

Before ending today:
• /memory-sync → Preserve context for next session
• /memory-cleanup → Archive old session data if prompted

This keeps Mini-CoderBrain running smoothly."
```

---

### 3. After Major Milestones
**Trigger**: Feature completion, sprint end, release
**Action**: Suggest /memory-sync + /memory-cleanup combo

**Example**:
```
"🎉 Feature completed! Since this was a major milestone:

1. /memory-sync → Save all decisions and progress
2. /memory-cleanup → Archive old session data
3. Ready for next sprint with clean context

Want me to explain the difference between these commands?"
```

---

## 🛠️ How Memory Cleanup Works

### What /memory-cleanup Does

**Archives**:
- Old session updates (keeps last 5 by default)
- Old tool tracking logs (keeps last 7 days)
- Temporary notification flags (> 1 day old)

**Preserves**:
- Current focus, achievements, priorities, blockers
- ALL progress and decisions (moved to archive)
- Recent session history

**Result**:
- 40-60% token reduction at session start
- All data preserved in `.claude/archive/`
- Zero data loss

### What Gets Archived

**Before Cleanup** (activeContext.md):
```markdown
## Session Updates

## 📊 Session Update [2025-10-01T10:00:00+00:00]
Activity: 45 ops | Context: Feature development

## 📊 Session Update [2025-10-02T14:30:00+00:00]
Activity: 67 ops | Context: Bug fixes

## 📊 Session Update [2025-10-03T09:15:00+00:00]
Activity: 89 ops | Context: Refactoring

... [10 more old entries]

## 📊 Session Update [2025-10-15T11:00:00+00:00]
Activity: 34 ops | Context: API development  ← Recent (keep)

## 📊 Session Update [2025-10-16T08:45:00+00:00]
Activity: 52 ops | Context: Testing  ← Recent (keep)
```

**After Cleanup**:
```markdown
## Session Updates

## 📊 Session Update [2025-10-15T11:00:00+00:00]
Activity: 34 ops | Context: API development

## 📊 Session Update [2025-10-16T08:45:00+00:00]
Activity: 52 ops | Context: Testing
```

**Archive Location**:
`.claude/archive/session-history-2025-10.md` (all 10 old entries preserved)

---

## 🎯 AI Behavioral Guidelines

### ✅ DO: Proactive Memory Awareness

**At Session Start**:
```
✅ See warning → Acknowledge it
✅ Explain why cleanup helps
✅ Suggest action but don't force
✅ Offer to explain commands
```

**During Session**:
```
✅ Notice high activity (80+ ops)
✅ Suggest cleanup at natural break
✅ After completing major task
✅ Before ending long session
```

**Best Practice**:
```
"I notice we've had 13 session updates accumulated. Running /memory-cleanup will:
• Reduce token usage by 40%
• Prevent 'Prompt too long' errors
• Keep context fresh and relevant

Want to run it now, or after we finish this task?"
```

---

### ❌ DON'T: Annoying Behavior

**Don't Spam**:
```
❌ Suggesting cleanup after EVERY operation
❌ Repeating ignored suggestions
❌ Forcing user to cleanup
❌ Interrupting mid-task
```

**Don't Over-Explain**:
```
❌ 5 paragraphs about memory management
❌ Technical deep dives unless asked
❌ Repeating same explanation
```

**Don't Alarm**:
```
❌ "CRITICAL ERROR: Memory bloat!"
❌ "You MUST cleanup NOW or data loss!"
❌ Overly dramatic warnings
```

---

## 📊 Memory Health Monitoring

### Check Memory Health
```bash
# Count session updates
grep -c "^## 📊 Session" .claude/memory/activeContext.md

# 0-5:  ✅ Healthy
# 6-8:  💡 Monitor
# 9-12: ⚠️  Needs cleanup
# 13+:  🚨 Critical
```

### View Memory Size
```bash
# Check file sizes
du -h .claude/memory/*.md

# Target sizes:
# productContext.md:  < 5KB
# activeContext.md:   < 10KB (without cleanup)
#                     < 5KB (after cleanup)
# systemPatterns.md:  < 10KB
# progress.md:        < 15KB
# decisionLog.md:     Unlimited (append-only)
```

---

## 🔄 Memory Cleanup Schedule

### Recommended Schedule

**Weekly** (Active Development):
- Run /memory-cleanup every Friday
- Keeps last 5 session updates
- Archives week's history

**Bi-Weekly** (Moderate Development):
- Run /memory-cleanup every other Friday
- Keeps last 7 session updates
- Archives 2 weeks' history

**Monthly** (Light Development):
- Run /memory-cleanup end of month
- Review and condense activeContext manually
- Summarize progress.md

**On-Demand** (High Activity):
- After major features (100+ ops)
- Before important milestones
- When prompted by session-start hook

---

## 🎓 User Education

### When User Asks "What does /memory-cleanup do?"

**Concise Answer**:
```
/memory-cleanup archives old session data to prevent token bloat.

What it does:
✅ Archives old session updates (keeps last 5)
✅ Cleans up temporary files
✅ Preserves ALL data in .claude/archive/
✅ Reduces token usage by 40-60%

Result: Faster session starts, longer conversations, no "Prompt too long" errors.

Safe to run anytime - no data loss!
```

### When User Asks "How often should I run it?"

**Recommendation**:
```
Run /memory-cleanup when:
• Session-start shows "💡 Memory cleanup recommended"
• After high-activity sessions (80+ ops)
• Weekly if developing actively
• Before important milestones

You'll get reminders when needed, so no need to track manually!
```

### When User Asks "Will I lose data?"

**Reassurance**:
```
No data loss! Everything is preserved:

✅ Current work → Stays in activeContext.md
✅ Old sessions → Archived to .claude/archive/
✅ Progress → Stays in progress.md
✅ Decisions → Stays in decisionLog.md

Archive files:
.claude/archive/session-history-YYYY-MM.md

You can read archived data anytime with the Read tool.
```

---

## 🔗 Related Patterns

**Also Read**:
- @.claude/patterns/anti-patterns.md → "Loading full session history" anti-pattern
- @.claude/patterns/proactive-behavior.md → When to suggest commands
- @.claude/rules/token-efficiency.md → Token optimization strategies

---

## 📈 Success Metrics

**Good Memory Health**:
- ✅ Session start < 2500 tokens
- ✅ Active sessions don't hit "Prompt too long"
- ✅ Minimal context compactions
- ✅ User runs /memory-cleanup proactively

**Poor Memory Health**:
- ❌ Session start > 3500 tokens
- ❌ Frequent "Prompt too long" errors
- ❌ Multiple compactions per session
- ❌ User never runs /memory-cleanup

---

## 💡 Pro Tips

### For AI
1. **Acknowledge warnings** at session start
2. **Suggest at natural breaks**, not mid-task
3. **Explain benefits** concisely, not technically
4. **Don't repeat** ignored suggestions
5. **Celebrate** when user runs cleanup

### For Users
1. **Run cleanup weekly** if developing actively
2. **Don't ignore warnings** from session-start
3. **After major sessions** (80+ ops), sync + cleanup
4. **Before releases**, clean up for fresh start
5. **Archive is safe** - data never lost

---

**Key Principle**: Proactive memory maintenance prevents problems before they occur. Small cleanups regularly > large cleanup in crisis.

**Remember**: Memory health is like code quality - maintain it continuously, not just when it breaks! 🧠✨
