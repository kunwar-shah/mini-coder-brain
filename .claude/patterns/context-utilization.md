# Context Utilization Pattern

**Purpose**: How to effectively use the memory bank files loaded at session start

**Token Cost**: 0 (read on-demand only)

---

## 📂 Memory Bank Files (Already Loaded)

These files are loaded ONCE at session start and persist in conversation history:

| File | Contains | Use For |
|------|----------|---------|
| **productContext.md** | Project name, tech stack, architecture, features | Understanding what you're building |
| **systemPatterns.md** | Coding patterns, conventions, standards | Following project conventions |
| **activeContext.md** | Current focus, recent work, blockers | Knowing what we just did |
| **progress.md** | Sprint tasks (completed/in-progress/next) | Tracking development progress |
| **decisionLog.md** | Technical decisions (ADRs) | Understanding why choices were made |
| **project-structure.json** | File/folder paths detected | Finding files quickly |
| **codebase-map.json** | Semantic file mapping (optional) | Instant file access |

---

## 🎯 How to Use Each File

### productContext.md - "What am I building?"
**When to check**:
- User asks to add a feature
- Need to understand tech stack
- Starting any development task

**What to look for**:
- Technology stack (framework, database, etc.)
- Project architecture
- Core features list
- Development goals

---

### systemPatterns.md - "How should I code?"
**When to check**:
- Writing new code
- Creating files
- Making technical decisions
- Writing tests or commits

**What to look for**:
- Coding conventions (naming, structure)
- Testing patterns (framework, location)
- Error handling standards
- Commit message format

---

### activeContext.md - "What's happening now?"
**When to check**:
- Session starts
- User asks "what did we do?"
- Need to understand current focus

**What to look for**:
- Current sprint/focus area
- Recent achievements (last session)
- Active blockers
- Next priorities

---

### progress.md - "What's the status?"
**When to check**:
- Planning next tasks
- User asks about progress
- Completing a task

**What to look for**:
- Completed tasks (what's done)
- In-progress tasks (what's active)
- Next tasks (what's upcoming)
- Sprint deadlines

---

### decisionLog.md - "Why did we do that?"
**When to check**:
- Understanding past decisions
- Making similar decisions
- User asks "why did we choose X?"

**What to look for**:
- Architecture Decision Records (ADRs)
- Technical rationale
- Trade-offs considered
- Implementation notes

---

### project-structure.json - "Where are the files?"
**When to check**:
- Need to find a file quickly
- Creating new files (follow structure)
- Understanding project layout

**What to look for**:
- Frontend path
- Backend path
- Database/schema path
- Tests path
- Docs path

---

### codebase-map.json - "Exact file locations?"
**When to check** (if exists):
- Looking for specific components
- Finding models, utilities, services
- Need instant file access

**What to look for**:
- Semantic mappings (User model → path)
- Component locations
- Utility function files

---

## ⚡ CRITICAL RULE

**Files are loaded ONCE at session start**

They persist in conversation history naturally - DO NOT re-read unless:
- User explicitly updated a file
- You need to verify current content
- Genuinely unsure about content

**This prevents context duplication** (79.9% token reduction)

---

## ✅ CORRECT USAGE PATTERN

```
1. Session starts → Files loaded → Available in history
2. Turn 2: User asks something → Check history (files already there)
3. Turn 3: User asks something → Check history (files still there)
4. Turn N: User asks something → Check history (files persist)

NOT THIS ❌:
Turn 2: Re-read productContext.md
Turn 3: Re-read productContext.md
Turn 4: Re-read productContext.md
(Massive token waste!)
```

---

**Key Insight**: Context is in conversation history, not files. Read history, not disk.
