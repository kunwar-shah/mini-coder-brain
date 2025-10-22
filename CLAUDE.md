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

1) **Core context files ALREADY LOADED by session-start hook** (they persist in conversation history):
   - ✅ **Loaded at session start**: productContext.md, activeContext.md (core only), systemPatterns.md
   - 📋 **On-demand only**: progress.md, decisionLog.md (read when needed, not at session start)

   **⚠️ FORBIDDEN - DO NOT re-read these files**:
   - ❌ DO NOT Read productContext.md (already in Turn 1 conversation history)
   - ❌ DO NOT Read activeContext.md (already in Turn 1 conversation history)
   - ❌ DO NOT Read systemPatterns.md (already in Turn 1 conversation history)

   **✅ CORRECT behavior**:
   - Use content from Turn 1 session-start hook output (in conversation history)
   - Read progress.md or decisionLog.md ONLY when you need specific information from them

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

3) **YOU MUST PRODUCE** a short **Boot Status** (3–5 bullets ONLY):

   **REQUIRED CONTENT**:
   - Current focus & objectives (from activeContext in conversation history)
   - Key blockers / open questions (from activeContext in conversation history)
   - Recent progress (from progress - read if needed)
   - Decisions relevant today (from decisionLog - read if needed)

   **VALIDATION**:
   - ✅ Boot status is 3-5 bullets (not more, not less)
   - ✅ Used data from conversation history (NOT re-read files)
   - ✅ Kept concise (< 200 characters total)

   **ABSOLUTELY FORBIDDEN**:
   - ❌ DO NOT exceed 5 bullets
   - ❌ DO NOT re-read productContext/activeContext/systemPatterns (already loaded)
   - ❌ DO NOT output verbose multi-paragraph status

4) **YOU MUST PREFIX** EVERY response with: `[MINI-CODER-BRAIN: ACTIVE]`

   **THIS MEANS**:
   - ✅ EVERY single response starts with this prefix
   - ✅ Before any other text
   - ✅ Exact format: `[MINI-CODER-BRAIN: ACTIVE]`

   **ABSOLUTELY FORBIDDEN**:
   - ❌ DO NOT skip the prefix (even for 1-line responses)
   - ❌ DO NOT modify the format
   - ❌ DO NOT forget the prefix

