# Context Distribution Strategy: CLAUDE.md vs session-start.sh

**Purpose**: Strategic plan for what goes where to minimize token waste while maximizing AI effectiveness

**Key Principle**: Give the LLM ONLY what it needs, WHEN it needs it, WHERE it needs it.

---

## 🎯 The Core Problem

### Current Situation (Duplication)

**CLAUDE.md** (sent with EVERY response):
```markdown
## 🚀 Session Bootstrapping Rules (ONCE per session only)

On SESSION START, do the following automatically:

1) Load context files ONCE:
   - @.claude/memory/productContext.md
   - @.claude/memory/activeContext.md
   - @.claude/memory/progress.md
   - @.claude/memory/decisionLog.md
   - @.claude/memory/systemPatterns.md

2) Memory Health Check (v2.2+):
   - If "💡 Memory cleanup recommended" → Suggest /memory-cleanup

3) Produce short Boot Status (3-5 bullets)
4) Prefix EVERY response with [MINI-CODER-BRAIN: ACTIVE]
5) Enhanced Status Footer (MANDATORY - NEVER SKIP)
6) Behavioral Patterns (Read on-demand)
```

**session-start.sh** (runs ONCE per session):
```bash
# Outputs the same information:
- Loads memory files
- Checks memory health
- Displays boot status
- Shows enhanced footer
```

**Result**:
- CLAUDE.md tells AI what to do (100+ lines, every response)
- session-start does it once (but AI still sees instructions every time)
- **Token waste**: Instructions sent 50+ times per session instead of once

---

## 🧠 The Right Mental Model

### Two Types of Information

#### 1. **Behavioral Instructions** (How to behave)
**Frequency**: Every response
**Location**: CLAUDE.md
**Examples**:
- "Prefix every response with [MINI-CODER-BRAIN: ACTIVE]"
- "Show enhanced status footer at end of every response"
- "Read patterns on-demand, don't inject"
- "Never add co-author attribution to commits"

**Why Every Response**: AI needs constant reminders of HOW to behave

---

#### 2. **Context Data** (What to know)
**Frequency**: Once per session
**Location**: session-start.sh hook output
**Examples**:
- Project name: "TaskMaster Pro"
- Current focus: "JWT authentication"
- Recent achievements: "User registration complete"
- Memory health status: "13 session updates"

**Why Once**: Context persists in conversation history naturally

---

## 📊 Strategic Distribution Plan

### What Goes in CLAUDE.md (Every Response)

#### ✅ Keep in CLAUDE.md

**1. Behavioral Rules (Core Behavior)**
```markdown
- Prefix EVERY response with: [MINI-CODER-BRAIN: ACTIVE]
- Display enhanced status footer at END of EVERY response
- Never add co-author attribution to git commits
- Use TodoWrite for 3+ step tasks
- Edit existing files, don't Write over them
```
**Reason**: AI forgets behavior without constant reminders

---

**2. Pattern Library References (Zero-Token)**
```markdown
Behavioral Patterns (Read as Needed):
- @.claude/patterns/pre-response-protocol.md
- @.claude/patterns/context-utilization.md
- @.claude/patterns/proactive-behavior.md
- @.claude/patterns/anti-patterns.md
- @.claude/patterns/tool-selection-rules.md
```
**Reason**: Shows AI WHERE to look, doesn't inject content

---

**3. Memory Bank File List (Reference Only)**
```markdown
Memory Bank Files (loaded once at session start):
- productContext.md → Project overview
- activeContext.md → Current focus
- systemPatterns.md → Conventions
- progress.md → Sprint tracking
- decisionLog.md → Technical decisions
```
**Reason**: Reminds AI what files exist, doesn't duplicate content

---

**4. Core Commands List (Reference Only)**
```markdown
Available commands:
- /init-memory-bank - Initialize project context
- /update-memory-bank - Update after major work
- /memory-sync - Full synchronization
- /context-update - Quick context updates
- /memory-cleanup - Archive old data
- /map-codebase - Instant file access
```
**Reason**: Shows available tools, doesn't explain usage

