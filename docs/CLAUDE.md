# CLAUDE.md — Mini-CoderBrain Universal Controller

## 🚀 Session Bootstrapping Rules (ONCE per session only)

**IMPORTANT**: Execute these rules ONLY when you see the session-start hook output (boot status display). DO NOT re-execute on subsequent conversation turns.

On SESSION START (when session-start hook displays boot status), do the following automatically:

1) **Load context files ONCE** (these will persist in conversation history):
   - @.claude/memory/productContext.md
   - @.claude/memory/activeContext.md
   - @.claude/memory/progress.md
   - @.claude/memory/decisionLog.md
   - @.claude/memory/systemPatterns.md

2) Produce a short **Boot Status** (3–5 bullets):
   - Current focus & objectives (from activeContext)
   - Key blockers / open questions (from activeContext)
   - Recent progress (from progress)
   - Decisions relevant today (from decisionLog)

3) Prefix EVERY response with: `[CODERBRAIN: ACTIVE]`.

> If `.claude/memory/` is missing: ask to create & initialize with default templates, then stop until done.

**Context Persistence**: Once loaded at session start, context remains available throughout the entire conversation via conversation history. DO NOT re-load memory files on subsequent turns.

4) **CRITICAL: Context Utilization Rules** (Behavior Training)

You have ALREADY loaded these files at session start and they remain in conversation history:
- **productContext.md** → Project name, tech stack, architecture, features, goals
- **systemPatterns.md** → Coding patterns, conventions, standards, best practices
- **activeContext.md** → Current focus, recent achievements, blockers, what we just did
- **progress.md** → Sprint tracking, completed/in-progress/next tasks
- **decisionLog.md** → Technical decisions with timestamps (ADRs)
- **project-structure.json** → Detected file paths and project structure
- **(Optional) codebase-map.json** → Semantic file mapping (if /map-codebase was run)

**MANDATORY PRE-RESPONSE BEHAVIOR**:
Before responding to ANY user request, SEARCH YOUR LOADED CONTEXT FIRST for:
- Project information (tech stack, framework, language)
- File locations (where models, components, APIs are)
- Coding patterns (validation library, testing framework, code style)
- Recent work (what we did last session or last response)
- Project conventions (commit style, naming patterns, architecture)

**BANNED QUESTIONS** (context already has answers):
❌ "What framework are you using?" → CHECK productContext.md
❌ "Where is the User model located?" → CHECK codebase-map.json or project-structure.json
❌ "What's your preferred coding style?" → CHECK systemPatterns.md
❌ "What did we do last session?" → CHECK activeContext.md
❌ "What validation library do you use?" → CHECK systemPatterns.md or search recent code
❌ "Should I create tests?" → CHECK systemPatterns.md for testing patterns
❌ "What commit message format?" → CHECK systemPatterns.md for commit patterns

**ZERO ASSUMPTION RULE**:
If loaded context files have the answer → USE IT IMMEDIATELY
If you're unsure → SEARCH conversation history from Turn 1
ONLY ask user when information is genuinely missing or ambiguous

**Examples of Correct Behavior**:
✅ User: "Add authentication"
   You: *Check productContext.md → sees "Next.js 14 + Prisma"*
   You: *Check systemPatterns.md → sees "Uses Zod validation"*
   You: *Proceed with Next.js auth implementation using Zod, no questions asked*

✅ User: "Update the User model"
   You: *Check codebase-map.json → finds "src/lib/db/schema/user.ts"*
   You: *Open that file and make changes, no questions asked*

✅ User: "Write tests for this"
   You: *Check systemPatterns.md → sees "Vitest, colocated __tests__/"*
   You: *Create tests following that pattern, no questions asked*

5) Project context awareness:
   - Auto-detect technology stack (package.json, requirements.txt, Cargo.toml, etc.)
   - Read and understand project structure from `.claude/memory/project-structure.json`
   - Identify development patterns and architectural decisions
   - Adapt to project-specific conventions and standards

6) Available commands:
   - **Core**: `/map-codebase`, `/umb`, `/memory-sync`, `/context-update`, `/memory-cleanup`
   - **Memory Management**:
     - `/memory-sync` - Full memory bank synchronization
     - `/context-update` - Quick real-time context updates
     - `/umb "note"` - Fast manual sync with note
     - `/memory-cleanup` - Archive old data, prevent "Prompt is too long" errors
   - **Codebase**: `/map-codebase` - Revolutionary instant file access

---

## 🧭 Universal Development Approach
- **Understand** → Read productContext.md, systemPatterns.md, project structure
- **Context** → Keep activeContext.md up-to-date with current focus
- **Progress** → Track completed/in-progress/next in progress.md
- **Decisions** → Record all technical decisions in decisionLog.md
- **Patterns** → Follow project conventions in systemPatterns.md

---

## 🛠 Core Commands

### `/map-codebase`
Revolutionary instant file access system. Run once to enable surgical precision development.

**Usage**:
- `/map-codebase` - Load existing codebase map (instant)
- `/map-codebase --rebuild` - Rebuild from scratch (~30 seconds)
- `/map-codebase --recent` - Focus on recent changes only

### `/memory-sync`
Full memory bank synchronization - comprehensive context preservation.

**Usage**:
- `/memory-sync` - Smart sync based on session activity
- `/memory-sync --full` - Full synchronization (all memory files)
- `/memory-sync --quick` - Quick sync (activeContext only)

**Use after**: Completing features, making technical decisions, major milestones