5) **CRITICAL: Enhanced Status Footer (MANDATORY - NEVER SKIP - v2.1)**

   **⚠️ ABSOLUTELY REQUIRED**: YOU MUST display the status footer at the END of EVERY response. NO EXCEPTIONS.

   **THIS MEANS**:
   - ✅ Display footer after EVERY response (even 1-line responses)
   - ✅ Display footer even for error messages
   - ✅ Display footer even when asking questions
   - ✅ Display footer BEFORE user can reply
   - ✅ Display footer for ALL responses without exception

   **THIS DOES NOT MEAN**:
   - ❌ "Skip footer for short responses"
   - ❌ "Only show when you remember"
   - ❌ "Make footer conditional on response type"

   **HOW THE FOOTER WORKS**:
   - The UserPromptSubmit hook (`conversation-capture-user-prompt.sh`) generates ALL footer data
   - Hook injects data via `additionalContext` field with EVERY user prompt
   - You receive: activity count, map status, session duration, profile, focus, memory health, last sync, tool usage
   - **YOU MUST DISPLAY THIS DATA** - it's already calculated for you

   **YOU MUST BUILD FOOTER FROM TEMP FILES** (Hook pre-calculates all values):

   The UserPromptSubmit hook has ALREADY calculated all values and stored them in temp files.
   YOU MUST read these files to build the footer:

   **MANDATORY: Read these files for footer data**:

   1. **Activity Count**:
      - Read file: `.claude/memory/conversations/tool-tracking/$(date '+%Y-%m-%d')-tools.log`
      - Count lines: `wc -l < file` = activity count

   2. **Session Duration**:
      - Read file: `.claude/tmp/session-start-time`
      - Calculate: `(current_time - start_time) / 60` = minutes
      - Format: "<60min: "25m" | 60-1440min: "2h 15m" | >1440min: "3d 5h"

   3. **Last Sync**:
      - Read file: `.claude/tmp/last-memory-sync`
      - Calculate: `(current_time - last_sync) / 60` = minutes_ago
      - Format: "0: Just now | <60: "25m ago" | <1440: "2h ago" | >=1440: "3d ago"

   4. **Current Profile**:
      - Read file: `.claude/tmp/current-profile`
      - Use value (default: "default")

   5. **Current Focus**:
      - Use from activeContext.md (already in conversation history from session start)
      - First line after "## 🎯 Current Focus" (max 50 chars)

   6. **Memory Health**:
      - Count session updates in activeContext.md: `grep "^## .* Session Update" | wc -l`
      - If >15: "Needs Cleanup" | If >10: "Monitor" | Else: "Healthy"

   7. **Tool Usage** (current turn only):
      - Count tools YOU used THIS TURN
      - Format: "Read(3) Edit(2) Bash(1)" (top 3)

   8. **Map Status**:
      - Check if `.claude/cache/codebase-map.json` exists
      - If no: "None" | If yes: check age and say "Fresh" or "Stale"

   **EXACT FOOTER FORMAT** (4 lines - MANDATORY structure):

   ```

   🧠 MINI-CODER-BRAIN STATUS
   📊 Activity: [X] ops | 🗺️ Map: [status] | ⚡ Context: Active
   🎭 Profile: [profile] | ⏱️ [duration] | 🎯 Focus: [current work]
   💾 Memory: [health] | 🔄 Last sync: [time] | 🔧 Tools: [top 3 tools]

   ```

   **NOTIFICATION DETECTION - MANDATORY**:

   **YOU MUST CHECK** these conditions and add 5th line if ANY are true:

   **CONDITION 1: Memory Cleanup Needed**
   - IF session updates in activeContext.md > 10 → Add notification
   - Notification: `💡 🧹 Memory cleanup recommended ([N] session updates). Run /memory-cleanup.`

   **CONDITION 2: High Activity Without Sync**
   - IF activity count > 50 AND last sync > 10 minutes ago → Add notification
   - Notification: `💡 🔄 High activity session ([N] ops). Consider: /memory-sync to preserve context.`

   **CONDITION 3: Stale Codebase Map**
   - IF `.claude/cache/codebase-map.json` exists AND age > 24 hours → Add notification
   - Notification: `💡 🗺️ Codebase map is stale. Run /map-codebase --rebuild to refresh.`

   **5TH LINE FORMAT** (add ONLY if notification exists):
   ```
   💡 [notification text]
   ```

   **VALIDATION BEFORE DISPLAYING FOOTER**:
   - ✅ Checked all 3 notification conditions
   - ✅ IF any condition true → Added 5th line with notification
   - ✅ IF no conditions true → Display 4-line footer only

   **ABSOLUTELY FORBIDDEN**:
   - ❌ DO NOT skip notification detection
   - ❌ DO NOT display notifications when conditions are false
   - ❌ DO NOT forget to check all 3 conditions

   **EXAMPLE OUTPUT** (using hook data):
   ```

   🧠 MINI-CODER-BRAIN STATUS
   📊 Activity: 149 ops | 🗺️ Map: None | ⚡ Context: Active
   🎭 Profile: default | ⏱️ 2h 15m | 🎯 Focus: Command validation fixes
   💾 Memory: Monitor | 🔄 Last sync: 1d ago | 🔧 Tools: Edit(20) Read(15) Bash(10)

   💡 🧹 Memory cleanup recommended (13 session updates). Run /memory-cleanup.
   ```

   **⚠️ ABSOLUTELY FORBIDDEN**:
   - ❌ NEVER skip the status footer (even for 1-line responses)
   - ❌ NEVER ignore data from UserPromptSubmit hook's `additionalContext`
   - ❌ NEVER make up random values when hook data is available
   - ❌ NEVER say "I'll show it next time"
   - ❌ NEVER make footer "conditional" based on response length or type
   - ❌ NEVER end response without footer
   - ❌ NEVER modify the 4-line structure

   **CRITICAL VALIDATION** (before sending response):
   - ✅ Footer is present at the END of response
   - ✅ Footer uses data from `additionalContext` if available, or reads from temp files
   - ✅ Footer has all 4 lines minimum (or 5 if notifications exist)
   - ✅ Footer follows exact format with emojis and structure
   - ✅ No response is sent without footer

   **REMEMBER**: The hook does ALL the heavy work (reads files, calculates values, detects notifications). YOU MUST DISPLAY what the hook provides via `additionalContext`, or read from temp files if unavailable. Footer is NOT OPTIONAL - it's MANDATORY like your signature on every response.

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

5) **Project Context Awareness - MANDATORY**:

   **YOU MUST PERFORM** these actions at session start and throughout development:

   **ACTION 1: Auto-Detect Technology Stack**
   - **YOU MUST DETECT** tech stack from project files
   - **CHECK**: package.json (Node.js), requirements.txt (Python), Cargo.toml (Rust), etc.
   - **USE Read OR Glob TOOL** to find and read these files
   - **STORE** detected stack in memory for session

   **ACTION 2: Understand Project Structure**
   - **YOU MUST READ** `.claude/memory/project-structure.json` (if exists)
   - **USE Read TOOL** to load project structure
   - **UNDERSTAND**: Frontend path, backend path, database path, tests path
   - **USE** this structure to locate files quickly

   **ACTION 3: Identify Development Patterns**
   - **YOU MUST CHECK** architectural decisions in decisionLog.md (read if needed)
   - **IDENTIFY**: Design patterns used, testing approach, error handling patterns
   - **REMEMBER**: Patterns throughout session for consistency

   **ACTION 4: Adapt to Project Conventions**
   - **YOU MUST FOLLOW** conventions defined in systemPatterns.md (already in conversation history)
   - **ADAPT**: Naming conventions, file organization, coding style
   - **NEVER ASSUME**: Always check patterns before making suggestions

   **VALIDATION**:
   - ✅ Detected and recorded technology stack
   - ✅ Read project-structure.json (if exists)
   - ✅ Aware of architectural decisions
   - ✅ Following systemPatterns.md conventions

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

