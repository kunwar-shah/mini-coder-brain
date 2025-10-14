---
description: Update memory bank after major development work (decisions, progress, context changes)
argument-hint: "[optional note]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(cat:*), Read(*), Edit(*)
---

# Update Memory Bank — Session Context Synchronization

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
