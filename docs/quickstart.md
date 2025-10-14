---
layout: page
title: Quick Start
subtitle: Get productive with Mini-CoderBrain v2.0 in 2 minutes
---

# Quick Start Guide (v2.0)

Get up and running with Mini-CoderBrain v2.0 in 2 minutes with intelligent setup!

---

## 🚀 Step 1: Install (30 seconds)

```bash
git clone https://github.com/kunwar-shah/mini-coder-brain.git
cd mini-coder-brain
chmod +x install.sh
./install.sh /path/to/your/project
```

**Installation complete!** But there's one more critical step...

---

## 🔴 Step 2: Initialize Context (MANDATORY)

**⚠️ CRITICAL**: This step is **REQUIRED** for mini-coder-brain to work!

Open your project in Claude Code and run **ONE** of these:

### Option A: With Documentation (Best!)
```
/init-memory-bank --docs-path ./docs
```

Use this if you have:
- SRS.md, ARCHITECTURE.md, API.md
- Any technical documentation
- Requirements documents

**Result**: 90-95% context quality ⭐

### Option B: Auto-Detection
```
/init-memory-bank
```

Use this if you have:
- Existing code (package.json, README.md)
- Git history
- No formal documentation

**Result**: 75-85% context quality ✅

### Option C: Interactive Wizard
```
/init-memory-bank
```

Use this if you have:
- Brand new empty project
- Just starting

**Result**: 60-70% context quality (minimum) ⚠️

---

## ✅ Step 3: Verify Setup

Check your context quality:

```
/validate-context
```

**Expected output**:
```
📊 Context Quality: 85% (Recommended) ✅

✅ Project name: your-project
✅ Tech stack: 5 technologies
✅ Core features: 4 features
✅ Architecture: Defined

✅ Ready for development!
```

**If score < 60%**: Run `/validate-context --fix` for help.

---

## 🎯 Step 4: Start Developing!

Now you can just talk to Claude naturally:

```
"Add JWT authentication to the user login endpoint"
```

Claude will:
- ✅ Know your project structure automatically
- ✅ Follow your coding patterns
- ✅ Use your exact tech stack
- ✅ Remember all decisions
- ✅ Track progress across sessions
- ✅ **Never ask "what framework are you using?" again!**

---

## 🧠 Understanding the Memory Bank

Mini-CoderBrain maintains 5 key memory files:

### 1. **productContext.md** - Project Overview
What: Project name, tech stack, architecture, features
When to edit: Once during setup, update when scope changes

### 2. **activeContext.md** - Current Focus
What: What you're working on RIGHT NOW
When to edit: Updated automatically by hooks, or use `/context-update`

### 3. **progress.md** - Sprint Tracking
What: Completed/in-progress/upcoming tasks
When to edit: Updated automatically, or manually for milestones

### 4. **decisionLog.md** - Technical Decisions
What: ADRs (Architecture Decision Records) with timestamps
When to edit: Automatically appended when making technical decisions

### 5. **systemPatterns.md** - Coding Standards
What: Your coding patterns, conventions, testing approach
When to edit: Once during setup, update when standards change

---

## 🛠️ Essential Commands

### Memory Management

```bash
/memory-sync              # Full memory synchronization
/context-update          # Quick real-time context update
/umb "note"             # Fast manual sync with note
/memory-cleanup         # Archive old data, prevent bloat
```

### Codebase Mapping

```bash
/map-codebase           # Load existing map (instant)
/map-codebase --rebuild # Rebuild from scratch (~30s)
/map-codebase --recent  # Focus on recent changes only
```

---

## 💡 Common Workflows

### Starting a New Feature

1. **Set your focus**:
   ```
   /context-update focus "Building user profile page"
   ```

2. **Start coding**:
   ```
   "Create a user profile component with avatar, bio, and social links"
   ```

3. Claude automatically:
   - Uses your project structure
   - Follows your coding patterns
   - Tracks this work in activeContext
   - Updates progress

### Making Technical Decisions

Just discuss with Claude naturally:

```
"Should we use Redux or Context API for state management?"
```

