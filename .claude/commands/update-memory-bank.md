---
description: Update memory bank after major development work (decisions, progress, context changes)
argument-hint: "[optional note]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Read(*), Edit(*)
---

# Update Memory Bank — Session Context Synchronization

**CRITICAL INSTRUCTION**: YOU MUST complete ALL steps below IN EXACT ORDER. DO NOT SKIP any step. DO NOT improvise. ONLY use Read, Edit, and Bash tools as specified.

Updates `.claude/memory/` files after significant development work. Use this command to preserve important decisions, progress, and context changes.

**When to Use**:
- ✅ After completing major features or tasks
- ✅ After making technical decisions (architecture, tech choices, patterns)
- ✅ After significant progress milestones
- ✅ When prompted by footer status: "💡 Consider updating memory bank"
- ✅ End of development session

**When NOT to Use**:
- ❌ After minor changes or bug fixes
- ❌ Multiple times per hour (use sparingly)
- ❌ For routine commits

## Usage

```bash
# Standard update (analyzes current session)
/update-memory-bank

# With context note
/update-memory-bank "Completed authentication feature with JWT"

# After major milestone
/update-memory-bank "Finished Sprint 3 - User management complete"
```

---

## EXECUTION STEPS - MANDATORY

## STEP 1: Parse Arguments - MANDATORY

**ACTION**: Check if user provided optional note

**DETECT** (YOU MUST check):
- IF message contains quoted text after `/update-memory-bank` → Set NOTE=<text>
- IF no argument → Set NOTE=""

**OUTPUT**: Tell user which mode:
- "Updating memory bank with note: [NOTE]"
- "Standard update (no note provided)"

---

## STEP 2: Load Session Context - MANDATORY

**YOU MUST USE Bash TOOL** to gather session data

**EXACT COMMANDS** (run in sequence):
```bash
# Get git status
git status

# Get files changed
git diff --name-status

# Get recent commits (if any)
git log --oneline -5 2>/dev/null || echo "No commits yet"
```

**VALIDATION**:
- ✅ Ran all 3 Bash commands
- ✅ Captured output from each
- ✅ No command errors occurred

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT skip git status check
- ❌ DO NOT assume what changed without checking
- ❌ DO NOT use other tools instead of Bash

---

## STEP 3: Analyze Changes - MANDATORY

**YOU MUST DETERMINE**:
1. **Technical Decisions**: Were any architecture/tech choices made in conversation?
2. **Progress Updates**: Were any tasks completed or started?
3. **Context Changes**: Did current focus or blockers change?
4. **New Patterns**: Were new coding patterns adopted?

**ANALYSIS METHOD**:
- Read conversation history from this session
- Count operations performed (edits, writes, reads)
- Identify files modified from git diff
- Extract key decisions from conversation

**OUTPUT**: Summary of findings:
```
📊 Session Analysis:
   - Operations: [count] (Read: X, Edit: Y, Write: Z, Bash: W)
   - Files modified: [count] files
   - Technical decisions: [count] decisions
   - Completed tasks: [count] tasks
   - New blockers: [count] blockers
```

---

## STEP 4: Update decisionLog.md (if decisions exist) - CONDITIONAL

**CONDITION**: IF technical decisions were made in conversation

**YOU MUST USE Edit TOOL** to append decisions

**EXACT FORMAT** (ADR template):
```markdown
[YYYY-MM-DDTHH:MM:SSZ] ADR-YYYYMMDD-NN — [Decision Title]

**Decision**: [What was decided]
**Rationale**: [Why this decision]
**Impact**: [Expected consequences]
**Implementation**: [How to implement]
**Follow-ups**: [Next steps]
```

**VALIDATION**:
- ✅ Used Edit tool (not Write)
- ✅ UTC timestamp in ISO 8601 format
- ✅ ADR follows exact template
- ✅ All 5 sections present (Decision, Rationale, Impact, Implementation, Follow-ups)

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT use Write tool (will overwrite file)
- ❌ DO NOT leave template placeholders
- ❌ DO NOT skip timestamp
- ❌ DO NOT skip IF no decisions exist

**IF NO DECISIONS** → Skip to STEP 5

---

## STEP 5: Update progress.md - MANDATORY

**YOU MUST USE Edit TOOL** to update progress sections

**WHAT TO UPDATE**:

### Move Completed Tasks:
**FIND**: Tasks in "## 🔄 IN PROGRESS" that are now done
**ACTION**: Move to "## ✅ COMPLETED (This Sprint)" with completion date
**FORMAT**: `- **YYYY-MM-DD** ✅ [Task description]`

