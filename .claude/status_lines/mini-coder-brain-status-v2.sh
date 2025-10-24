#!/usr/bin/env bash
# Mini-CoderBrain Status Line v2 - Operational State
# Shows REAL-TIME operational info (different from session footer)
# Footer = Session context | Status Line = Operational state

set -eu

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
MB="$ROOT/.claude/memory"
TMP="$ROOT/.claude/tmp"

# Read JSON input from stdin (required by Claude Code)
input=$(cat 2>/dev/null || echo "{}")

# ============================================================================
# OPERATIONAL STATE DATA (different from footer)
# ============================================================================

# 1. Git Branch + Changes
git_info="no-git"
if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null || echo "detached")
  uncommitted=$(git status --porcelain 2>/dev/null | wc -l || echo "0")

  if [ "$uncommitted" -gt 0 ]; then
    git_info="${branch} ✎${uncommitted}"
  else
    git_info="${branch}"
  fi
fi

# 2. Active Blockers Count
blockers=0
if [ -f "$MB/activeContext.md" ]; then
  blockers=$( (grep -c "^-.*\[BLOCKED\]\|^-.*blocker" "$MB/activeContext.md" 2>/dev/null || echo "0") | tr -d '\n ')
fi

# 3. Hook Health Status
hook_health="✅"
hook_label="OK"

# Check if any hooks have recent errors (from logs)
if [ -d "$ROOT/logs" ]; then
  error_count=$( (find "$ROOT/logs" -name "*.log" -type f -mmin -60 -exec grep -l "ERROR\|FAIL\|Exception" {} \; 2>/dev/null | wc -l || echo "0") | tr -d '\n ')

  if [ "$error_count" -gt 0 ]; then
    hook_health="⚠️"
    hook_label="Errors"
  fi
fi

# 4. Current Sprint/Milestone (from activeContext)
sprint="General Dev"
if [ -f "$MB/activeContext.md" ]; then
  sprint_line=$(grep "^**Current Sprint" "$MB/activeContext.md" 2>/dev/null | head -1 || echo "")
  if [ -n "$sprint_line" ]; then
    sprint=$(echo "$sprint_line" | sed 's/.*: //' | sed 's/\*\*//g' | cut -c 1-15)
  fi
fi

# 5. Last Achievement (recent win)
last_achievement="None"
if [ -f "$MB/activeContext.md" ]; then
  last_ach=$(grep "^-.*\*\*.*\*\*.*—" "$MB/activeContext.md" 2>/dev/null | head -1 | sed 's/^- //' | cut -c 1-25 || echo "")
  if [ -n "$last_ach" ]; then
    last_achievement="$last_ach"
  fi
fi

# 6. Test Suite Status (if exists)
test_status="No tests"
if [ -f "$ROOT/.claude/tests/run-tests.sh" ]; then
  # Check last test run results (from temp file)
  if [ -f "$TMP/last-test-result" ]; then
    test_result=$(cat "$TMP/last-test-result" 2>/dev/null || echo "unknown")
    if [ "$test_result" = "pass" ]; then
      test_status="✅ Tests"
    else
      test_status="❌ Tests"
    fi
  else
    test_status="⏳ Tests"
  fi
fi

# 7. Memory Bank Files Count
mb_files=0
if [ -d "$MB" ]; then
  mb_files=$( (find "$MB" -name "*.md" -type f 2>/dev/null | wc -l || echo "0") | tr -d '\n ')
fi

# 8. Active Tasks Count (from progress.md)
active_tasks=0
if [ -f "$MB/progress.md" ]; then
  active_tasks=$( (grep -c "^- \[x\]" "$MB/progress.md" 2>/dev/null || echo "0") | tr -d '\n ')
fi

# ============================================================================
# BUILD COMPACT STATUS LINE (operational focus)
# ============================================================================

# Color codes
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BLUE="\033[34m"
GRAY="\033[90m"
BOLD="\033[1m"
RESET="\033[0m"

# Build status components (different from footer!)
parts=()

# Brand with hook health
parts+=("${CYAN}${BOLD}🧠 MCB${RESET} ${hook_health}")

# Git info (operational)
if [ "$git_info" != "no-git" ]; then
  if [[ "$git_info" == *"✎"* ]]; then
    parts+=("${YELLOW}📦 ${git_info}${RESET}")
  else
    parts+=("${GREEN}📦 ${git_info}${RESET}")
  fi
fi

# Blockers (operational alert)
if [ "$blockers" -gt 0 ]; then
  parts+=("${RED}🚫 ${blockers} blocked${RESET}")
fi

# Sprint/milestone
parts+=("${BLUE}🎯 ${sprint}${RESET}")

# Test status
if [ "$test_status" != "No tests" ]; then
  parts+=("${GRAY}${test_status}${RESET}")
fi

# Memory bank files (operational state)
parts+=("${GRAY}💾 ${mb_files} files${RESET}")

# Active tasks
if [ "$active_tasks" -gt 0 ]; then
  parts+=("${GREEN}✓ ${active_tasks} done${RESET}")
fi

# Last achievement (recent win indicator)
if [ "$last_achievement" != "None" ]; then
  parts+=("${CYAN}🏆 Recent${RESET}")
fi

# Join parts
IFS=" │ "
status_line="${parts[*]}"

# ============================================================================
# OUTPUT
# ============================================================================

echo -e "$status_line"

# Debug logging
if [ -n "${MCB_DEBUG:-}" ]; then
  echo "[$(date --iso-8601=seconds)] ${status_line}" >> "$TMP/status-line-v2-debug.log"
fi

exit 0
