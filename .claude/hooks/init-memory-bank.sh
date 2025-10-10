#!/usr/bin/env bash
set -euo pipefail

# init-memory-bank.sh - Smart Memory Bank Initialization
# Auto-populates memory bank files from existing project

ROOT="${CLAUDE_PROJECT_DIR:-.}"
MB="$ROOT/.claude/memory"
CLAUDE_TMP="$ROOT/.claude/tmp"

# Parse arguments
DRY_RUN=false
if [[ $# -gt 0 ]] && [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
fi

echo "🔍 Scanning project structure..."

# === PROJECT TYPE DETECTION ===
detect_project_type() {
  if [ -f "package.json" ]; then
    echo "Node.js"
  elif [ -f "Cargo.toml" ]; then
    echo "Rust"
  elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    echo "Python"
  elif [ -f "go.mod" ]; then
    echo "Go"
  elif [ -f "composer.json" ]; then
    echo "PHP"
  else
    echo "Unknown"
  fi
}

PROJECT_TYPE=$(detect_project_type)
echo "✅ Detected: $PROJECT_TYPE project"

# === EXTRACT PROJECT METADATA ===
extract_project_name() {
  local name=""

  if [ -f "package.json" ]; then
    name=$(jq -r '.name // empty' package.json 2>/dev/null || echo "")
  elif [ -f "Cargo.toml" ]; then
    name=$(grep '^name =' Cargo.toml | head -1 | sed 's/name = "\(.*\)"/\1/' || echo "")
  elif [ -f "pyproject.toml" ]; then
    name=$(grep '^name =' pyproject.toml | head -1 | sed 's/name = "\(.*\)"/\1/' || echo "")
  fi

  if [ -z "$name" ]; then
    name=$(basename "$ROOT")
  fi

  echo "$name"
}

PROJECT_NAME=$(extract_project_name)
echo "📦 Project: $PROJECT_NAME"

# === EXTRACT DESCRIPTION ===
extract_description() {
  local desc=""

  # Try package.json
  if [ -f "package.json" ]; then
    desc=$(jq -r '.description // empty' package.json 2>/dev/null || echo "")
  fi

  # Fallback to README first line
  if [ -z "$desc" ] && [ -f "README.md" ]; then
    desc=$(head -3 README.md | grep -v '^#' | grep -v '^$' | head -1 || echo "")
  fi

  if [ -z "$desc" ]; then
    desc="A software development project"
  fi

  echo "$desc"
}

DESCRIPTION=$(extract_description)

# === EXTRACT TECH STACK ===
extract_tech_stack() {
  local frontend="" backend="" database=""

  if [ -f "package.json" ]; then
    # Detect frontend framework
    if grep -q '"react"' package.json; then
      frontend="React"
      if grep -q '"next"' package.json; then
        frontend="Next.js"
      fi
    elif grep -q '"vue"' package.json; then
      frontend="Vue.js"
    elif grep -q '"svelte"' package.json; then
      frontend="Svelte"
    fi

    # Detect backend
    if grep -q '"express"' package.json; then
      backend="Express"
    elif grep -q '"fastify"' package.json; then
      backend="Fastify"
    fi

    # Detect database
    if grep -q '"prisma"' package.json; then
      database="Prisma"
    elif grep -q '"mongoose"' package.json; then
      database="MongoDB (Mongoose)"
    elif grep -q '"pg"' package.json; then
      database="PostgreSQL"
    fi
  fi

  echo "$frontend|$backend|$database"
}

TECH_STACK=$(extract_tech_stack)
FRONTEND=$(echo "$TECH_STACK" | cut -d'|' -f1)
BACKEND=$(echo "$TECH_STACK" | cut -d'|' -f2)
DATABASE=$(echo "$TECH_STACK" | cut -d'|' -f3)

# === GIT ANALYSIS ===
echo ""
echo "🔄 Analyzing git history..."

git_available=false
if command -v git >/dev/null 2>&1 && [ -d ".git" ]; then
  git_available=true
  commit_count=$(git log --oneline --since="30 days ago" 2>/dev/null | wc -l || echo 0)
  branch_count=$(git branch 2>/dev/null | wc -l || echo 0)
  echo "✅ Found $commit_count commits in last 30 days"
  echo "✅ Detected $branch_count branches"
else
  echo "⚠️  No git repository found (will use limited data)"
fi

# === POPULATE productContext.md ===
echo ""
echo "📝 Populating memory bank files..."

TODAY=$(date '+%Y-%m-%d')

productContext_content="# Product Context — $PROJECT_NAME

**Last Updated**: $TODAY
**Project Type**: Auto-detected

---

## Project Overview
**$PROJECT_NAME** — $DESCRIPTION

### Technology Stack"

if [ -n "$FRONTEND" ]; then
  productContext_content+="
- **Frontend**: $FRONTEND"
fi

if [ -n "$BACKEND" ]; then
  productContext_content+="
- **Backend**: $BACKEND"
fi

if [ -n "$DATABASE" ]; then
  productContext_content+="
- **Database**: $DATABASE"
fi

productContext_content+="

---

## Development Goals

### Current Phase
Active development

### Success Metrics
- Code quality and maintainability
- Feature completion
- Test coverage

---

## Context Notes
Memory bank initialized via /init-memory-bank on $TODAY
"

# === POPULATE progress.md ===
progress_content="# Development Progress — $PROJECT_NAME

**Last Updated**: $TODAY
**Current Phase**: Active Development

---

## CURRENT SPRINT
**Overall Progress**: In Progress

### ✅ COMPLETED (Recent)"

if [ "$git_available" = true ]; then
  # Add recent commits as completed tasks
  while IFS= read -r line; do
    commit_date=$(echo "$line" | awk '{print $1}')
    commit_msg=$(echo "$line" | cut -d' ' -f2-)
    progress_content+="
- **$commit_date** ✅ $commit_msg"
  done < <(git log --pretty=format:"%ad %s" --date=short --since="7 days ago" 2>/dev/null | head -5)
fi

progress_content+="

### 🔄 IN PROGRESS (Current)
- Development ongoing

### ⏳ PENDING
- See project backlog

---

## Key Achievements

### 🏗️ FOUNDATIONAL WORK
✅ Project structure established
✅ Initial development environment set up

---

## Context Notes
Initialized from git history on $TODAY
"

# === POPULATE systemPatterns.md ===
systemPatterns_content="# System Patterns — $PROJECT_NAME

**Last Updated**: $TODAY

---

## Code Style Patterns
- Follow project conventions
- Maintain consistency with existing code

## Architecture Patterns
- Modular design
- Separation of concerns

## Testing Patterns
- Write tests for new features
- Maintain test coverage

---

## Context Notes
Initial patterns detected on $TODAY
Patterns will be learned and updated over time via /memory-sync
"

# === POPULATE decisionLog.md ===
decisionLog_content="# Decision Log — $PROJECT_NAME

**Last Updated**: $TODAY

---

## Context Notes
Decision log initialized on $TODAY
Technical decisions will be recorded here via /memory-sync

---

"

# === POPULATE activeContext.md ===
activeContext_content="# Active Context — $PROJECT_NAME

**Last Updated**: $TODAY

---

## 🎯 Current Focus
Project initialized with Mini-CoderBrain

## ✅ Recent Achievements
- Memory bank initialized on $TODAY

## 🚀 Next Priorities
1. Continue development
2. Run /map-codebase for file access
3. Use /memory-sync after significant work

## 🔒 Current Blockers
None detected

---

## Session Updates
<!-- Session updates will be appended here automatically -->
"

# === DRY RUN OR WRITE ===
if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "=== DRY RUN MODE (No files written) ==="
  echo ""
  echo "Would populate:"
  echo "  productContext.md ($(echo "$productContext_content" | wc -l) lines)"
  echo "  progress.md ($(echo "$progress_content" | wc -l) lines)"
  echo "  systemPatterns.md ($(echo "$systemPatterns_content" | wc -l) lines)"
  echo "  decisionLog.md ($(echo "$decisionLog_content" | wc -l) lines)"
  echo "  activeContext.md ($(echo "$activeContext_content" | wc -l) lines)"
  echo ""
  echo "Run /init-memory-bank (without --dry-run) to write files"
else
  # Create backups if files exist
  mkdir -p "$MB/backups"
  for file in productContext.md progress.md systemPatterns.md decisionLog.md activeContext.md; do
    if [ -f "$MB/$file" ]; then
      cp "$MB/$file" "$MB/backups/${file}.backup-$(date +%Y%m%d-%H%M%S)"
    fi
  done

  # Write files
  echo "$productContext_content" > "$MB/productContext.md"
  echo "$progress_content" > "$MB/progress.md"
  echo "$systemPatterns_content" > "$MB/systemPatterns.md"
  echo "$decisionLog_content" > "$MB/decisionLog.md"
  echo "$activeContext_content" > "$MB/activeContext.md"

  echo "✅ productContext.md ($(echo "$productContext_content" | wc -l) lines)"
  echo "✅ progress.md ($(echo "$progress_content" | wc -l) lines)"
  echo "✅ systemPatterns.md ($(echo "$systemPatterns_content" | wc -l) lines)"
  echo "✅ decisionLog.md ($(echo "$decisionLog_content" | wc -l) lines)"
  echo "✅ activeContext.md ($(echo "$activeContext_content" | wc -l) lines)"
  echo ""
  echo "🎯 Memory Bank Initialized Successfully!"
  echo "📁 All files saved to .claude/memory/"
  echo "⚡ Ready for development with full context awareness!"
  echo ""
  echo "Next steps:"
  echo "  1. Continue working - Claude has project context now"
  echo "  2. Run /map-codebase for instant file access"
  echo "  3. Use /memory-sync after completing significant work"
fi

exit 0