Claude will:
- Consider your tech stack
- Reference past decisions
- Provide recommendations
- **Automatically log the decision** to decisionLog.md

### Ending a Session

Just close Claude Code. The stop hook automatically:
- ✅ Saves session summary to activeContext.md
- ✅ Tracks development operations
- ✅ Suggests memory cleanup if needed
- ✅ Preserves all context for next session

---

## 🎯 Best Practices

### DO ✅

- **Use `/context-update`** to keep Claude informed of your focus
- **Run `/map-codebase`** once for instant file access
- **Let hooks work automatically** - they track everything
- **Trust the memory bank** - Claude reads it at session start
- **Run `/memory-cleanup`** when notified (prevents bloat)

### DON'T ❌

- **Don't manually edit memory files** during development (hooks do it)
- **Don't skip `/memory-cleanup`** notifications (causes "Prompt too long")
- **Don't delete `.claude/tmp/`** while Claude is running
- **Don't commit `.claude/memory/*.md`** files (they're gitignored)

---

## 📊 Status Footer

Every Claude response ends with:

```
🧠 MINI-CODER-BRAIN STATUS
📊 Activity: X ops | 🗺️ Map: Status | ⚡ Context: Active
```

This shows:
- **Activity**: Operations performed this session
- **Map**: Codebase map status (None/Loaded/Available)
- **Context**: Context awareness status

---

## 🔄 Session Workflow

### Session Start
1. Hooks load context from `.claude/memory/`
2. Project structure detected automatically
3. Boot status displays current focus
4. **You're ready to code** with full context

### During Development
1. Work naturally with Claude
2. Context tracks automatically
3. Progress updated in real-time
4. Decisions logged automatically

### Session End
1. Stop hook saves session summary
2. Context preserved for next session
3. Smart suggestions if cleanup needed
4. **Perfect continuity next time**

---

## 🆘 Quick Troubleshooting

### "Claude doesn't remember my project"
**Solution**: Check that `CLAUDE.md` and `.claude/memory/` files exist

### "Prompt is too long" error
**Solution**: Run `/memory-cleanup` to archive old data

### "Commands don't work"
**Solution**: Verify hooks are executable: `chmod +x .claude/hooks/*.sh`

---

## 🎓 Advanced Features

### Codebase Mapping
Revolutionary instant file access:
- One-time rebuild: `30 seconds`
- Future loads: `instant`
- Surgical precision: Claude knows exact file locations

### Real-Time Context Updates
Track focus/blockers/achievements:
```
/context-update achievement "Completed authentication system"
/context-update blocker "API rate limiting issue"
```

### Memory Cleanup System
Prevents "Prompt too long" errors:
- Automatic suggestions when needed
- Archives old data (keeps last 5 session updates)
- No data loss - everything preserved in `.claude/archive/`

---

## 📚 Next Steps

Now that you're set up:

1. **Customize your memory bank** - Edit productContext.md and systemPatterns.md
2. **Map your codebase** - Run `/map-codebase --rebuild` once
3. **Start developing** - Claude has perfect context awareness!
4. **Explore features** - Check out the [Features Guide]({{ '/features' | relative_url }})
5. **Learn commands** - See [Commands Reference]({{ '/commands' | relative_url }})

---

## 💬 Example Conversation

**You**: "Add user authentication with JWT tokens"

**Claude** (with Mini-CoderBrain):
- ✅ Checks productContext.md → sees you're using Express + MongoDB
- ✅ Checks systemPatterns.md → sees you use bcrypt for passwords
- ✅ Checks project-structure.json → finds `src/routes/auth.js`
- ✅ Creates authentication following YOUR patterns
- ✅ Updates activeContext with current work
- ✅ No questions needed - just starts coding!

**Without Mini-CoderBrain**:
- ❌ "What framework are you using?"
- ❌ "Where should I create the auth routes?"
- ❌ "What's your preferred password hashing library?"
- ❌ Loses context next session
- ❌ Repeats questions every time

---

<div style="text-align: center; margin-top: 50px;">
  <h3>Ready to explore all features?</h3>
  <a class="btn btn-success" href="{{ '/features' | relative_url }}">View All Features →</a>
</div>
