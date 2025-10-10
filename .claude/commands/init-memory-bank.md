---
description: Initialize memory bank with auto-populated project context
argument-hint: "[--dry-run]"
allowed-tools: Read(*), Write(*), Bash(git:*, cat:*, ls:*)
---

# Init Memory Bank — Smart Context Initialization

Scans your existing project and automatically populates all memory bank files with real project data. No more manual template filling!

## Purpose

The `/init-memory-bank` command intelligently analyzes your project and creates fully populated context files:
- **productContext.md** - Project name, tech stack, features (from package.json, README, Cargo.toml)
- **progress.md** - Recent work (from git commit history)
- **systemPatterns.md** - Coding patterns (from code analysis)
- **decisionLog.md** - Technical decisions (from git history + code comments)
- **activeContext.md** - Current state (from git status + recent commits)

## Usage

```bash
# Initialize memory bank (auto-populates all files)
/init-memory-bank

# Dry run (preview what would be populated, no changes)
/init-memory-bank --dry-run
```

## What Gets Populated

### 1. productContext.md
**Sources**:
- `package.json` / `Cargo.toml` / `pyproject.toml` → Project name, description, dependencies
- `README.md` → Project overview, features, goals
- File structure analysis → Frontend/backend/database detection
- Git remote → Repository URL

**Example Output**:
```markdown
# Product Context — my-awesome-app

**Last Updated**: 2025-10-06
**Project Type**: Full-stack Web Application

## Project Overview
**my-awesome-app** — A modern task management application with real-time collaboration

### Core Features
- Real-time task updates with WebSocket
- User authentication and authorization
- Team collaboration features
- Mobile-responsive design

### Technology Stack
- **Frontend**: React 18, TypeScript, Tailwind CSS
- **Backend**: Node.js, Express, Prisma
- **Database**: PostgreSQL
- **Infrastructure**: Docker, Vercel
```

### 2. progress.md
**Sources**:
- Recent git commits (last 7 days) → Completed tasks
- Git branches → In-progress work
- TODO comments in code → Pending tasks

**Example Output**:
```markdown
# Development Progress — my-awesome-app

**Last Updated**: 2025-10-06
**Current Phase**: Active Development

## CURRENT SPRINT
**Overall Progress**: 65% Complete

### ✅ COMPLETED (Last 7 Days)
- **2025-10-05** ✅ Implemented user authentication with JWT
- **2025-10-04** ✅ Created task CRUD API endpoints
- **2025-10-03** ✅ Set up Prisma schema and migrations

### 🔄 IN PROGRESS (Today)
- **2025-10-06** 🔄 Real-time updates with WebSocket
- **2025-10-06** 🔄 Team collaboration features

### ⏳ PENDING (Discovered from TODO comments)
- Add email verification flow
- Implement task filtering and search
- Create admin dashboard
```

### 3. systemPatterns.md
**Sources**:
- Code analysis → Patterns in existing code
- ESLint/Prettier configs → Code style rules
- Test file patterns → Testing conventions
- Git commit messages → Commit style

**Example Output**:
```markdown
# System Patterns — my-awesome-app

**Last Updated**: 2025-10-06

## Code Style Patterns
- Functional React components with TypeScript
- Zod validation for API inputs
- Custom hooks in `src/hooks/` directory

## API Patterns
- REST endpoints return `{data, error}` structure
- Prisma for database operations
- JWT authentication on protected routes

## Testing Patterns
- Vitest for unit tests
- Tests colocated in `__tests__/` folders
- Mock external APIs in tests

## Commit Patterns
- Conventional commits: feat:/fix:/refactor:
- Imperative mood, 50 char max
- Detailed body for complex changes
```

### 4. decisionLog.md
**Sources**:
- Git commit messages with "Decision:" or "ADR:" → Extracted decisions
- Major dependency additions → Technology choices
- Architecture comments in code

**Example Output**:
```markdown
# Decision Log — my-awesome-app

**Last Updated**: 2025-10-06

## [2025-10-05] Use JWT for Authentication
**Context**: Need secure user authentication
**Decision**: Implement JWT tokens with refresh token rotation
**Rationale**: Industry standard, works well with REST APIs, scalable
**Consequences**: Need to implement token refresh logic, store refresh tokens securely

## [2025-10-03] Choose Prisma as ORM
**Context**: Need type-safe database access layer
**Decision**: Use Prisma instead of TypeORM
**Rationale**: Better TypeScript support, excellent migrations, great DX
**Consequences**: Learning curve for team, new migration workflow
```

