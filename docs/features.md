---
layout: page
title: Features
subtitle: Everything Mini-CoderBrain can do for you
---

# Features Overview

Discover all the powerful features that make Mini-CoderBrain the ultimate context awareness system for Claude Code.

---

## 🎯 Core Features

### 1. Perfect Context Awareness

**Problem**: Claude forgets your project structure, tech stack, and decisions between conversations.

**Solution**: Mini-CoderBrain loads complete project context once per session and maintains it naturally.

**Benefits**:
- ✅ Zero repeated explanations
- ✅ Claude knows your tech stack
- ✅ Remembers architectural decisions
- ✅ Understands your coding patterns
- ✅ Perfect continuity across sessions

**How it works**:
```
Session Start → Loads 5 memory files → Context persists in conversation history
```

---

### 2. Real-Time Activity Tracking

**Feature**: Live operation counter that shows exactly what's happening.

**Display**:
```
📊 Activity: 42 ops | 🗺️ Map: Loaded | ⚡ Context: Active
```

**Tracks**:
- Read operations
- Write operations
- Edit operations
- Grep searches
- Glob searches
- Bash commands
- File operations

**Benefits**:
- See exactly what Claude is doing
- Understand development velocity
- Track productivity metrics
- Identify patterns in work

---

### 3. Intelligent Notifications

**Feature**: Proactive suggestions based on session activity and memory state.

**Notifications**:
- 🧹 **Memory Cleanup**: "Consider running /memory-cleanup (activeContext.md is 215 lines)"
- 🗺️ **Map Rebuild**: "15 new files detected. Run /map-codebase --rebuild"
- 💾 **Memory Sync**: "High activity session (47 ops). Consider /memory-sync"
- 📊 **Progress Update**: "Completed 5 tasks. Update progress.md?"

**Smart Triggers**:
- File count thresholds
- Memory file size limits
- Operation count tracking
- Session duration

---

### 4. Zero Context Duplication

**Problem**: Old versions injected context repeatedly, causing "Prompt is too long" errors.

**Solution**: Context loaded once at session start, persists naturally in conversation history.

**Impact**:
- **79.9% token reduction** vs. previous versions
- **25% longer conversations** before limits
- **Zero duplication** - context loaded once
- **Perfect continuity** - full awareness maintained

**Technical**:
```
Turn 1: Load 782 lines of context → Enter conversation history
Turn 2+: Context already available → No re-injection needed
Result: Natural conversation, perfect awareness, minimal tokens
```

---

### 5. Automatic Memory Management

**Feature**: Prevents "Prompt is too long" errors through intelligent cleanup.

**How it works**:
1. Session activity tracking counts operations
2. Smart notifications suggest cleanup when needed
3. `/memory-cleanup` archives old data
4. Keeps last 5 session updates, archives rest
5. No data loss - everything preserved in `.claude/archive/`

**Benefits**:
- ✅ Never hit "Prompt is too long" again
- ✅ ~60% context token reduction
- ✅ All history preserved in archive
- ✅ Automatic suggestions when needed

---

### 6. Codebase Mapping System

**Feature**: Revolutionary instant file access system.

**Usage**:
```bash
/map-codebase --rebuild    # One-time setup (~30 seconds)
/map-codebase              # Instant loading (future sessions)
```

**What it does**:
- Scans entire codebase
- Creates semantic file map
- Enables instant file location
- Surgical precision development

**Benefits**:
- Claude knows EXACT file locations
- No more "Where is the User model?" questions
- Instant file access
- Perfect for large codebases

**Example**:
```
User: "Update the User model"
Claude: *Checks codebase-map.json → finds src/models/User.ts*
Claude: *Opens file and makes changes, no questions asked*
```

---

### 7. Mandatory Pre-Response Protocol

**Feature**: Claude MUST check context before responding.

**Protocol**:
```
Before ANY response:
1. ✅ CHECK productContext.md → Project info
2. ✅ CHECK systemPatterns.md → Coding patterns
3. ✅ CHECK activeContext.md → Current focus
4. ✅ CHECK project-structure.json → File locations
5. ✅ CHECK codebase-map.json → Specific files

ONLY AFTER checking → Respond to user
```

**Banned Questions**:
- ❌ "What framework are you using?" → CHECK productContext.md
- ❌ "Where is the User model?" → CHECK codebase-map.json
- ❌ "What's your coding style?" → CHECK systemPatterns.md
- ❌ "Should I create tests?" → CHECK systemPatterns.md

**Result**: Claude uses context automatically, no unnecessary questions!

---

### 8. Cross-Session Memory

**Feature**: Perfect continuity between sessions.

**How it works**:
```
Session End:
- Stop hook saves session summary
- Updates activeContext.md
- Preserves progress and decisions

Session Start:
- Session-start hook loads context
- Picks up exactly where you left off
- Full awareness of past work
```