---

**5. Critical Anti-Patterns (Banned Behaviors)**
```markdown
🚫 CRITICAL RULES:
- NEVER re-read memory files after session start
- NEVER create documentation files unless explicitly requested
- NEVER ask questions that context already answers
- NEVER load full session history (bloat protection)
```
**Reason**: Prevents common mistakes that waste tokens

---

#### ❌ Remove from CLAUDE.md (Move to session-start or docs)

**1. Session-Start Instructions (Move to session-start.sh)**
```markdown
❌ Remove from CLAUDE.md:
"On SESSION START, do the following automatically:
1) Load context files ONCE
2) Memory Health Check
3) Produce short Boot Status"

✅ This is IMPLEMENTATION DETAIL, not behavior
   → Move to session-start.sh comments
   → AI doesn't need to see this every response
```

---

**2. Memory Health Detection Logic (Move to hook)**
```markdown
❌ Remove from CLAUDE.md:
"Memory Health Check (v2.2+ - Session Start):
- If you see 'Memory cleanup recommended' → Acknowledge
- If you see 'Memory bloat detected' → STRONGLY recommend"

✅ Hook handles detection, just tells AI the result
   → AI sees: "💡 Memory cleanup recommended"
   → AI responds appropriately (behavior already defined)
```

---

**3. Footer Construction Instructions (Move to hook)**
```markdown
❌ Remove from CLAUDE.md:
"How to construct the footer:
- Read activity count from tool logs
- Read session duration from tmp files
- Read last sync from tmp files
- Check for notifications"

✅ Hook builds footer, AI just displays it
   → Hook injects: "FOOTER_DATA: 108 ops | 6m | ..."
   → AI uses data (doesn't need to know HOW to get it)
```

---

**4. Detailed Examples (Move to docs)**
```markdown
❌ Remove from CLAUDE.md:
"Example with notifications:
🧠 MINI-CODER-BRAIN STATUS
📊 Activity: 149 ops | 🗺️ Map: None | ⚡ Context: Active
[... 10 more lines of example ...]"

✅ AI doesn't need to see examples every response
   → Move to SESSION-START-REFINEMENTS.md
   → AI can read if needed (on-demand)
```

---

### What Goes in session-start.sh (Once Per Session)

#### ✅ Put in session-start.sh Output

**1. Context Data (Project-Specific)**
```bash
# What AI needs to KNOW (data, not behavior)
PROJECT_NAME="TaskMaster Pro"
CURRENT_FOCUS="JWT authentication implementation"
RECENT_ACHIEVEMENTS="User registration, password hashing"
PROFILE="default"
SESSION_ID="sessionstart-1760693716"
```

---

**2. Memory Health Status (Current State)**
```bash
# Computed once, shown once
SESSION_UPDATE_COUNT=13
LAST_CLEANUP_DAYS=8
MEMORY_HEALTH="Needs Cleanup"

# Output to AI:
echo "💡 Memory cleanup recommended (13 updates, 8d since last cleanup)"
```

---

**3. Enhanced Footer Data (Pre-Computed)**
```bash
# Hook computes, AI displays
ACTIVITY_OPS=108
SESSION_DURATION="6m"
LAST_SYNC="1d ago"
TOP_TOOLS="Write(5) Bash(10) Read(3)"

# Output as structured data:
echo "FOOTER_DATA: $ACTIVITY_OPS | $SESSION_DURATION | $LAST_SYNC | $TOP_TOOLS"
```

---

**4. Boot Status (Session Summary)**
```bash
# Concise 4-line summary
echo "🧠 [MINI-CODERBRAIN: ACTIVE] - $PROJECT_NAME"
echo "🎯 Focus: $CURRENT_FOCUS"
echo "📂 Context: .claude/memory/ (loaded)"
echo "🎭 Profile: $PROFILE"
echo "⚡ Ready for development | Session: $SESSION_ID"
```