### 5. activeContext.md
**Sources**:
- Git status → Uncommitted changes
- Current branch name → Active feature
- Recent commits (last 24 hours) → Today's focus

**Example Output**:
```markdown
# Active Context — my-awesome-app

**Last Updated**: 2025-10-06
**Current Sprint**: Sprint 3

## 🎯 Current Focus
Implementing real-time task updates with WebSocket integration

## ✅ Recent Achievements
- Completed user authentication system (JWT-based)
- Created full CRUD API for tasks
- Set up Prisma with PostgreSQL

## 🚀 Next Priorities
1. Complete WebSocket integration for real-time updates
2. Add team collaboration features
3. Implement task filtering and search

## 🔒 Current Blockers
None detected

## 🧠 Key Insights
- Authentication system is production-ready
- Need to add rate limiting to API endpoints
- Consider adding Redis for WebSocket scaling
```

## Initialization Process

1. **Detect Project Type**
   - Scan for package.json, Cargo.toml, requirements.txt, etc.
   - Identify primary language and framework

2. **Extract Project Metadata**
   - Project name, description from config files
   - Parse README.md for overview
   - Detect dependencies and tech stack

3. **Analyze Git History**
   - Recent commits → Completed work
   - Branches → In-progress features
   - Commit messages → Patterns and decisions

4. **Scan Codebase Structure**
   - File organization patterns
   - Testing conventions
   - Code style from configs

5. **Generate Memory Files**
   - Populate all 5 memory bank files
   - Use real data, no placeholders
   - Add timestamps and metadata

6. **Verify and Save**
   - Show summary of populated data
   - Save to `.claude/memory/`
   - Ready for use immediately

## Benefits

- ✅ **Zero Manual Work** - Fully automated context creation
- ✅ **Real Data** - No [PROJECT_NAME] placeholders
- ✅ **Instant Context** - Start with full project awareness
- ✅ **Git-Aware** - Understands your project history
- ✅ **Pattern Detection** - Learns from existing code

## When to Use

### First Installation
```bash
# Just installed Mini-CoderBrain on existing project
/init-memory-bank
# Memory bank now populated with real project data!
```

### After Major Changes
```bash
# Switched tech stack, major refactor, or new features added
/init-memory-bank
# Re-scans and updates memory bank
```

### Dry Run Preview
```bash
# Want to see what would be populated first
/init-memory-bank --dry-run
# Shows preview without making changes
```

## Output

```
🔍 Scanning project structure...
✅ Detected: Node.js + TypeScript project

📦 Analyzing package.json...
✅ Found: my-awesome-app v1.2.0

📄 Reading README.md...
✅ Extracted project overview and features

🔄 Analyzing git history...
✅ Found 47 commits in last 30 days
✅ Detected 3 active branches

🔍 Analyzing code patterns...
✅ Detected: React + TypeScript patterns
✅ Found: Zod validation, Vitest testing

📝 Populating memory bank files...
✅ productContext.md (154 lines) ← Real project data
✅ progress.md (73 lines) ← Recent commits + TODO items
✅ systemPatterns.md (89 lines) ← Detected patterns
✅ decisionLog.md (31 lines) ← Git history decisions
✅ activeContext.md (67 lines) ← Current state

🎯 Memory Bank Initialized Successfully!
📁 All files saved to .claude/memory/
⚡ Ready for development with full context awareness!

Next: Continue working - Claude has full project context now!
```

## Technical Notes

- Requires git repository (for history analysis)
- Safe to run multiple times (appends, doesn't overwrite)
- Creates backups before modifying existing files
- Works offline (no external APIs)
- Respects .gitignore (doesn't scan ignored files)

## Edge Cases

### No Git Repository
If project has no git history:
- Still populates from config files (package.json, README)
- Skips git-dependent features (commit history, branches)
- Minimal but functional memory bank created

### Empty README
If no README.md found:
- Uses project name from config
- Creates basic description from file structure
- User can enhance manually later

### Large Repositories
For repos with >10,000 commits:
- Analyzes only recent commits (last 90 days)
- Uses git log --since for efficiency
- Focuses on relevant history only

---

**Related Commands**: `/memory-sync`, `/context-update`
**Frequency**: Run once at installation, or after major changes
**Impact**: High - creates instant project awareness