## ✅ Memory-Bank Update Rules - MANDATORY

**CRITICAL INSTRUCTION**: When updating ANY memory bank file, YOU MUST follow these rules:

**RULE 1: Tool Usage - MANDATORY**
- **YOU MUST USE Edit TOOL** to update existing memory files
- NEVER use Write tool (will overwrite entire file and lose history)
- Edit tool preserves existing content and appends new data

**RULE 2: Timestamps - MANDATORY**
- **YOU MUST append** with UTC timestamps in ISO 8601 format
- Format: `YYYY-MM-DDTHH:MM:SSZ` for decisionLog
- Format: `YYYY-MM-DD HH:MM:SS UTC` for session updates
- Get timestamp using: `date -u +"%Y-%m-%dT%H:%M:%SZ"`

**RULE 3: File Mapping - MANDATORY**
- **Decisions** → YOU MUST update `.claude/memory/decisionLog.md`
- **Progress** → YOU MUST update `.claude/memory/progress.md`
- **Session focus/blockers** → YOU MUST update `.claude/memory/activeContext.md`
- **Standards/patterns** → YOU MUST update `.claude/memory/systemPatterns.md`
- **Project overview** → YOU MUST update `.claude/memory/productContext.md`

**VALIDATION BEFORE UPDATING**:
- ✅ Used Edit tool (not Write)
- ✅ Added UTC timestamp
- ✅ Updating correct file for content type
- ✅ Preserving all existing content

**ABSOLUTELY FORBIDDEN**:
- ❌ NEVER use Write tool on existing memory files
- ❌ NEVER overwrite or delete existing history
- ❌ NEVER skip timestamps
- ❌ NEVER modify old entries (append only)

---

## 🔐 Universal Working Rules

### Core Guidelines - MANDATORY

**YOU MUST FOLLOW** these guidelines for ALL development work:

**GUIDELINE 1: Follow Project Patterns**
- **YOU MUST READ** `systemPatterns.md` (from conversation history) before writing code
- **YOU MUST APPLY** project-specific patterns and conventions
- **YOU MUST ADAPT** to coding style defined in systemPatterns

**GUIDELINE 2: Record Technical Decisions**
- **YOU MUST RECORD** all architecture/tech choices in `decisionLog.md`
- **YOU MUST USE** ADR format (Decision, Rationale, Impact, Implementation, Follow-ups)
- **YOU MUST ADD** UTC timestamp to every decision
- **USE Edit TOOL** to append decisions (never Write)

**GUIDELINE 3: Keep Progress Accurate**
- **YOU MUST UPDATE** `progress.md` when tasks complete or status changes
- **YOU MUST ORGANIZE** as: **Completed / In Progress / Next**
- **YOU MUST ADD** dates to all progress entries
- **USE Edit TOOL** to update (never Write)

**GUIDELINE 4: Maintain Active Context**
- **YOU MUST ENSURE** `activeContext.md` reflects current focus & blockers
- **YOU MUST UPDATE** when focus changes, blockers discovered, or achievements made
- **USE /context-update** command for real-time updates
- **USE Edit TOOL** to modify (never Write)

**GUIDELINE 5: Auto-Detect Technology Stack**
- **YOU MUST DETECT** tech stack from files (package.json, requirements.txt, etc.)
- **YOU MUST ADAPT** suggestions to detected stack
- **YOU MUST USE** project structure from `.claude/memory/project-structure.json`
- **DO NOT ASSUME** stack - always detect or check productContext.md

**GUIDELINE 6: Git Commit Attribution**
- **ABSOLUTELY FORBIDDEN**: NEVER add co-author attribution to git commits
- ❌ NO "Co-Authored-By: Claude" tags
- ❌ NO AI attribution in commit messages
- ❌ NO bot signatures in commits

**VALIDATION BEFORE CLAIMING COMPLIANCE**:
- ✅ Checked systemPatterns.md for coding conventions
- ✅ Recorded decisions in decisionLog.md (if any made)
- ✅ Updated progress.md (if task status changed)
- ✅ Used Edit tool for all memory file updates
- ✅ No co-author attribution in git commits

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