---

#### ❌ Don't Put in session-start.sh Output

**1. Behavioral Instructions**
```bash
❌ Don't output:
"Remember to prefix every response with [MINI-CODER-BRAIN: ACTIVE]"
"Always show enhanced status footer"

✅ This is behavior (goes in CLAUDE.md)
```

---

**2. Full Memory File Contents**
```bash
❌ Don't output:
cat .claude/memory/productContext.md  # (400 lines)
cat .claude/memory/activeContext.md   # (300 lines)

✅ Files loaded automatically via @-mentions
   Only show KEY DATA (project name, current focus)
```

---

**3. Pattern/Rule Explanations**
```bash
❌ Don't output:
"How to use the memory bank:
- productContext for project overview
- activeContext for current focus
[... 50 more lines ...]"

✅ This is reference material (already in CLAUDE.md)
```

---

## 🎯 Optimized Architecture

### The New Flow

#### Every Response (CLAUDE.md → AI)
```
AI receives:
├── Behavioral rules (how to act)
├── Pattern references (where to look)
├── Command list (what's available)
└── Anti-patterns (what NOT to do)

Token cost: ~300 lines (stable, necessary)
Frequency: Every response (50+ per session)
Purpose: Maintain behavior consistency
```

---

#### Session Start (hook → AI once)
```
AI receives:
├── Project name + current focus (data)
├── Memory health status (computed)
├── Footer metrics (pre-computed)
└── Boot status (4 lines)

Token cost: ~10 lines (minimal, data-only)
Frequency: Once per session
Purpose: Load context data
```

---

#### During Session (conversation history)
```
AI uses:
├── Context from session-start (persists)
├── Behavioral rules from CLAUDE.md (constant)
├── Patterns read on-demand (as needed)
└── User messages + responses (natural flow)

Token cost: Grows naturally
Frequency: Throughout session
Purpose: Normal development work
```

---

## 📊 Token Impact Analysis

### Current (v2.1) - Duplicated

| Component | Size | Frequency | Session Cost |
|-----------|------|-----------|--------------|
| CLAUDE.md (full) | 500 lines | 50 responses | 25,000 lines |
| session-start (full) | 400 lines | 1 time | 400 lines |
| Memory files (duplicated) | 800 lines | 1 time | 800 lines |
| **TOTAL** | | | **26,200 lines** |

**Problems**:
- Session-start instructions sent 50+ times (waste)
- Footer construction shown every time (waste)
- Memory health detection explained repeatedly (waste)

---

### Optimized (v2.2) - Strategic

| Component | Size | Frequency | Session Cost |
|-----------|------|-----------|--------------|
| CLAUDE.md (behavior only) | 300 lines | 50 responses | 15,000 lines |
| session-start (data only) | 10 lines | 1 time | 10 lines |
| Memory files (via @-mentions) | 800 lines | 1 time | 800 lines |
| **TOTAL** | | | **15,810 lines** |

**Benefits**:
- ✅ 40% reduction (26,200 → 15,810 lines)
- ✅ No duplication (each piece of info sent once)
- ✅ Cleaner separation (behavior vs data)
- ✅ Easier maintenance (change in one place)

---

## 🎯 What Goes Where - Complete Reference

### CLAUDE.md - Behavioral Control Document

**Section 1: Project Setup Metadata**
```yaml
✅ KEEP: Project configuration settings
   (uses_git, testing_framework, behavior_profile)

Reason: Affects how AI should behave
```

---

**Section 2: Session Bootstrapping Rules**
```markdown
❌ REMOVE: "On SESSION START, do the following:"
   (All implementation details)

✅ KEEP: "Context Persistence: Once loaded at session start,
         context remains available throughout conversation"

Reason: Behavioral reminder, not implementation
```

---

