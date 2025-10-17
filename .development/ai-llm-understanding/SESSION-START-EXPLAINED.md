# Session-Start Hook Explained

**Purpose**: Complete guide to how the session-start hook works in real projects

**Audience**: Users installing Mini-CoderBrain in their projects

---

## 📋 What You Saw

When you saw this in your message:

```
<session-start-hook>
# Product Context — [PROJECT_NAME]
...
[LOTS OF PLACEHOLDERS]
...
🧠 [MINI-CODERBRAIN: ACTIVE] - PROJECT_NAME
💡 Memory cleanup recommended (12 session updates)
</session-start-hook>
```

**What This Is**: This is the **raw output** from the session-start hook that runs automatically when Claude Code starts.

---

## 🎯 How It Works: Step-by-Step

### Step 1: Session Starts (Automatic)

When you start Claude Code in your project:

```bash
# User opens Claude Code
# → session-start hook runs automatically (invisible to user)
```

The hook (`.claude/hooks/session-start.sh`):
1. Checks if memory bank exists
2. Loads 3 core files (productContext, activeContext, systemPatterns)
3. Generates boot status
4. Injects into conversation

### Step 2: Memory Files Are Loaded

The hook reads these files:

| File | What It Contains |
|------|------------------|
| **productContext.md** | Project name, tech stack, features |
| **activeContext.md** | Current focus, recent work, blockers |
| **systemPatterns.md** | Coding conventions, testing patterns |

**IMPORTANT**: These files contain REAL data in real projects, not placeholders!

### Step 3: Boot Status Is Generated

The hook outputs a 4-line boot status to Claude:

```
🧠 [MINI-CODERBRAIN: ACTIVE] - YourProjectName
🎯 Focus: Implementing authentication feature
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default
⚡ Ready for development | Session: sessionstart-1760693716
```

This is what **Claude sees** and uses for context.

### Step 4: Claude Responds

Claude reads the boot status and responds to the user with session overview.

---

## 🔍 Real Project vs Mini-CoderBrain Project

### In Mini-CoderBrain (What You're Seeing Now)

**Problem**: Mini-CoderBrain's memory files are TEMPLATES with placeholders:

```markdown
# Product Context — [PROJECT_NAME]  ← Placeholder!
**Project Type**: [AUTO_DETECTED]   ← Placeholder!

## Project Overview
**[PROJECT_NAME]** — [ONE_LINE_DESCRIPTION]  ← Placeholder!
```

**Why?** Mini-CoderBrain is a tool for OTHER projects. Its own memory files are templates that get copied to user projects.

**What You See**:
- `[PROJECT_NAME]` not filled
- `[AUTO_DETECTED]` not filled
- Generic template structure

---

### In Real User Projects (How It's SUPPOSED to Work)

When a user installs Mini-CoderBrain in their project and runs `/init-memory-bank`:

**Before `/init-memory-bank`**: Same as mini-coder-brain (templates)

**After `/init-memory-bank`**: Memory files are POPULATED with real data:

```markdown
# Product Context — TaskMaster Pro

**Last Updated**: 2025-10-17 09:30:00 UTC
**Project Type**: Full-Stack Web Application

## Project Overview
**TaskMaster Pro** — Advanced task management SaaS with AI-powered prioritization

### Core Features
- Real-time collaborative task boards
- AI-powered task prioritization
- Team performance analytics
- Mobile-first responsive design

### Technology Stack
- **Frontend**: Next.js 14 + TypeScript + Tailwind CSS
- **Backend**: Node.js + Express + Prisma ORM
- **Database**: PostgreSQL 15
- **Infrastructure**: Vercel + Supabase
```

**Now the placeholders are GONE** and filled with REAL project data!

---

## 📊 Placeholder Filling Process

### How Placeholders Get Filled

#### Method 1: `/init-memory-bank` (Automatic Detection)

```bash
# User runs command:
/init-memory-bank
```

**What Happens**:
1. Hook scans project files (package.json, requirements.txt, etc.)
2. Detects tech stack automatically
3. Analyzes folder structure
4. Populates memory files with detected data
5. Asks user to fill in missing details

**Auto-Detected Fields**:
- `[PROJECT_TYPE]` → Detected from structure (web app, CLI tool, library)
- `[FRAMEWORK/LIBRARY]` → Detected from dependencies
- `[DATABASE]` → Detected from packages/config
- `[DETECTED_FRONTEND_PATH]` → Found by scanning folders
- `[DETECTED_BACKEND_PATH]` → Found by scanning folders