### `/context-update`
Real-time context updates - fast, targeted updates to active context.

**Usage**:
- `/context-update focus "what you're working on"` - Update current focus
- `/context-update blocker "issue description"` - Add new blocker
- `/context-update priority "next task"` - Add new priority
- `/context-update achievement "what you completed"` - Record achievement
- `/context-update` - Interactive mode

**Use during**: Development session for real-time context maintenance

### `/memory-cleanup`
Archive old session updates and clean temporary files to prevent "Prompt is too long" errors.

**Usage**:
- `/memory-cleanup` - Archive old data (keep last 5 session updates)
- `/memory-cleanup --dry-run` - Preview what would be cleaned
- `/memory-cleanup --full` - Aggressive cleanup (keep last 3 updates)

**Use when**: Notified by intelligent-status-notification hook, or after high-activity sessions

**Benefits**:
- Reduces context tokens by ~60%
- Prevents "Prompt is too long" errors
- Preserves all history in `.claude/archive/`
- No data loss - everything archived

### `/umb "note"`
Quick manual sync - fast memory bank update with note.

**Usage**:
- `/umb "Completed authentication feature"` - Manual sync with note
- Automatic sync happens on session end via stop hook

**Use when**: Need quick sync without full analysis

---

## ✅ Memory-Bank Update Rules
- Append with **UTC timestamps**; never overwrite history.
- **Decisions** → `.claude/memory/decisionLog.md`
- **Progress** → `.claude/memory/progress.md`
- **Session focus/blockers** → `.claude/memory/activeContext.md`
- **Standards/patterns** → `.claude/memory/systemPatterns.md`
- **Project overview** → `.claude/memory/productContext.md`

---

## 🔐 Universal Working Rules

### Core Guidelines
- Follow project-specific patterns in `systemPatterns.md`
- Record all technical decisions in `decisionLog.md`
- Keep `progress.md` accurate (**Completed / Current / Next**)
- Ensure `activeContext.md` reflects today's focus & blockers
- Auto-detect and adapt to project's technology stack
- Use project structure from `.claude/memory/project-structure.json`

### Reference Rules (Read as Needed)
**IMPORTANT**: These rules exist to guide development WITHOUT bloating context tokens:

- **@.claude/rules/token-efficiency.md** - Prevent "Prompt too long" errors
  - MAX 4-5 lines session start output
  - MAX 3-4 lines micro-context
  - Memory bank size limits
  - Smart injection patterns

- **@.claude/rules/coding-standards.md** - Code quality guidelines
  - Language-specific best practices
  - Error handling patterns
  - Security requirements
  - Testing standards

- **@.claude/rules/context-management.md** - Memory bank maintenance
  - What goes in each file
  - Cleanup schedules
  - Anti-patterns to avoid
  - Context lifecycle

**How to use rules**: Read them when relevant, don't inject in every prompt. Rules are reference material, not active context!

---

## 🎯 Mini-CoderBrain Core Features
- ✅ **Universal Context Awareness** - Auto-loads project context once per session
- ✅ **Context Continuity** - Full context persists naturally in conversation history
- ✅ **Project Structure Detection** - Automatic detection of frontend/backend/database paths
- ✅ **Persistent Memory** - Context preservation across sessions
- ✅ **Intelligent Notifications** - Smart suggestions for memory sync and cleanup
- ✅ **Codebase Mapping** - Instant file access system
- ✅ **Memory Cleanup** - Automatic bloat prevention, "Prompt is too long" protection
- ✅ **100% Universal** - Works with any project type

---

## 🚀 Context Optimization - Zero Duplication

**How Context Loading Works**:

```
Session Start (Turn 1):
├── session-start.sh hook displays boot status
├── AI loads all 5 memory files (782 lines)
├── Context enters conversation history
└── Context-loaded flag created

Subsequent Turns (Turn 2+):
├── Context already in conversation history from Turn 1
├── No re-injection needed
├── Natural conversation continuity
└── Perfect context awareness maintained

Session End:
├── activeContext.md updated with session summary
├── Progress saved for next session
└── Context persists across sessions
```

**Benefits**:
- ⚡ **Zero Duplication** - Context loaded once, persists naturally
- 🎯 **Perfect Continuity** - Full context available throughout conversation
- 💰 **Token Efficient** - 25% longer conversations before limit
- 🧠 **Cross-Session Memory** - Context preserved between sessions
- 🧹 **Automatic Cleanup** - Memory bloat prevention built-in

---

## 📋 Session Workflow

### Session Start
1. Hooks automatically load context from `.claude/memory/`
2. Project structure detection runs automatically
3. Boot status displays current focus and progress
4. You're ready to work with full context awareness

### During Development
1. Work on your tasks with full project context
2. Make changes, write code, solve problems
3. Mini-CoderBrain tracks activity automatically
4. Context persists naturally in conversation

### Session End
1. Stop hook automatically updates `.claude/memory/activeContext.md`
2. Session summary appended with timestamp
3. Smart suggestions for `/memory-cleanup` if bloat detected
4. Context ready for next session

---

## ✅ Session End
Stop hook auto-syncs basic context. Run `/memory-cleanup` if notified about memory bloat.

---

**Mini-CoderBrain Version**: v1.0 - Universal Edition (Optimized)
**Installation**: Drop `.claude/` folder + `CLAUDE.md` into your project
**Compatibility**: All major programming languages and frameworks
**Dependencies**: None - works out of the box with Claude Code
**Performance**: Zero context duplication, 25% longer conversations, perfect continuity
