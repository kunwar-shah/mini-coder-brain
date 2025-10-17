# CLAUDE.md — Mini-CoderBrain Universal Controller

## 📋 Project Setup Metadata

**IMPORTANT**: Fill this section during `/init-memory-bank` setup. These settings affect how mini-coder-brain understands your project workflow.

```yaml
# Version Control
uses_git: true              # Using Git for version control?
git_host: github            # github / gitlab / bitbucket / none
repository_url: ""          # Full repo URL (if applicable)

# Containerization
uses_docker: false          # Using Docker?
uses_docker_compose: false  # Using docker-compose?

# CI/CD
ci_cd_tool: none            # github-actions / gitlab-ci / jenkins / circleci / none
deployment_target: ""       # production / staging / vercel / aws / none

# Testing
testing_framework: ""       # jest / vitest / pytest / none
test_coverage_required: 80  # Minimum coverage % (0-100)

# Code Quality
uses_linter: false          # ESLint / Pylint / RuboCop?
uses_formatter: false       # Prettier / Black / rustfmt?
uses_pre_commit: false      # Pre-commit hooks enabled?

# Documentation
has_technical_docs: false   # Technical documentation available?
docs_location: ""           # Path to docs folder
api_docs_tool: ""           # swagger / openapi / jsdoc / none

# Development Workflow
branching_strategy: ""      # git-flow / trunk-based / feature-branch
code_review_required: false # PR reviews required?
pair_programming: false     # Team uses pair programming?

# Behavior Profile (v2.1+)
behavior_profile: "default" # default / focus / research / implementation / custom-name
```

**How to Use**:
- Run `/init-memory-bank` to auto-populate these settings
- Update manually in this section if your workflow changes
- Claude reads this to adapt suggestions and behavior

---

## 🚀 Session Bootstrapping Rules (ONCE per session only)

**IMPORTANT**: Execute these rules ONLY when you see the session-start hook output (boot status display). DO NOT re-execute on subsequent conversation turns.

On SESSION START (when session-start hook displays boot status), do the following automatically:

1) **Context files are ALREADY LOADED by session-start hook** (they persist in conversation history):
   - ⚠️ **FORBIDDEN**: DO NOT use Read tool on these files unless user explicitly asks
   - ⚠️ **FORBIDDEN**: DO NOT re-read productContext.md, activeContext.md, progress.md, decisionLog.md, systemPatterns.md
   - ✅ **CORRECT**: Use the content from Turn 1 (session-start hook output) available in conversation history
   - These files are in conversation history from Turn 1 - reference that, don't re-read

1b) **Load behavior profile ONCE** (v2.1+ feature):
   - Check `behavior_profile` setting in CLAUDE.md Project Setup Metadata (line ~41)
   - Load corresponding profile from `.claude/profiles/[profile-name].md`
   - If not specified or invalid, load `.claude/profiles/default.md`
   - Profile persists throughout session (no re-loading)

2) **Memory Health Check** (v2.2+ - Session Start):
   - Session-start hook displays memory health tip if needed
   - If you see "💡 Memory cleanup recommended" → Acknowledge and suggest user run /memory-cleanup
   - If you see "⚠️ Memory bloat detected" → STRONGLY recommend /memory-cleanup before continuing work
   - This prevents token bloat and "Prompt too long" errors

3) Produce a short **Boot Status** (3–5 bullets):
   - Current focus & objectives (from activeContext)
   - Key blockers / open questions (from activeContext)
   - Recent progress (from progress)
   - Decisions relevant today (from decisionLog)

4) Prefix EVERY response with: `[MINI-CODER-BRAIN: ACTIVE]`.

5) **Enhanced Status Footer** (MANDATORY - NEVER SKIP - v2.1):
   - The UserPromptSubmit hook injects enhanced status footer data
   - You MUST display this status footer at the END of EVERY response
   - **Always display it** - even for short responses, errors, or questions
   - **CRITICAL**: Display the EXACT footer with notifications (if any)

   **How to construct the footer**:
   - Read activity count from tool logs (`.claude/memory/conversations/tool-tracking/`)
   - Read session duration from `.claude/tmp/session-start-time`
   - Read last sync from `.claude/tmp/last-memory-sync`
   - Read current profile from `.claude/tmp/current-profile`
   - Check for notifications (memory bloat, high activity, map staleness)

   **Footer format** (3-4 lines):
   ```

   🧠 MINI-CODER-BRAIN STATUS
   📊 Activity: X ops | 🗺️ Map: Status | ⚡ Context: Active
   🎭 Profile: name | ⏱️ duration | 🎯 Focus: current work
   💾 Memory: health | 🔄 Last sync: time | 🔧 Tools: top 3

   💡 [Notifications ONLY if they exist - THIS IS CRITICAL FOR USER ENGAGEMENT]

   ```

   **Notification Types** (show when triggered):
   - 🧹 Memory cleanup: >10 session updates in activeContext
   - 🔄 High activity: >50 ops + >10min since last sync
   - 🗺️ Map stale: Codebase map >24h old

   **Example with notifications**:
   ```
   🧠 MINI-CODER-BRAIN STATUS
   📊 Activity: 149 ops | 🗺️ Map: None | ⚡ Context: Active
   🎭 Profile: default | ⏱️ 2h 15m | 🎯 Focus: Test suite development
   💾 Memory: Monitor | 🔄 Last sync: 1d ago | 🔧 Tools: Write(20) Bash(15) Edit(10)

   💡 🧹 Memory cleanup recommended (13 session updates). Run /memory-cleanup. 🔄 High activity (149 ops) + 1698m since last sync. Run /memory-sync --full.
   ```

