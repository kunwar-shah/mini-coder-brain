# Context Management Rules

**Purpose**: Maintain perfect context without token bloat

---

## Memory Bank Philosophy

### What Goes Where

**productContext.md** - Static project overview
- Project name and purpose (2-3 sentences)
- Technology stack (list only)
- High-level architecture (diagram or brief)
- Core features (bullets, not details)
- **DON'T**: Implementation details, history, verbose docs

**activeContext.md** - Dynamic current state
- Current focus (1-2 sentences)
- Recent achievements (last 3 only)
- Next priorities (top 3 only)
- Active blockers (current only)
- **DON'T**: Completed work, old blockers, full history

**progress.md** - Milestone tracking
- Current sprint status
- Completed tasks (summarize old, detail recent)
- In-progress items (active only)
- **DON'T**: Every single task ever, verbose descriptions

**decisionLog.md** - Technical decisions
- ADR format (decision, rationale, impact)
- Timestamped entries
- Append-only (never delete)
- **Read on demand**, not injected

**systemPatterns.md** - Coding standards
- Reference patterns and conventions
- Link to .claude/rules/ for details
- Project-specific exceptions
- **Read when coding**, not every prompt

---

## Context Lifecycle

### Session Start
1. Load productContext (name, focus)
2. Load activeContext (current state)
3. Detect project structure
4. Output 4-line summary ONLY

### During Session
1. Micro-context: 3-4 lines per prompt
2. Reference rules as needed
3. Update files, not prompt

### Session End
1. Update activeContext with summary
2. Count operations
3. Suggest memory sync if needed

---

## Anti-Patterns to Avoid

### ❌ Don't Do This
```markdown
# activeContext.md
## Full Project History
[200 lines of everything ever done...]

## All Decisions Ever Made
[100 ADRs dumped here...]

## Complete Codebase Documentation
[500 lines of file descriptions...]
```

### ✅ Do This Instead
```markdown
# activeContext.md
## 🎯 Current Focus
Implementing authentication with JWT tokens

## ✅ Recent Achievements
- Completed user registration endpoint
- Added password hashing with bcrypt
- Created login flow with token generation

## 🚀 Next Priorities
1. Add token refresh mechanism
2. Implement role-based access control
3. Write integration tests for auth flow
```

---

## Cleanup Rules

### Weekly Cleanup
- Summarize completed work in progress.md
- Archive old session updates (keep last 5)
- Review and condense activeContext

### Monthly Cleanup
- Move old ADRs to separate archive if > 50 entries
- Summarize old progress into quarterly sections
- Update productContext if scope changed

---

**Key Principle**: Context should be **current, concise, and contextual** - not a historical archive! 🎯