### Add New In-Progress:
**IF**: New tasks started this session
**ACTION**: Add to "## 🔄 IN PROGRESS (Today)" with start date
**FORMAT**: `- **YYYY-MM-DD** 🔄 [Task description]`

**VALIDATION**:
- ✅ Used Edit tool (not Write)
- ✅ Moved completed tasks with dates
- ✅ Added new tasks with dates
- ✅ Preserved existing content

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT remove old completed tasks
- ❌ DO NOT overwrite entire file
- ❌ DO NOT skip date stamps
- ❌ DO NOT make up fake progress

---

## STEP 6: Update activeContext.md - MANDATORY

**YOU MUST USE Edit TOOL** to update sections

**WHAT TO UPDATE**:

### Current Focus (if changed):
**CONDITION**: IF focus changed during session
**ACTION**: Update "## 🎯 Current Focus" section
**FORMAT**: Brief 1-2 sentence description

### Recent Achievements:
**ACTION**: Append to "## ✅ Recent Achievements" section
**FORMAT**: `- [Achievement description] — YYYY-MM-DD HH:MM:SS UTC`
**LIMIT**: Keep only last 5 achievements (archive older ones)

### Next Priorities (if new):
**CONDITION**: IF new priorities discovered
**ACTION**: Add to "## 🚀 Next Priorities" section
**FORMAT**: Numbered list `1. [Priority]`

### Current Blockers (if new):
**CONDITION**: IF new blockers discovered
**ACTION**: Add to "## 🔒 Current Blockers" section
**FORMAT**: `- [Blocker description]`