**Section 3: Behavioral Patterns**
```markdown
✅ KEEP: Pattern library references (on-demand, zero-token)
- @.claude/patterns/pre-response-protocol.md
- @.claude/patterns/context-utilization.md
[...]

❌ REMOVE: Pattern explanations (already in pattern files)

Reason: References are reminders, content is on-demand
```

---

**Section 4: Memory Bank Update Rules**
```markdown
✅ KEEP: High-level rules
- "Append with UTC timestamps, never overwrite"
- "Decisions → decisionLog.md"
- "Progress → progress.md"

❌ REMOVE: Detailed instructions on HOW to update

Reason: Principles stay, implementation details go to patterns
```

---

**Section 5: Universal Working Rules**
```markdown
✅ KEEP: Core guidelines
- "Follow project-specific patterns"
- "Record all technical decisions"
- "Never add co-author attribution"

✅ KEEP: Pattern references (read as needed)

❌ REMOVE: "How to use patterns and rules" (meta-instructions)

Reason: Rules are behavior, meta-explanation is documentation
```

---

**Section 6: Enhanced Status Footer**
```markdown
❌ REMOVE: "How to construct the footer:"
   (Read activity count from tool logs...)

❌ REMOVE: Detailed examples (10+ lines)

✅ KEEP: "Display EXACT footer with notifications"
✅ KEEP: Compact format template (3-4 lines)

Reason: AI needs to display, not compute
```

---

### session-start.sh - Context Data Injection

**Output 1: Boot Status (4 lines)**
```bash
✅ OUTPUT:
🧠 [MINI-CODERBRAIN: ACTIVE] - $PROJECT_NAME
🎯 Focus: $CURRENT_FOCUS
📂 Context: .claude/memory/ (loaded)
🎭 Profile: $PROFILE
⚡ Ready for development | Session: $SESSION_ID

Reason: Essential data AI needs immediately
```

---

**Output 2: Memory Health Warning (if needed)**
```bash
✅ OUTPUT (conditional):
💡 Memory cleanup recommended (13 updates, 8d ago)

Reason: Actionable notification for AI to mention
```

---

**Output 3: Enhanced Footer Data (structured)**
```bash
✅ OUTPUT:
FOOTER_DATA: 108 ops | 6m | 1d sync | Write(5) Bash(10)

Reason: Pre-computed metrics AI just displays
```

---

**Don't Output**:
```bash
❌ Full memory files (already @-mentioned)
❌ Pattern explanations (already in CLAUDE.md)
❌ Behavioral instructions (already in CLAUDE.md)
❌ Detailed examples (documentation, not data)
```

---

## 🎯 Implementation Strategy

### Phase 1: CLAUDE.md Optimization (Priority)

**Remove from CLAUDE.md**:
- [ ] Session-start implementation details (50 lines)
- [ ] Footer construction instructions (30 lines)
- [ ] Memory health detection logic (20 lines)
- [ ] Detailed examples (40 lines)
- [ ] Meta-explanations (20 lines)

**Expected Reduction**: 160 lines → 80 lines per response
**Session Impact**: 8,000 lines saved (50 responses × 160 lines)

---

### Phase 2: session-start.sh Optimization (Already Good)

**Current Output**: ~10 lines (boot status + warning)

✅ **Already optimized** (after v2.2 refinements)
- Concise boot status
- Conditional warnings
- No duplication

**No changes needed** ✅

---

### Phase 3: Documentation Update

**Create New Doc**: CONTEXT-INJECTION-RULES.md
**Purpose**: Explain to maintainers what goes where