**User-Provided Fields**:
- `[PROJECT_NAME]` → User enters (e.g., "TaskMaster Pro")
- `[ONE_LINE_DESCRIPTION]` → User enters
- `[CORE_FEATURES]` → User lists features
- Development goals, success metrics

#### Method 2: Manual Editing

User can directly edit memory files:

```bash
# Open in editor:
code .claude/memory/productContext.md

# User replaces placeholders:
[PROJECT_NAME] → TaskMaster Pro
[ONE_LINE_DESCRIPTION] → Advanced task management SaaS
```

#### Method 3: AI-Assisted (During Development)

As Claude works on the project, it updates memory files:

```
User: "Add authentication feature"
Claude: [Implements feature, updates activeContext.md]
        "Current Focus: Authentication implementation"
```

---

## 🧠 What Happens in Each File

### productContext.md — Project Overview (Static)

**Placeholders**:
- `[PROJECT_NAME]` → Your project name
- `[ONE_LINE_DESCRIPTION]` → Brief description
- `[FEATURE_1/2/3]` → Core features list
- `[FRAMEWORK/LIBRARY]` → Tech stack
- `[DETECTED_*_PATH]` → Folder paths

**When Filled**: During `/init-memory-bank` and manual editing

**Example (Real Project)**:
```markdown
# Product Context — TaskMaster Pro

**Last Updated**: 2025-10-17 09:30:00 UTC
**Project Type**: Full-Stack Web Application

### Core Features
- Real-time collaborative task boards
- AI-powered task prioritization
- Team performance analytics

### Technology Stack
- **Frontend**: Next.js 14 + TypeScript
- **Backend**: Node.js + Express
- **Database**: PostgreSQL 15
```

---

### activeContext.md — Current Work (Dynamic)

**Placeholders**:
- `[PROJECT_NAME]` → Your project name
- `[SPRINT_NAME]` → Current sprint/phase
- `[INSIGHT_1/2/3]` → Key learnings (filled during work)
- `[TASK_1/2/3]` → Active todos (filled during work)

**When Filled**:
- Initial: `/init-memory-bank`
- Updates: Automatically during development
- Manual: User edits or `/context-update`

**Example (Real Project)**:
```markdown
# Active Context — TaskMaster Pro

**Current Sprint**: Sprint 12 - Authentication & Security

## 🎯 Current Focus
Implementing JWT-based authentication with refresh tokens and role-based access control

## ✅ Recent Achievements
- User registration with email verification
- Password hashing with bcrypt
- Login endpoint with token generation

## 🚀 Next Priorities
1. Add token refresh mechanism
2. Implement role-based permissions
3. Write integration tests for auth flow

## 🔒 Current Blockers
- Need to decide between Redis vs in-memory for token storage
```

**No More Placeholders!** Real work tracked here.

---

### systemPatterns.md — Conventions (Semi-Static)

**Placeholders**:
- `[PRINCIPLE_1/2/3]` → Architectural principles
- `[STRUCTURE_PATTERN]` → File organization approach
- `[FRAMEWORK]` → Testing framework
- `[GIT_STRATEGY]` → Branching model
- `[CI/CD]` → CI/CD tool

**When Filled**:
- Initial: `/init-memory-bank` detects testing framework, build tools
- Manual: User documents conventions
- During work: Claude learns patterns, updates file

**Example (Real Project)**:
```markdown
# System Patterns — TaskMaster Pro

## Architectural Principles
- **API-First**: All features exposed via REST API
- **Mobile-First**: UI designed for mobile, scales to desktop
- **Test-Driven**: Tests written before implementation

## Testing Patterns
- **Testing Framework**: Vitest + React Testing Library
- **Test Structure**: Co-located __tests__/ folders
- **Coverage Requirements**: 80% minimum

## Development Workflow
- **Version Control**: Git + GitHub
- **Branching**: Feature branches (feature/*, fix/*)
- **Code Review**: Required for all PRs
```

---

## 🚀 Complete Flow in Real Project

### Scenario: New Project "TaskMaster Pro"

#### Day 1: Installation

```bash
# User installs Mini-CoderBrain
cp -r .claude/ ~/projects/taskmaster-pro/
cp CLAUDE.md ~/projects/taskmaster-pro/

# Memory files copied (still have placeholders)
```

