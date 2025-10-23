# Status Line vs Footer: Complementary Design

## Design Philosophy

**Footer** = Session Context (what's happening in the AI conversation)
**Status Line** = Operational State (what's happening in the codebase/project)

---

## Footer (Session Context)

**Location**: End of every AI response
**Update Frequency**: Every user prompt
**Purpose**: Keep AI accountable and user informed about session state

### Data Shown:
```
🧠 MINI-CODER-BRAIN STATUS
📊 Activity: 150 ops | 🗺️ Map: None | ⚡ Context: Active
🎭 Profile: default | ⏱️ 2h 15m | 🎯 Focus: Feature implementation
💾 Memory: Monitor | 🔄 Last sync: 1h ago | 🔧 Tools: Edit(20) Read(15)

💡 🔄 High activity session (150 ops, 60m since sync). Consider: /memory-sync.
```

### Metrics:
1. **Activity Count** - Total operations this session (Read, Write, Edit, Bash)
2. **Map Status** - Codebase map freshness (None/Fresh/Stale)
3. **Context Status** - Memory bank active/inactive
4. **Profile** - Current behavior mode (default/focus/research/implementation)
5. **Session Duration** - Time since session start
6. **Current Focus** - What AI is working on (from activeContext.md)
7. **Memory Health** - Memory bank bloat status (Healthy/Monitor/Needs Cleanup)
8. **Last Sync** - When memory was last synchronized
9. **Tools Used** - Top 3 tools in current turn
10. **Notifications** - Proactive suggestions (cleanup, sync, map rebuild)

### Use Cases:
- Track AI activity (is it working efficiently?)
- Monitor session health (memory cleanup needed?)
- Verify AI follows instructions (focused on right task?)
- Detect high-activity sessions needing sync
- Ensure footer compliance (3-layer enforcement)

---

## Status Line (Operational State)

**Location**: Terminal status bar (bottom of screen)
**Update Frequency**: Real-time (whenever displayed)
**Purpose**: Show codebase/project operational state

### Data Shown:
```
🧠 MCB ✅ │ 📦 main ✎4 │ 🚫 2 blocked │ 🎯 v2.2 Release │ ✅ Tests │ 💾 12 files │ ✓ 8 done │ 🏆 Recent
```

### Metrics:
1. **Brand + Hook Health** - Mini-CoderBrain + hooks working/errors
2. **Git Branch + Changes** - Current branch + uncommitted files count
3. **Active Blockers** - Blocked tasks from activeContext.md
4. **Current Sprint/Milestone** - Active development phase
5. **Test Status** - Test suite pass/fail/pending
6. **Memory Files Count** - Total .md files in memory bank
7. **Completed Tasks** - Done tasks from progress.md
8. **Recent Achievement** - Latest win indicator

### Use Cases:
- Check git state before committing
- Monitor blockers needing attention
- Track sprint progress
- Verify hooks are healthy
- Quick glance at project state
- See completed work count

---

## Key Differences

| Aspect | Footer | Status Line |
|--------|--------|-------------|
| **Focus** | AI session behavior | Codebase operational state |
| **Audience** | User monitoring AI | Developer working on code |
| **Update** | Every AI response | Real-time |
| **Data Type** | Session metrics | Project metrics |
| **Location** | End of response | Terminal status bar |
| **Purpose** | AI accountability | Developer awareness |
| **Overlap** | Memory health, focus | None (fully complementary) |

---

## Why Both Are Needed

### Footer Without Status Line:
❌ No visibility into git state while coding
❌ Can't see blockers at a glance
❌ No real-time project health indicator
❌ Duplicate memory health info

### Status Line Without Footer:
❌ No AI accountability (is it working?)
❌ Can't track session activity count
❌ No proactive notifications (sync, cleanup)
❌ No visibility into tool usage

### Both Together:
✅ Complete visibility (AI + codebase)
✅ No duplication (complementary data)
✅ AI accountability + developer awareness
✅ Session context + operational state

---

## Recommendation: Use Both

**Enable Footer:**
- Already enforced by 3-layer system
- Shows in every AI response automatically
- Tracks session health and AI behavior

**Enable Status Line v2:**
```bash
# In .claude/settings.json
"statusLine": {
  "type": "command",
  "command": "$CLAUDE_PROJECT_DIR/.claude/status_lines/mini-coder-brain-status-v2.sh"
}
```

**Result:**
- Terminal status bar: Operational state (git, blockers, tests, sprint)
- AI response footer: Session context (activity, focus, memory, notifications)
- Zero duplication, maximum insight

---

## Status Line Design Options

### Option 1: Operational State (Recommended)
```
🧠 MCB ✅ │ 📦 main ✎4 │ 🚫 2 blocked │ 🎯 v2.2 │ ✅ Tests │ 💾 12 files
```
- Shows: Git, blockers, sprint, tests, memory files
- Best for: Developers actively coding
- Complements footer perfectly

### Option 2: Session Context (Current - Duplicates Footer)
```
[🧠 MCB] | 📊 150 | ✅ | 🔄 1h | ⏱️ 2h15m | 🎯 Feature work | 📍None | 💡 Sync
```
- Shows: Activity, memory, sync, duration, focus, map
- Problem: Duplicates footer exactly
- Not recommended

### Option 3: Minimal Git Focus
```
🧠 MCB │ main ✎4 │ ⏱️ 2h15m │ 💾 Monitor
```
- Shows: Branch, changes, duration, memory health
- Best for: Minimalists
- Less info but cleaner

---

## Migration Guide

**Step 1**: Keep current status line (shows session context)
**Step 2**: User decides which info is most valuable in status line
**Step 3**: Switch to v2 if operational state preferred
**Step 4**: Footer always shows session context (enforced)

**No Breaking Changes**: Both versions work, user chooses preference.