**Sections**:
1. Behavioral vs Data (mental model)
2. CLAUDE.md contents (what stays)
3. Hook outputs (what's injected)
4. Anti-patterns (what NOT to do)

---

## 📚 Mental Models for Maintainers

### Model 1: Behavioral vs Data

**Behavior** (CLAUDE.md):
- **Question**: "How should AI act?"
- **Examples**: "Prefix responses", "Show footer", "Don't duplicate"
- **Frequency**: Every response (consistency required)

**Data** (session-start.sh):
- **Question**: "What does AI need to know?"
- **Examples**: Project name, current focus, memory health
- **Frequency**: Once (persists in conversation)

---

### Model 2: Instructions vs Information

**Instructions** (CLAUDE.md):
- "DO this"
- "DON'T do that"
- "ALWAYS show footer"

**Information** (hooks):
- "Project name is X"
- "Current focus is Y"
- "Memory health: Z"

---

### Model 3: Static vs Dynamic

**Static** (CLAUDE.md):
- Doesn't change between projects
- Universal behavioral rules
- Pattern references

**Dynamic** (hooks):
- Changes per project
- Current session state
- Computed metrics

---

## ✅ Success Criteria

### For v2.2 Release

**Token Efficiency**:
- ✅ 40% reduction in per-session token usage
- ✅ No duplication between CLAUDE.md and hooks
- ✅ session-start output < 15 lines

**Behavioral Consistency**:
- ✅ AI behavior unchanged (still follows all rules)
- ✅ Footer still shows correctly
- ✅ Memory warnings still work

**Maintainability**:
- ✅ Clear separation (behavior vs data)
- ✅ Single source of truth (no duplicates)
- ✅ Easy to update (change in one place)

---

## 🚀 v2.2 Vision

### The Perfect Balance

**CLAUDE.md**: Behavioral control center
- Compact (300 lines vs 500 lines)
- Focused (behavior only)
- No duplication

**session-start.sh**: Context injector
- Minimal (10 lines vs 400 lines)
- Data-only (no instructions)
- Pre-computed metrics

**Pattern Library**: On-demand reference
- Zero-token (read when needed)
- Comprehensive (4,700 lines available)
- Modular (update independently)

**Result**:
- 40% token reduction
- Perfect separation of concerns
- Maintainable architecture

---

## 📊 Key Insights

### 1. Token Budget is Precious
Every line in CLAUDE.md costs 50+ tokens per session (sent with every response).
Every line in session-start costs 1 token (sent once).

**Optimization**: Move anything that doesn't need repetition to session-start.

---

### 2. AI Forgets Behavior, Not Data
AI needs constant behavioral reminders ("show footer", "don't duplicate").
AI remembers data from conversation history (project name, current focus).

**Strategy**: Behavior in CLAUDE.md, data in hooks.

---

### 3. Separation = Maintainability
When behavior and data are mixed, changes affect everything.
When separated, changes are surgical.

**Benefit**: Update footer format → change hook only, CLAUDE.md unchanged.

---

### 4. The LLM Only Needs What It Needs
Detailed examples are for HUMANS (documentation).
Concise instructions are for LLM (behavior).

**Principle**: Show LLM WHAT to do, not HOW (implementation is in hooks).

---

## 🎯 Final Recommendations

### For v2.2 Release

**Priority 1**: Optimize CLAUDE.md (remove 160 lines)
- Remove session-start instructions
- Remove footer construction details
- Remove memory health detection logic
- Keep behavioral rules only

**Priority 2**: Document strategy (this document)
- Create CONTEXT-INJECTION-RULES.md
- Update maintainer guidelines
- Add to CHANGELOG

**Priority 3**: Test thoroughly
- Verify AI behavior unchanged
- Verify footer still works
- Verify warnings still show
- Measure token savings

---

### For Future Maintainers

**Golden Rule**: Ask yourself:
- "Does AI need this EVERY response?" → CLAUDE.md
- "Does AI need this ONCE per session?" → Hook
- "Does AI need this SOMETIMES?" → Pattern (on-demand)

**Anti-Pattern**: Don't explain HOW in CLAUDE.md, just WHAT and WHEN.

---

**This is the key to v2.2 success**: Intelligent, automatic, token-efficient context distribution! 🚀