> If `.claude/memory/` is missing: ask to create & initialize with default templates, then stop until done.

**Context Persistence**: Once loaded at session start, context remains available throughout the entire conversation via conversation history. DO NOT re-load memory files on subsequent turns.

6) **CRITICAL: Behavioral Patterns** (Read reference patterns as needed)

**Pattern Library** (Read on-demand, NOT injected - zero token impact):
- **@.claude/patterns/pre-response-protocol.md** → MANDATORY 5-step checklist before every response
- **@.claude/patterns/context-utilization.md** → How to use memory bank files without duplication
- **@.claude/patterns/proactive-behavior.md** → When/how to make helpful suggestions
- **@.claude/patterns/anti-patterns.md** → Banned behaviors and common mistakes to avoid
- **@.claude/patterns/tool-selection-rules.md** → Which tool to use for each task

**Memory Bank Files** (loaded once at session start, persist in conversation history):
- **productContext.md** → Project name, tech stack, architecture, features, goals
- **systemPatterns.md** → Coding patterns, conventions, standards, best practices
- **activeContext.md** → Current focus, recent achievements, blockers, what we just did
- **progress.md** → Sprint tracking, completed/in-progress/next tasks
- **decisionLog.md** → Technical decisions with timestamps (ADRs)
- **project-structure.json** → Detected file paths and project structure
- **(Optional) codebase-map.json** → Semantic file mapping (if /map-codebase was run)

**MANDATORY PRE-RESPONSE PROTOCOL**:
Before responding to ANY request, complete the 5-step checklist:
1. ✅ CHECK productContext.md **IN CONVERSATION HISTORY** (from Turn 1 session-start)
2. ✅ CHECK systemPatterns.md **IN CONVERSATION HISTORY** (from Turn 1 session-start)
3. ✅ CHECK activeContext.md **IN CONVERSATION HISTORY** (from Turn 1 session-start)
4. ✅ CHECK project-structure.json (read if needed)
5. ✅ CHECK codebase-map.json (read if exists)

**⚠️ CRITICAL**: Steps 1-3 check conversation history, NOT disk. Memory files were loaded in Turn 1.

**ZERO ASSUMPTION RULE**: If context has the answer, USE IT immediately. Only ask user when genuinely missing information.

**For detailed behavioral guidelines, read patterns on-demand**:
- Context usage → @.claude/patterns/context-utilization.md
- What NOT to do → @.claude/patterns/anti-patterns.md
- Tool selection → @.claude/patterns/tool-selection-rules.md
- Proactive suggestions → @.claude/patterns/proactive-behavior.md

5) Project context awareness:
   - Auto-detect technology stack (package.json, requirements.txt, Cargo.toml, etc.)
   - Read and understand project structure from `.claude/memory/project-structure.json`
   - Identify development patterns and architectural decisions
   - Adapt to project-specific conventions and standards

6) Available commands:
   - **Essential**: `/init-memory-bank` (MANDATORY first run), `/update-memory-bank`, `/map-codebase`
   - **Memory Management**:
     - `/init-memory-bank` - Initialize project context (MANDATORY after installation)
     - `/update-memory-bank` - Update memory after major development work
     - `/memory-sync` - Full memory bank synchronization
     - `/context-update` - Quick real-time context updates
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

### `/update-memory-bank "note"`
Update memory bank after major development work.

**Usage**:
- `/update-memory-bank "Completed authentication feature"` - Update with context note
- `/update-memory-bank` - Standard update (analyzes current session)
- Automatic sync happens on session end via stop hook

**Use when**:
- After completing major features or tasks
- After making technical decisions
- When prompted: "Consider: /update-memory-bank"
- End of development session

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
- **NEVER add co-author attribution to git commits** - No "Co-Authored-By: Claude" or similar tags

### Behavioral Patterns (Read as Needed)
**IMPORTANT**: Patterns are read on-demand to guide behavior WITHOUT bloating context tokens:

- **@.claude/patterns/pre-response-protocol.md** - MANDATORY 5-step checklist
  - Check all context files before responding
  - Zero assumption rule
  - Banned questions list

- **@.claude/patterns/context-utilization.md** - Memory bank usage
  - How to use each memory file
  - Load-once principle (79.9% token reduction)
  - Context persistence throughout session

- **@.claude/patterns/proactive-behavior.md** - When to suggest
  - Good times to suggest (after tasks, detecting patterns)
  - Bad times to suggest (after every action)
  - Suggestion format and etiquette

- **@.claude/patterns/anti-patterns.md** - What NOT to do
  - Context duplication (banned)
  - Asking questions context answers (banned)
  - Over-engineering simple tasks
  - Security anti-patterns

- **@.claude/patterns/tool-selection-rules.md** - Which tool to use
  - Read vs Glob vs Grep
  - Edit vs Write
  - Bash vs specialized tools
  - Parallel vs sequential operations

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

**How to use patterns and rules**: Read them when relevant, don't inject in every prompt. They are reference material, not active context!

---

## 🎯 Mini-CoderBrain Core Features
- ✅ **Universal Context Awareness** - Auto-loads project context once per session
- ✅ **Context Continuity** - Full context persists naturally in conversation history
- ✅ **Behavioral Patterns Library** (v2.1) - Reference-based pattern system with zero token impact
- ✅ **Behavior Profiles** (v2.1) - Customizable AI modes (default, focus, research, implementation)
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
