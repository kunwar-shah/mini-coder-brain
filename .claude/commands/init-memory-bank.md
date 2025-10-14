---
description: Initialize memory bank with auto-populated project context (MANDATORY on first install)
argument-hint: "[--dry-run] [--docs-path <path>]"
allowed-tools: Read(*), Write(*), Edit(*), Glob(*), Grep(*), Bash(git:*, ls:*, find:*, wc:*)
---

# Init Memory Bank — Smart Context Initialization

**⚠️ MANDATORY**: Run this command immediately after installing mini-coder-brain!

You are an intelligent initialization wizard. Your job is to populate `.claude/memory/` files with high-quality project context by:
1. Detecting project type (empty/existing/complex)
2. Auto-scanning code, configs, and documentation
3. Interactive prompting for missing critical info
4. Generating complete, accurate memory bank files

## Execution Steps (FOLLOW IN ORDER)

### STEP 1: Parse Arguments

Check for arguments:
- `--dry-run` → Preview mode (show what would be done, don't write files)
- `--docs-path <path>` → Custom documentation folder to scan

### STEP 2: Detect Project Type

Scan current directory and classify:

**Type A: Empty Project** (< 10 files, no package.json/requirements.txt/etc)
- Behavior: Interactive wizard, create from scratch
- Prompt user for: name, description, tech stack, goals

**Type B: Existing Project - Simple** (has code, no docs folder)
- Behavior: Auto-detect + confirm with user
- Scan: package.json, README.md, git history, code structure

**Type C: Existing Project - Complex** (has code + documentation)
- Behavior: Auto-detect + auto-read docs + minimal prompts
- Scan: everything from Type B + docs folder

**Detection Logic**:
```bash
# Check for project config files
has_config=$(ls package.json requirements.txt Cargo.toml go.mod 2>/dev/null | wc -l)

# Check for documentation folder
has_docs=$(ls -d docs/ documentation/ .docs/ 2>/dev/null | wc -l)

# Count total files
file_count=$(find . -maxdepth 2 -type f 2>/dev/null | wc -l)

# Classify
if [ $file_count -lt 10 ] && [ $has_config -eq 0 ]; then
  project_type="empty"
elif [ $has_docs -gt 0 ]; then
  project_type="complex"
else
  project_type="simple"
fi
```

### STEP 3: Execute Type-Specific Workflow

#### For Type A (Empty Project):

1. **Interactive Prompts** (ask user):
```
🎯 Let's set up your project context!

What is your project name?
→ [user input]

What type of application are you building? (1-2 sentences)
→ [user input]

What technology stack do you plan to use? (e.g., "Next.js, TypeScript, Prisma, PostgreSQL")
→ [user input]

What are the core features? (3-5 features, comma-separated)
→ [user input]

What is your primary development goal? (e.g., "MVP in 2 months", "Production-ready SaaS")
→ [user input]

Do you have technical documentation? (path or "none")
→ [user input or none]
```

2. **Generate Files**:
- Create productContext.md with user inputs
- Create systemPatterns.md with tech stack defaults
- Create activeContext.md with "Project initialization" as focus
- Create progress.md with "Planning phase"
- Create decisionLog.md (empty, ready for use)

3. **Output**:
```
✅ Project context initialized!
📝 Next: Start building! I'll help you implement features with full context awareness.
```

#### For Type B (Existing - Simple):

1. **Auto-Detect** (scan files):
   - `package.json` / `Cargo.toml` / `requirements.txt` → project name, dependencies
   - `README.md` → project description, features
   - Git history (last 30 days) → recent work, patterns
   - Code structure → frontend/backend/database paths
   - Test files → testing framework
   - Config files → linter, formatter detection

2. **Show Detection Summary**:
```
🔍 Project Analysis Complete!

Detected:
  Name: my-awesome-app
  Type: Node.js + TypeScript
  Tech Stack: React 18, Express, Prisma, PostgreSQL
  Structure: Frontend (src/), Backend (api/), Database (prisma/)
  Recent Activity: 47 commits in 30 days
  Testing: Vitest detected

Is this correct? (yes/no/edit)
→ [wait for user confirmation]
```

3. **Prompt for Missing Critical Info**:
```
I couldn't detect these items. Please provide:

What are your core features? (3-5 features)
→ [user input]

What is your current development goal?
→ [user input]

Do you have documentation I should read? (path or "none")
→ [user input]
```

4. **Generate Files** with detected + user-provided info

#### For Type C (Existing - Complex):

1. **Auto-Detect** (everything from Type B)

2. **Auto-Read Documentation**:

Scan for common doc files:
```bash
# Default docs to read
docs=(
  "README.md"
  "docs/SRS.md"
  "docs/ARCHITECTURE.md"
  "docs/API.md"
  "docs/TECHNICAL_SPEC.md"
  "ARCHITECTURE.md"
  "SRS.md"
)

# If --docs-path provided, scan that folder
if [ -n "$docs_path" ]; then
  # Find all .md files in docs path
  find "$docs_path" -name "*.md" -o -name "*.txt"
fi
```

For each found doc:
- Read file using Read tool
- Extract relevant sections:
  - Features → productContext.md
  - Architecture → systemPatterns.md
  - Tech stack → productContext.md
  - Decisions → decisionLog.md

3. **Show Integration Summary**:
```
📚 Documentation Analysis Complete!

Read files:
  ✅ README.md (89 lines) → Project overview
  ✅ docs/SRS.md (234 lines) → Features & requirements
  ✅ docs/ARCHITECTURE.md (156 lines) → System design
  ✅ docs/API.md (178 lines) → API structure

Extracted:
  → 12 core features
  → 8 technical decisions
  → Complete tech stack description
  → Architecture patterns

Context Quality: 95% (Optimal)

Proceed with initialization? (yes/no)
→ [wait for user confirmation]
```

4. **Generate Files** with full integration

### STEP 4: Generate project-structure.json

Auto-detect and create project structure file:

```json
{
  "detected": true,
  "timestamp": "2025-10-14T10:30:00Z",
  "structure": {
    "frontend": ["src/", "app/", "components/"],
    "backend": ["api/", "server/", "backend/"],
    "database": ["prisma/", "migrations/", "db/"],
    "tests": ["__tests__/", "tests/", "test/"],
    "docs": ["docs/", "documentation/"],
    "config": ["package.json", "tsconfig.json", "Cargo.toml"]
  },
  "languages": ["typescript", "javascript"],
  "frameworks": ["react", "express", "prisma"]
}
```

Save to `.claude/memory/project-structure.json`

### STEP 5: Validate Context Quality

Check minimum requirements:
- ✅ Project name defined (not `[PROJECT_NAME]`)
- ✅ Tech stack has 3+ items
- ✅ Core features has 2+ items
- ✅ Architecture or structure defined

Calculate quality score:
```
Base: 40%
+ Project name: +10%
+ Description: +10%
+ Tech stack (3+): +15%
+ Core features (2+): +15%
+ Architecture: +10%
+ Documentation read: +20%
+ Git history: +10%
+ Testing info: +5%
+ Patterns detected: +5%
```

Show result:
```
📊 Context Quality: 85% (Recommended)

✅ Project name: my-awesome-app
✅ Tech stack: 5 technologies
✅ Core features: 4 features
✅ Architecture: Defined
⚠️  Documentation: Basic (consider adding SRS/technical docs)

Ready for development!
```

### STEP 6: Update CLAUDE.md Metadata

Update the Project Setup Metadata section in CLAUDE.md:

```yaml
uses_git: true              # (detected from .git/)
git_host: github            # (detected from remote)
repository_url: "..."       # (from git remote)
uses_docker: true           # (detected Dockerfile)
testing_framework: "vitest" # (detected)
# ... etc
```

### STEP 7: Output Summary

```
🎉 Memory Bank Initialized Successfully!

📊 Summary:
   Project Type: Existing - Complex
   Context Quality: 95% (Optimal)
   Files Created: 5
   Documentation Read: 3 files
   Auto-detected: Tech stack, structure, patterns

📁 Memory Bank Files:
   ✅ productContext.md (187 lines)
   ✅ systemPatterns.md (134 lines)
   ✅ activeContext.md (89 lines)
   ✅ progress.md (76 lines)
   ✅ decisionLog.md (45 lines)
   ✅ project-structure.json (auto-generated)

🚀 Next Steps:
   1. Review .claude/memory/productContext.md
   2. Run /map-codebase for instant file access
   3. Start developing with full context awareness!

⚡ Mini-CoderBrain is now active and ready!
```

### STEP 8: Dry-Run Mode

If `--dry-run` flag detected:
- DO NOT write any files
- Show preview of what would be written
- Display detection results
- Show quality score
- Exit with instructions to run without --dry-run

## Implementation Notes

- Use Glob to find files efficiently
- Use Grep to search for patterns in code
- Use Read to read documentation files
- Use Write to create new memory files
- Use Edit if files already exist (append, don't overwrite)
- Always show progress with emoji indicators
- Be conversational and helpful
- Validate all inputs
- Handle errors gracefully

## Error Handling

- No git repo → Skip git analysis, use file scan only
- No README → Prompt user for description
- No docs → Rely on auto-detection + user input
- Empty project → Interactive wizard only
- Permission errors → Show clear error message

## Purpose

The `/init-memory-bank` command intelligently analyzes your project and creates fully populated context files:
- **productContext.md** - Project name, tech stack, features (from package.json, README, Cargo.toml)
- **progress.md** - Recent work (from git commit history)
- **systemPatterns.md** - Coding patterns (from code analysis)
- **decisionLog.md** - Technical decisions (from git history + code comments)
- **activeContext.md** - Current state (from git status + recent commits)

## Usage

```bash
# MANDATORY: Initialize memory bank (auto-populates all files)
/init-memory-bank

# With custom documentation path (highly recommended!)
/init-memory-bank --docs-path ./docs

# Dry run (preview what would be populated, no changes)
/init-memory-bank --dry-run

# Full setup with docs
/init-memory-bank --docs-path ./documentation --dry-run
```

## Critical: Context Quality

Mini-CoderBrain requires quality context to work at 100% effectiveness:

**🔴 MANDATORY (Must Provide):**
- Project name & description
- Technology stack (3+ items)
- Core features (2+ items)

**🟡 HIGHLY RECOMMENDED (80%+ accuracy):**
- Path to SRS, Technical Specs, Architecture docs
- Existing project documentation
- Link to requirements document

**🟢 OPTIMAL (100% effectiveness):**
- Complete SRS with all requirements
- Architecture diagrams and explanations
- API documentation
- Decision history

**💡 TIP**: Use `--docs-path` to point to your documentation folder. Claude will read and integrate all relevant docs automatically!

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