**Benefits**:
- ✅ Resume work instantly
- ✅ No context loss between sessions
- ✅ Remember all decisions
- ✅ Track progress over days/weeks

---

### 9. Universal Project Detection

**Feature**: Automatically detects your project type and structure.

**Detects**:
- Frontend paths (src/, app/, components/)
- Backend paths (server/, api/, routes/)
- Database paths (prisma/, migrations/, models/)
- Test paths (__tests__/, tests/, spec/)
- Config files (package.json, requirements.txt, Cargo.toml)

**Supported**:
- JavaScript/TypeScript (React, Next.js, Node, etc.)
- Python (Django, Flask, FastAPI, etc.)
- Rust, Go, Java, C++, PHP, Ruby
- Mobile (React Native, Flutter, Swift, Kotlin)
- ANY project type!

---

### 10. Memory Bank System

**5 Core Memory Files**:

#### productContext.md
- Project name and overview
- Technology stack
- Architecture
- Core features
- **When to edit**: Once during setup

#### activeContext.md
- Current focus
- Recent achievements
- Next priorities
- Active blockers
- **When to edit**: Auto-updated by hooks

#### progress.md
- Sprint tracking
- Completed tasks
- In-progress work
- Upcoming priorities
- **When to edit**: Auto-updated

#### decisionLog.md
- Technical decisions (ADRs)
- Timestamped entries
- Rationale and impact
- **When to edit**: Auto-appended

#### systemPatterns.md
- Coding standards
- Testing approach
- Error handling
- Security patterns
- **When to edit**: Once during setup

---

## 🛠️ Advanced Features

### Real-Time Context Updates

Quick updates without full sync:

```bash
/context-update focus "Building authentication"
/context-update blocker "API rate limiting issue"
/context-update achievement "Completed user registration"
/context-update priority "Add email verification"
```

### Smart Memory Sync

Full context synchronization:

```bash
/memory-sync          # Smart sync based on activity
/memory-sync --full   # Full sync (all files)
/memory-sync --quick  # Quick sync (activeContext only)
```

### Manual Quick Sync

Fast sync with note:

```bash
/umb "Completed authentication feature"
```

### Memory Cleanup

Archive old data:

```bash
/memory-cleanup           # Normal cleanup (keep last 5)
/memory-cleanup --dry-run # Preview changes
/memory-cleanup --full    # Aggressive (keep last 3)
```

---

## 📊 Status Footer

Every response includes:

```
🧠 MINI-CODERBRAIN STATUS
📊 Activity: 42 ops | 🗺️ Map: Loaded | ⚡ Context: Active

💡 Consider running /memory-cleanup (activeContext.md is 215 lines)
```

**Components**:
- **Activity**: Operation count this session
- **Map**: Codebase map status (None/Loaded/Available)
- **Context**: Context awareness status
- **Notifications**: Smart suggestions (only when relevant)

---

## 🎯 Use Cases

### Solo Developers
- Track feature development
- Remember architectural decisions
- Maintain coding standards
- Monitor progress

### Teams
- Share project context
- Document decisions automatically
- Maintain consistency
- Onboard new members

### Learning
- Document learning progress
- Track concepts mastered
- Build knowledge base
- Maintain study goals

### Open Source
- Document contribution patterns
- Track community decisions
- Maintain project history
- Onboard contributors

---

## 🚀 Performance Benefits

| Benefit | Impact |
|---------|--------|
| **Context Duplication** | Eliminated (0%) |
| **Token Efficiency** | 79.9% reduction |
| **Conversation Length** | 25% longer |
| **Memory Bloat** | Prevented automatically |
| **Setup Time** | 30 seconds |
| **Learning Curve** | Zero |
| **Configuration** | None required |

---

## 🔐 Security Features

### Gitignore Protection
- `.claude/memory/*.md` files gitignored
- User data never committed
- Framework files committed
- Templates committed (not actual data)

### Privacy
- All context stored locally
- No external services
- No data transmission
- Full control over sensitive info

---

## 🌟 What Makes It Special

### 1. Zero Configuration
Drop in and go. No config files, no setup, no learning curve.

### 2. Universal Compatibility
Works with ANY project type, ANY language, ANY framework.

### 3. Automatic Everything
- Auto-detects project structure
- Auto-tracks activity
- Auto-updates context
- Auto-suggests maintenance

### 4. Perfect Continuity
Never lose context between sessions. Ever.

### 5. Production Ready
Built for real-world development, tested in production.

---

<div style="text-align: center; margin-top: 50px;">
  <h3>Ready to see the commands?</h3>
  <a class="btn btn-success" href="{{ '/commands' | relative_url }}">View Commands Reference →</a>
</div>
