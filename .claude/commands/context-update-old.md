---
description: Update active context with current focus, blockers, and priorities
argument-hint: "[focus|blocker|priority|achievement] [description]"
allowed-tools: Read(*), Write(*), Edit(*), Bash(date:*)
---

# Context Update — Real-Time Context Management

Quickly update `.claude/memory/activeContext.md` with current development state without running full memory sync.

## Purpose

The `/context-update` command provides fast, targeted updates to your active context:
- **Focus**: Change current development focus
- **Blocker**: Add new blocker discovered
- **Priority**: Add new priority to next steps
- **Achievement**: Record recent achievement

Perfect for maintaining real-time context awareness throughout your development session.

## Usage

```bash
# Update current focus
/context-update focus "Implementing authentication system"

# Add new blocker
/context-update blocker "API rate limiting needs caching solution"

# Add new priority
/context-update priority "Test edge cases for auth flow"

# Record achievement
/context-update achievement "Completed user login with JWT tokens"

# Interactive mode (no arguments)
/context-update
```

## Update Types

### Focus Update
Updates the "Current Focus" section with what you're working on right now.

**Example**:
```bash
/context-update focus "Refactoring database layer for better testability"
```

**Updates activeContext.md**:
```markdown
## 🎯 Current Focus
**Refactoring database layer for better testability**
_Updated: 2025-09-29 12:34:56 UTC_
```

---

### Blocker Addition
Adds new blocker to "Current Blockers" section.

**Example**:
```bash
/context-update blocker "Third-party API documentation missing endpoint details"
```

**Appends to activeContext.md**:
```markdown
## 🔒 Current Blockers
- **Third-party API documentation missing endpoint details**
  - _Added: 2025-09-29 12:34:56 UTC_
  - Status: Investigating
```

---

### Priority Addition
Adds new item to "Next Priorities" section.

**Example**:
```bash
/context-update priority "Add input validation for user registration form"
```

**Appends to activeContext.md**:
```markdown
## 🚀 Next Priorities
1. Add input validation for user registration form _(Added: 2025-09-29 12:34:56 UTC)_
2. [Previous priorities...]
```

---

### Achievement Recording
Adds achievement to "Recent Achievements" section.

**Example**:
```bash
/context-update achievement "Completed integration tests for authentication module - 100% coverage"
```

**Appends to activeContext.md**:
```markdown
## ✅ Recent Achievements
- **Completed integration tests for authentication module - 100% coverage** — 2025-09-29 12:34:56 UTC
- [Previous achievements...]
```

## Interactive Mode

Running `/context-update` without arguments enters interactive mode:

```
🔄 Context Update — Interactive Mode

What would you like to update?
1. Current Focus
2. Add Blocker
3. Add Priority
4. Record Achievement
5. Cancel

Select (1-5): _
```

AI will prompt for details and update accordingly.

## Benefits

- ⚡ **Fast**: Updates in seconds, no full memory sync needed
- 🎯 **Targeted**: Update exactly what changed
- 🔄 **Real-time**: Keep context current throughout session
- 📝 **Timestamped**: Every update has UTC timestamp
- 🧠 **Continuity**: Next session knows exact current state

## When to Use

### Use `/context-update` When:
- ✅ Starting work on new task (update focus)
- ✅ Hit a blocker (add blocker)
- ✅ Completed something significant (add achievement)
- ✅ Realized new priority (add priority)
- ✅ Context changed mid-session (quick updates)

### Use `/memory-sync` Instead When:
- Need full memory bank synchronization
- Multiple things changed at once
- End of significant work session
- Want comprehensive session summary

## Examples

### Typical Development Flow

**Morning Start**:
```bash
/context-update focus "Implementing payment processing with Stripe integration"
```

**Hit a Blocker**:
```bash
/context-update blocker "Stripe webhook signatures failing validation - investigating HMAC implementation"
```

**Found Solution, Add Priority**:
```bash
/context-update priority "Document webhook setup process for future reference"
```

**Completed Feature**:
```bash
/context-update achievement "Payment processing live - tested with $0.50 test charge successfully"
```

**End of Day**:
```bash
/memory-sync --full
# (Full sync to capture all work comprehensively)
```

## Integration with Hooks

### Works With Micro-Context Flow
- Updates immediately visible in next user prompt
- Stop hook includes recent context updates
- Session start hook shows latest focus and blockers

### Complements Automatic Sync
- Automatic: Basic session summaries (low detail)
- `/context-update`: Targeted real-time updates (medium detail)
- `/memory-sync`: Comprehensive synchronization (high detail)

## Output

```
✅ Context Updated: Focus

📝 Updated activeContext.md:
   Current Focus: "Implementing authentication system"
   Timestamp: 2025-09-29 12:34:56 UTC

🎯 Context is now up-to-date for next AI response!
```

## Best Practices

1. **Update focus when switching tasks**
   - Helps AI understand context changes
   - Provides clear development narrative

2. **Record blockers immediately when hit**
   - Captures problem while fresh
   - Helps find patterns in blockers

3. **Add achievements as you complete them**
   - Builds motivating progress history
   - Helps with sprint reviews

4. **Use priorities to plan next steps**
   - Keeps TODO list actionable
   - Aligns team on next actions

5. **Combine with `/memory-sync` for comprehensive updates**
   - Quick updates during work
   - Full sync at milestones

## Technical Notes

- Appends with UTC timestamps
- Preserves existing markdown structure
- Creates backup before modification
- Validates activeContext.md format
- Works offline (no network required)

---

**Related Commands**: `/memory-sync`, `/umb`
**Frequency**: Use liberally throughout session
**Impact**: Medium - keeps context current in real-time
