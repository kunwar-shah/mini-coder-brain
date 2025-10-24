---
description: Initialize memory bank with auto-populated project context (MANDATORY on first install)
argument-hint: "[--dry-run] [--docs-path <path>]"
allowed-tools: Read(*), Write(*), Edit(*), Glob(*), Grep(*), Bash(git:*, ls:*, find:*, wc:*, grep:*)
---

# Init Memory Bank — Smart Context Initialization

**⚠️ MANDATORY**: Run this command immediately after installing mini-coder-brain!

**CRITICAL INSTRUCTION**: You MUST complete ALL 8 steps below IN EXACT ORDER. DO NOT SKIP any step. DO NOT improvise. DO NOT use shell scripts. ONLY use Read, Write, Glob, Grep, Bash tools as specified.

---

## STEP 1: Parse Arguments - MANDATORY

**ACTION**: Check if user provided arguments

**DETECT**:
- If message contains `--dry-run` → Set DRY_RUN=true (preview mode, don't write files)
- If message contains `--docs-path <path>` → Extract path, set DOCS_PATH=<path>
- If neither → Set DRY_RUN=false, DOCS_PATH=""

**OUTPUT**: Tell user which mode activated

---

## STEP 2: Detect Project Type - MANDATORY

**YOU MUST execute these Bash commands**:

```bash
# Check for traditional package managers
ls package.json requirements.txt Cargo.toml go.mod composer.json Gemfile pom.xml 2>/dev/null | wc -l

# Check for documentation folder
ls -d docs/ documentation/ .docs/ 2>/dev/null | wc -l

# Count total files
find . -maxdepth 2 -type f 2>/dev/null | wc -l

# Count shell scripts (for Bash projects)
find . -maxdepth 3 -name "*.sh" -type f 2>/dev/null | wc -l

# Count markdown files (for doc projects)
find . -maxdepth 2 -name "*.md" -type f 2>/dev/null | wc -l
```

**CLASSIFICATION LOGIC** (YOU MUST FOLLOW):
- **If** file_count < 10 AND no package manager → Type A (Empty)
- **Else If** has docs folder → Type C (Complex)
- **Else If** has package manager → Type B (Simple)
- **Else If** sh_count > 5 → Type B-Bash (Shell project)
- **Else** → Type B (Unknown/Generic)

**OUTPUT**: "✅ Detected: [TYPE] project"

---

## STEP 3: Extract Project Name - MANDATORY

**TRY IN ORDER** (stop at first success):

1. **If package.json exists** → Use Bash: `cat package.json | grep '"name"' | head -1`
2. **If Cargo.toml exists** → Use Bash: `grep '^name =' Cargo.toml | head -1`
3. **If README.md exists** → Use Read tool, extract first `# Title` line
4. **Fallback** → Use Bash: `basename $(pwd)`

**STORE RESULT**: PROJECT_NAME variable

**OUTPUT**: "📦 Project: [PROJECT_NAME]"

---

## STEP 4: Extract Description - MANDATORY

**TRY IN ORDER**:

1. **If package.json exists** → Use Bash: `cat package.json | grep '"description"'`
2. **If README.md exists** → Use Read tool on README.md
   - Find lines 2-10
   - Look for first non-header, non-empty line
   - Exclude lines starting with `#`, `[`, `!`, or empty lines
3. **Fallback** → Use: "A software development project"

**STORE RESULT**: DESCRIPTION variable

**OUTPUT**: "📄 Description: [first 60 chars]..."

---

## STEP 5: Extract Features from README - MANDATORY

**YOU MUST USE Read TOOL** on README.md if it exists:

**SEARCH FOR** (in order of preference):
1. Section with header `## Core Features` or `## Features`
2. Lines matching pattern `^- \*\*` (bold bullet points)
3. Lines matching pattern `^- ` after intro (first 100 lines)

**USE Grep TOOL** with pattern: `"^- "` on README.md content

**STORE UP TO 10** feature lines

**IF FOUND**: FEATURES variable = extracted lines
**IF NOT FOUND**: FEATURES = ""

**OUTPUT**: Number of features found (or "No features section found")

---

## STEP 6: Extract Tech Stack - MANDATORY

**DETECT FROM FILES**:

**YOU MUST CHECK** (use Bash ls, grep, find):
- `package.json` exists → Check for: react, vue, svelte, next, express, fastify, prisma, typescript
- `requirements.txt` exists → Check for: django, flask, fastapi
- `Cargo.toml` exists → Add "Rust"
- Shell scripts (*.sh) > 5 files → Add "Bash/Shell"
- Markdown files (*.md) > 5 files → Add "Markdown"
- `.git/` folder exists → Add "Git"

**BUILD STRING**: Comma-separated list (e.g., "Bash/Shell, Markdown, Git")

**STORE RESULT**: TECH_STACK variable

**OUTPUT**: "🛠️  Tech Stack: [TECH_STACK]"

---

## STEP 7: Analyze Git History - MANDATORY

**YOU MUST RUN** these Bash commands:

```bash
# Check if git repo exists
test -d .git && echo "yes" || echo "no"

# If yes, get commit count (last 30 days)
git log --oneline --since="30 days ago" 2>/dev/null | wc -l

# Get branch count
git branch 2>/dev/null | wc -l

# Get remote URL
git remote get-url origin 2>/dev/null
```

**STORE RESULTS**:
- HAS_GIT (true/false)
- COMMIT_COUNT (number)
- BRANCH_COUNT (number)
- GIT_REMOTE (URL or empty)

**OUTPUT**:
- "✅ Found [COUNT] commits in last 30 days"
- "✅ Detected [COUNT] branches"
- "✅ Remote: [URL]" (if available)

---

## STEP 8: Read Documentation (if --docs-path provided) - MANDATORY

**ONLY IF** DOCS_PATH is not empty:

**USE Glob TOOL** to find: `${DOCS_PATH}/**/*.md`

**FOR EACH FILE FOUND** (max 5 files):
- Use **Read tool** to read the file
- Count lines
- Show: "✅ [filename] ([lines] lines)"

**IF** no --docs-path → Skip this step, show: "⏭️  No --docs-path provided (using auto-detection only)"

---

## STEP 9: Calculate Context Quality Score - MANDATORY

**YOU MUST CALCULATE** using this formula:

```
score = 40  (base)

IF PROJECT_NAME != "" AND PROJECT_NAME != "." → score += 10
IF DESCRIPTION != "A software development project" → score += 10
IF TECH_STACK has 3+ items (count commas) → score += 15
IF TECH_STACK has 1-2 items → score += 10
IF FEATURES != "" (has features) → score += 15
IF HAS_GIT = true AND COMMIT_COUNT > 10 → score += 10
IF docs were read (STEP 8) → score += 20
```

**STORE**: QUALITY_SCORE variable

**OUTPUT**: "📊 Context Quality: [SCORE]% ([Status])"
- Score >= 80 → "✅ Optimal"
- Score 60-79 → "⚠️  Good"
- Score < 60 → "⚠️  Basic"

---

## STEP 10: Generate productContext.md - MANDATORY

**YOU MUST USE Write TOOL** to create `.claude/memory/productContext.md`

**EXACT CONTENT TEMPLATE**:

```markdown
# Product Context — [PROJECT_NAME]

**Last Updated**: [TODAY_DATE in YYYY-MM-DD]
**Project Type**: [PROJECT_TYPE from STEP 2]

---

## Project Overview
**[PROJECT_NAME]** — [DESCRIPTION]

[IF FEATURES != "", ADD THIS SECTION:]
### Core Features
[FEATURES - each line as-is from STEP 5]

### Technology Stack
[IF TECH_STACK != "", split by comma and output each as:]
- **[ITEM]**

[IF TECH_STACK = "", output:]
- Auto-detection in progress

---

## Project Structure

\`\`\`
[PROJECT_NAME]/
[LIST directories found: src/, app/, lib/, docs/, tests/, .claude/]
\`\`\`

---

## Development Goals

### Current Phase
Active Development

### Success Metrics
- Code quality and maintainability
- Feature completion and testing
- Documentation coverage

---

## Context Notes
**Repository**: [GIT_REMOTE from STEP 7]
**Initialized**: [TODAY_DATE] via /init-memory-bank
**Quality Score**: [QUALITY_SCORE]%
```

**IF DRY_RUN = true**: Show "Would create productContext.md ([lines] lines)" - DO NOT write
**IF DRY_RUN = false**: Write file using Write tool

---

## STEP 11: Generate progress.md - MANDATORY

**YOU MUST USE Write TOOL** to create `.claude/memory/progress.md`

**EXACT CONTENT TEMPLATE**:

```markdown
# Development Progress — [PROJECT_NAME]

**Last Updated**: [TODAY_DATE]
**Current Phase**: Active Development

---

## CURRENT SPRINT
**Overall Progress**: In Progress

### ✅ COMPLETED (Last 7 Days)
[IF HAS_GIT = true, GET LAST 10 COMMITS from last 7 days:]
[Run: git log --pretty=format:"%ad %s" --date=short --since="7 days ago" | head -10]
[Format each as: - **[date]** ✅ [message]]

[IF HAS_GIT = false:]
- Project structure initialized

### 🔄 IN PROGRESS
- Development ongoing

### ⏳ PENDING
- See project backlog

---

## Key Achievements

### 🏗️ FOUNDATIONAL WORK
✅ Project structure established
✅ Memory bank initialized ([TODAY_DATE])
[IF COMMIT_COUNT > 50:]
✅ Active development ([COMMIT_COUNT] commits in 30 days)

---

## Context Notes
Initialized from git history and project analysis on [TODAY_DATE]
```

**IF DRY_RUN = false**: Write file

---

## STEP 12: Generate systemPatterns.md - MANDATORY

**YOU MUST USE Write TOOL** to create `.claude/memory/systemPatterns.md`

**DETECT PATTERNS BASED ON PROJECT_TYPE**:

```markdown
# System Patterns — [PROJECT_NAME]

**Last Updated**: [TODAY_DATE]

---

## Architectural Principles
[IF PROJECT_TYPE contains "Shell" OR "Bash":]
- POSIX compliance for maximum portability
- Proper error handling with set -eu
- Quote all variables to prevent word splitting

[ELSE IF PROJECT_TYPE = "Node.js":]
- Modern ES6+ syntax
- TypeScript for type safety
- Async/await over callbacks

[ELSE:]
- Follow established project conventions
- Maintain code consistency
- Document complex logic

---

## Code Style Patterns
- Clear and descriptive naming
- Single responsibility principle
- DRY (Don't Repeat Yourself)

## Testing Patterns
[IF package.json has "vitest":]
- Testing Framework: Vitest
- Test files colocated with source
- Unit and integration tests required

[ELSE IF package.json has "jest":]
- Testing Framework: Jest
- Tests in __tests__/ directories
- Comprehensive coverage expected

[ELSE:]
- Write tests for critical functionality
- Verify edge cases and error handling

---

## Development Workflow
[IF HAS_GIT = true:]
- Version Control: Git
- Main Branch: [detect: main or master]
- Feature branches for new work

[ELSE:]
- Version control recommended
- Branch-based workflow

---

## Context Notes
Patterns initialized on [TODAY_DATE]
Will be refined over time via /memory-sync
```

**IF DRY_RUN = false**: Write file

---

## STEP 13: Generate decisionLog.md - MANDATORY

**YOU MUST USE Write TOOL** to create `.claude/memory/decisionLog.md`

```markdown
# Decision Log — [PROJECT_NAME]

**Last Updated**: [TODAY_DATE]

---

## [[TODAY_DATE]] Memory Bank Initialized

**Context**: Project setup with Mini-CoderBrain
**Decision**: Initialize memory bank via /init-memory-bank
**Impact**: Enables persistent context awareness across sessions
**Quality Score**: [QUALITY_SCORE]%

---

## Future Decisions

Technical decisions will be recorded here via /memory-sync

---
```

**IF DRY_RUN = false**: Write file

---

## STEP 14: Generate activeContext.md - MANDATORY

**YOU MUST USE Write TOOL** to create `.claude/memory/activeContext.md`

```markdown
# Active Context — [PROJECT_NAME]

**Last Updated**: [TODAY_DATE]

---

## 🎯 Current Focus
[IF HAS_GIT = true, get last commit from last 24 hours:]
[Run: git log --oneline --since="24 hours ago" | head -1]
[Use commit message, OR if empty: "Active development in progress"]

[ELSE:]
Project initialized with Mini-CoderBrain

## ✅ Recent Achievements
[IF HAS_GIT = true, get last 5 commits from last 3 days:]
[Run: git log --oneline --since="3 days ago" | head -5]
[Format as: - [message without hash]]

- Memory bank initialized ([TODAY_DATE])

## 🚀 Next Priorities
1. Continue active development
2. Run /map-codebase for instant file access
3. Use /memory-sync after significant work

## 🔒 Current Blockers
None detected

---

## Session Updates
<!-- Automated session updates will be appended here -->
```

**IF DRY_RUN = false**: Write file

---

## STEP 15: Generate project-structure.json - MANDATORY

**YOU MUST USE Write TOOL** to create `.claude/memory/project-structure.json`

**DETECT DIRECTORIES** using Bash ls or find:

```json
{
  "detected": true,
  "timestamp": "[ISO_8601_TIMESTAMP]",
  "structure": {
    "frontend": [list if exists: "src/", "app/", "components/"],
    "backend": [list if exists: "api/", "server/", "backend/"],
    "database": [list if exists: "prisma/", "migrations/", "db/"],
    "tests": [list if exists: "__tests__/", "tests/", "test/"],
    "docs": [list if exists: "docs/", "documentation/"]
  },
  "languages": [detected from files: "typescript", "javascript", "bash", etc.],
  "frameworks": [detected from TECH_STACK]
}
```

**IF DRY_RUN = false**: Write file

---

## STEP 16: Show Final Summary - MANDATORY

**YOU MUST OUTPUT**:

```
🎉 Memory Bank Initialized Successfully!

📊 Context Quality: [QUALITY_SCORE]% ([Status])

📁 Files Created:
  ✅ productContext.md ([lines] lines)
  ✅ progress.md ([lines] lines)
  ✅ systemPatterns.md ([lines] lines)
  ✅ decisionLog.md ([lines] lines)
  ✅ activeContext.md ([lines] lines)
  ✅ project-structure.json

🚀 Next Steps:
  1. Review .claude/memory/productContext.md
  2. Run /map-codebase for instant file access
  3. Start developing with full context awareness!

💡 Tip: Memory bank now contains [COMMIT_COUNT] commits, [FEATURES count] features, [TECH_STACK item count] technologies
```

**IF DRY_RUN = true**: Show "DRY RUN - No files written. Run without --dry-run to create files."

---

## CRITICAL VALIDATIONS - MANDATORY

**BEFORE CLAIMING SUCCESS**, verify:

- ✅ Used Read tool to read README.md (not bash cat)
- ✅ Used Write tool to create 5 memory files (not bash echo)
- ✅ productContext.md has PROJECT_NAME, not [PROJECT_NAME] placeholder
- ✅ Generated EXACTLY 5 files (not 4, not 6)
- ✅ Quality score calculated (40-100 range)
- ✅ Did NOT edit any .sh files
- ✅ Did NOT call any shell hooks

**IF ANY VALIDATION FAILS** → STOP and report: "❌ Initialization failed at STEP [X]: [reason]"

---

## Error Handling

- **No git repository**: Continue with file detection only, set HAS_GIT=false
- **No README.md**: Use fallback description, FEATURES=""
- **No package manager**: Use file-based detection (shell/markdown counts)
- **Permission errors**: Report clear error: "Cannot write to .claude/memory/ (check permissions)"

---

## ABSOLUTELY FORBIDDEN

- ❌ DO NOT edit or run `.claude/hooks/init-memory-bank.sh`
- ❌ DO NOT use bash `cat` instead of Read tool
- ❌ DO NOT use bash `echo >` instead of Write tool
- ❌ DO NOT skip steps "because project type doesn't need them"
- ❌ DO NOT improvise different detection methods
- ❌ DO NOT leave [PLACEHOLDER] values in generated files
- ❌ DO NOT claim success if files contain template placeholders

---

**REMEMBER**: This is a COMMAND, not a shell script. YOU (the AI) execute it using tools. The .sh file is IRRELEVANT.
