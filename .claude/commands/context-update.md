---
description: Update active context with current focus, blockers, and priorities
argument-hint: "[focus|blocker|priority|achievement] [description]"
allowed-tools: Read(*), Edit(*), Bash(date:*)
---

# Context Update — Real-Time Context Management

**CRITICAL INSTRUCTION**: YOU MUST complete ALL steps below IN EXACT ORDER. DO NOT SKIP any step. ONLY use Read, Edit, and Bash tools as specified.

Quickly update `.claude/memory/activeContext.md` with current development state without running full memory sync.

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

---

## EXECUTION STEPS - MANDATORY

## STEP 1: Parse Arguments - MANDATORY

**ACTION**: Detect update type and description

**DETECT** (YOU MUST check for these EXACT patterns):
- IF message matches `/context-update focus "..."` → Set TYPE="focus", DESC="..."
- IF message matches `/context-update blocker "..."` → Set TYPE="blocker", DESC="..."
- IF message matches `/context-update priority "..."` → Set TYPE="priority", DESC="..."
- IF message matches `/context-update achievement "..."` → SET TYPE="achievement", DESC="..."
- IF no arguments → Set TYPE="interactive"

**OUTPUT**: Tell user which type detected:
- "Updating focus: [description]"
- "Adding blocker: [description]"
- "Adding priority: [description]"
- "Recording achievement: [description]"
- "Interactive mode (will prompt for details)"

**VALIDATION**:
- ✅ Detected type correctly
- ✅ Extracted description (if provided)
- ✅ Set TYPE and DESC variables

---

## STEP 2: Get UTC Timestamp - MANDATORY

**YOU MUST USE Bash TOOL** to get current UTC timestamp

**EXACT COMMAND**:
```bash
date -u +"%Y-%m-%d %H:%M:%S UTC"
```

**VALIDATION**:
- ✅ Ran date command
- ✅ Got timestamp in format: YYYY-MM-DD HH:MM:SS UTC
- ✅ Stored timestamp for use in updates

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT skip timestamp
- ❌ DO NOT use local time (must be UTC)
- ❌ DO NOT use different format

---

## STEP 3: Read activeContext.md - MANDATORY

**YOU MUST USE Read TOOL** to read current activeContext

**FILE PATH**: `.claude/memory/activeContext.md`

**PURPOSE**: Need to see current content before editing

**VALIDATION**:
- ✅ Used Read tool
- ✅ File exists and was read successfully
- ✅ Can see current structure (sections: Focus, Achievements, Priorities, Blockers)

---

## STEP 4: Update activeContext.md Based on Type - MANDATORY

**YOU MUST USE Edit TOOL** to make the update

### IF TYPE="focus":
**FIND**: Section `## 🎯 Current Focus`
**ACTION**: Replace current focus with new one
**FORMAT**:
```markdown
## 🎯 Current Focus
**[New focus description]**
_Updated: YYYY-MM-DD HH:MM:SS UTC_
```

### IF TYPE="blocker":
**FIND**: Section `## 🔒 Current Blockers`
**ACTION**: Append new blocker to list
**FORMAT**:
```markdown
- **[Blocker description]**
  - _Added: YYYY-MM-DD HH:MM:SS UTC_
  - Status: Investigating
```

### IF TYPE="priority":
**FIND**: Section `## 🚀 Next Priorities`
**ACTION**: Add to top of numbered list
**FORMAT**:
```markdown
1. [Priority description] _(Added: YYYY-MM-DD HH:MM:SS UTC)_
[Previous priorities with numbers incremented]
```

### IF TYPE="achievement":
**FIND**: Section `## ✅ Recent Achievements`
**ACTION**: Prepend to list (most recent first)
**LIMIT**: Keep only last 5 achievements
**FORMAT**:
```markdown
- **[Achievement description]** — YYYY-MM-DD HH:MM:SS UTC
```

### IF TYPE="interactive":
**ACTION**: Prompt user:
```
🔄 Context Update — Interactive Mode

What would you like to update?
1. Current Focus
2. Add Blocker
3. Add Priority
4. Record Achievement

Select (1-4):
```
**WAIT** for user response, then proceed with selected type

**VALIDATION**:
- ✅ Used Edit tool (not Write)
- ✅ Updated correct section
- ✅ Added UTC timestamp
- ✅ Preserved existing content
- ✅ Followed exact format for type

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT use Write tool (will erase file)
- ❌ DO NOT skip timestamp
- ❌ DO NOT remove existing content
- ❌ DO NOT update wrong section
- ❌ DO NOT leave placeholder values

---

## STEP 5: Show Confirmation - MANDATORY

**YOU MUST OUTPUT** in this EXACT format:

```
✅ Context Updated: [Type]

📝 Updated activeContext.md:
   [Type]: "[description]"
   Timestamp: YYYY-MM-DD HH:MM:SS UTC

🎯 Context is now up-to-date for next AI response!
```

---

## CRITICAL VALIDATIONS - MANDATORY

**BEFORE CLAIMING SUCCESS**, verify:
- ✅ Completed ALL steps (1-5) in exact order
- ✅ Used Edit tool (not Write)
- ✅ Added UTC timestamp
- ✅ Updated correct section in activeContext.md
- ✅ Preserved all existing content
- ✅ No placeholder values remain

**IF ANY VALIDATION FAILS** → Report: "❌ Failed at STEP [X]: [reason]"

---

## ABSOLUTELY FORBIDDEN

- ❌ DO NOT use Write tool (will overwrite entire file)
- ❌ DO NOT skip timestamp
- ❌ DO NOT update without reading file first
- ❌ DO NOT remove old achievements/blockers/priorities
- ❌ DO NOT use local time (must be UTC)
- ❌ DO NOT claim success if validations fail

---

## Update Types

### Focus Update
Updates the "Current Focus" section with what you're working on right now.

### Blocker Addition
Adds new blocker to "Current Blockers" section.

### Priority Addition
Adds new item to "Next Priorities" section.

### Achievement Recording
Adds achievement to "Recent Achievements" section.

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

---

**Related Commands**: `/memory-sync`, `/update-memory-bank`
**Frequency**: Use liberally throughout session
**Impact**: Medium - keeps context current in real-time