#### Day 1: Initialization

```bash
# User runs initialization
/init-memory-bank
```

**What Happens**:
1. Scans `package.json` → Detects Next.js, TypeScript, Prisma
2. Scans folders → Finds `src/app/`, `src/components/`, `prisma/`
3. Prompts user: "What's your project name?" → TaskMaster Pro
4. Prompts user: "Describe your project" → Advanced task management SaaS
5. **Fills all placeholders automatically**
6. Saves to memory files

**Result**: productContext.md now has REAL data:
```markdown
# Product Context — TaskMaster Pro
**Project Type**: Full-Stack Web Application

### Technology Stack
- **Frontend**: Next.js 14 + TypeScript + Tailwind CSS
- **Backend**: Node.js + Express + Prisma ORM
- **Database**: PostgreSQL 15
```

#### Day 2: First Development Session

```bash
# User starts Claude Code
# → session-start hook runs automatically
```

**Boot Status Shown**:
```
🧠 [MINI-CODERBRAIN: ACTIVE] - TaskMaster Pro
🎯 Focus: Project initialization complete
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default
⚡ Ready for development
```

**User**: "Add authentication feature"

**Claude**:
- Reads productContext.md → Sees Next.js + Prisma
- Reads systemPatterns.md → Sees testing requirements
- Implements auth with Next.js patterns
- Writes tests (Vitest)
- Updates activeContext.md:
  ```markdown
  ## 🎯 Current Focus
  Implementing JWT authentication with Prisma
  ```

#### Day 3+: Ongoing Development

Every session start:
1. Hook loads memory files (NOW WITH REAL DATA)
2. Claude sees current focus, recent work
3. User continues from where they left off
4. Memory files update automatically

---

## 🎯 Why Mini-CoderBrain's Own Files Have Placeholders

**Mini-CoderBrain is special** because:

1. **It's a TOOL, not an APPLICATION**
   - It doesn't have "features" to track
   - It's developed TO BE INSTALLED in other projects

2. **Its memory files are TEMPLATES**
   - Copied to user projects during installation
   - Filled in by `/init-memory-bank` in user projects

3. **Its OWN development is META**
   - We're building the memory system ITSELF
   - Not using it for typical app development (yet)

**Should We Fill Mini-CoderBrain's Own Placeholders?**

**YES! We should!** Because:
- Mini-CoderBrain IS a real project
- We're doing real development (v2.1, marketing, testing)
- We should dogfood our own tool properly

---

## 🔧 Refinement Opportunities

### 1. Session-Start Output Optimization

**Current (Verbose)**:
- Shows full productContext template (100+ lines)
- Shows full systemPatterns template (80+ lines)
- Total: ~400 lines of placeholders

**Better (Concise)**:
- Load files silently (no output)
- Show ONLY 4-line boot status
- Total: ~10 lines

**Implementation**: Modify `.claude/hooks/session-start.sh`:
```bash
# Instead of cat-ing entire files
# Just load silently and show boot status
```

### 2. Placeholder Detection

**Add Smart Detection**:
```bash
# In session-start.sh
if grep -q "\[PROJECT_NAME\]" "$MB/productContext.md"; then
    echo "⚠️ Memory bank not initialized. Run /init-memory-bank"
    exit 0
fi
```

### 3. Progressive Disclosure

**Show Context Based on State**:
- **Not Initialized**: Show setup prompt only
- **Initialized**: Show full boot status
- **Active Development**: Show current focus + recent work

---

## 📚 Summary

| Aspect | Mini-CoderBrain Project | Real User Project |
|--------|------------------------|-------------------|
| **Memory Files** | Templates with placeholders | Filled with real data |
| **When Filled** | Never (it's the tool itself) | During `/init-memory-bank` |
| **Session Start** | Shows placeholders (confusing) | Shows real project context |
| **Purpose** | Develop the tool | Use the tool |
| **What To Do** | Fill our own placeholders! | Already filled by init |

---

## ✅ What We Should Do Next

1. **Run `/init-memory-bank` on mini-coder-brain itself** to fill placeholders
2. **Optimize session-start hook** to show less verbose output
3. **Add placeholder detection** to warn users who haven't initialized
4. **Document this in README** so users understand the setup flow

---

**Key Insight**: The session-start output you saw is NORMAL for uninitialized projects, but SHOULD NOT be seen in production use after `/init-memory-bank` runs!