**VALIDATION**:
- ✅ Used Edit tool (not Write)
- ✅ All timestamps in UTC
- ✅ Preserved existing structure
- ✅ Only updated what changed

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT overwrite entire file
- ❌ DO NOT remove old session updates (that's for /memory-cleanup)
- ❌ DO NOT skip timestamps
- ❌ DO NOT invent changes that didn't happen

---

## STEP 7: Update systemPatterns.md (if patterns discovered) - CONDITIONAL

**CONDITION**: IF new coding patterns or conventions emerged

**YOU MUST USE Edit TOOL** to append patterns

**EXAMPLES OF PATTERNS TO RECORD**:
- Authentication approach (JWT cookies, refresh tokens)
- Error handling patterns (custom Error classes)
- API endpoint structure (REST conventions)
- Testing patterns (test file locations)
- Database query patterns (ORM usage)

**FORMAT**:
```markdown
## [Pattern Category]
- [Pattern description]
- [When to use]
- [Example]
```

**VALIDATION**:
- ✅ Used Edit tool (not Write)
- ✅ Pattern is genuinely new (not already documented)
- ✅ Pattern has clear description and example

**IF NO NEW PATTERNS** → Skip to STEP 8

---

## STEP 8: Show Summary - MANDATORY

**YOU MUST OUTPUT** in this EXACT format:

```
🔍 Session Analysis Complete
📊 Operations performed: [count]
📝 Files modified: [count]

📝 Memory Bank Updates:
✅ decisionLog.md - [Added N decisions | No decisions to record]
✅ progress.md - [Moved N completed, added M in-progress | No changes]
✅ activeContext.md - [Updated focus, achievements, blockers | No changes]
✅ systemPatterns.md - [Added N patterns | No new patterns]

💾 Memory bank updated successfully!

📊 Summary:
   - Decisions recorded: [N]
   - Tasks completed: [N]
   - New blockers: [N]
   - Patterns added: [N]

💡 Next: Continue development with updated context
```

---

## CRITICAL VALIDATIONS - MANDATORY

**BEFORE CLAIMING SUCCESS**, verify:
- ✅ Completed ALL applicable steps (1-8) in exact order
- ✅ Used Edit tool for ALL file modifications (NEVER Write)
- ✅ All timestamps in UTC format (ISO 8601)
- ✅ No template placeholders left (no [PLACEHOLDER] values)
- ✅ Git status/diff was checked (not assumed)
- ✅ Only updated files that had actual changes
- ✅ Preserved existing content (append-only, never delete)

**IF ANY VALIDATION FAILS** → Report: "❌ Failed at STEP [X]: [reason]"

---

## ABSOLUTELY FORBIDDEN

- ❌ DO NOT use Write tool (will overwrite files - use Edit instead)
- ❌ DO NOT skip git status/diff checks
- ❌ DO NOT invent progress that didn't happen
- ❌ DO NOT remove old content from memory files
- ❌ DO NOT skip timestamps
- ❌ DO NOT claim success if validations fail
- ❌ DO NOT make assumptions about what changed without checking

---

## What Gets Updated

### 1. decisionLog.md
**Only if significant technical decisions occurred**

Format:
```markdown
[2025-10-14T10:30:00Z] ADR-20251014-01 — Chose Redis for Session Storage

**Decision**: Use Redis for session management instead of PostgreSQL
**Rationale**: Better performance for frequent reads/writes, built-in TTL
**Impact**: Need to deploy Redis instance, update session middleware
**Implementation**: Install ioredis, create session service wrapper
**Follow-ups**: Monitor Redis memory usage, implement backup strategy
```

**Examples of decisions to record**:
- Technology choices (Redis vs Memcached)
- Architecture patterns (REST vs GraphQL)
- Security approaches (JWT vs Sessions)
- Database schema changes
- API design decisions

### 2. progress.md
**Move items between sections with timestamps**

- ✅ **COMPLETED** - Finished tasks (with completion date)
- 🔄 **IN PROGRESS** - Active work (with start date)
- ⏳ **PENDING** - Upcoming tasks

Example update:
```markdown
### ✅ COMPLETED (This Sprint)
- **2025-10-14** ✅ Implemented JWT authentication with refresh tokens
- **2025-10-14** ✅ Added role-based access control (RBAC)
- **2025-10-13** ✅ Created user registration flow

### 🔄 IN PROGRESS (Today)
- **2025-10-14** 🔄 Setting up Redis session store
- **2025-10-14** 🔄 Writing integration tests for auth flow
```

### 3. activeContext.md
**Update if focus/blockers/priorities changed**

Appends to relevant sections:
```markdown
## 🎯 Current Focus
Implementing authentication system with JWT tokens and Redis session management

## ✅ Recent Achievements
- Completed user authentication flow (JWT + refresh tokens)
- Added RBAC with role middleware
- Set up Redis integration

## 🚀 Next Priorities
1. Complete integration tests for auth
2. Add rate limiting to login endpoints
3. Implement password reset flow

## 🔒 Current Blockers
- Redis connection pooling needs optimization
- Need to decide on refresh token rotation strategy
```

### 4. systemPatterns.md
**Add new patterns discovered during development**

Example additions:
```markdown
## Authentication Patterns
- JWT tokens stored in httpOnly cookies
- Refresh tokens in Redis with 7-day TTL
- Role-based middleware: requireAuth(['admin', 'user'])

## Error Handling Patterns
- Custom AppError class with status codes
- Global error middleware catches all errors
- Structured error responses: {error: {message, code, details}}
```

## Context Loading

The command automatically loads:
- 📊 Git status (staged/unstaged changes)
- 📝 Git diff (files changed)
- 💬 Conversation history (decisions made, problems solved)
- 🔄 Current session activity (from pending-umb.json if available)

## Output

```
🔍 Analyzing current session...
✅ Found 12 commits, 8 files changed

📝 Updating memory bank...
✅ decisionLog.md - Added 2 technical decisions
✅ progress.md - Moved 3 tasks to COMPLETED
✅ activeContext.md - Updated current focus and priorities
✅ systemPatterns.md - Added authentication patterns

💾 Memory bank updated successfully!

📊 Summary:
   - Decisions recorded: 2
   - Tasks completed: 3
   - New blockers: 0
   - Patterns added: 1

💡 Next: Continue development with updated context
```

## Rules

- ✅ **Append-only** - Never overwrite existing content
- ✅ **UTC timestamps** - All timestamps in UTC format (ISO 8601)
- ✅ **Concise** - Keep updates brief and focused
- ✅ **Include note** - If provided via argument, include in updates
- ✅ **Smart detection** - Only update files with actual changes

## Integration with Footer Status

The intelligent status notification system will suggest `/update-memory-bank` when:
- 🎯 Significant development activity detected (>50 operations)
- 📅 Long session (>2 hours)
- 🚀 Major milestone reached
- 💭 Technical decisions made in conversation

Look for this footer message:
```
💡 Consider running /update-memory-bank to preserve session context
```

## Comparison with Other Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/init-memory-bank` | Initial setup | Once after installation |
| `/update-memory-bank` | Major updates | After significant work |
| `/context-update` | Quick updates | Real-time, frequent |
| `/memory-sync` | Full sync | Comprehensive analysis |
| `/memory-cleanup` | Cleanup bloat | When prompted or quarterly |

---

**Related Commands**: `/init-memory-bank`, `/memory-sync`, `/context-update`, `/memory-cleanup`
**Frequency**: After major milestones or when prompted
**Impact**: High - preserves critical project context
