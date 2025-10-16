#!/usr/bin/env bash
# Test Helpers - Shared utilities for Mini-CoderBrain tests

set -eu

# Colors for test output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test environment
TEST_ROOT=""
ORIGINAL_DIR=""

#############################################
# Test Output Functions
#############################################

test_header() {
  local test_name="$1"
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}TEST: $test_name${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

test_section() {
  local section_name="$1"
  echo ""
  echo -e "${YELLOW}→ $section_name${NC}"
}

test_pass() {
  local message="$1"
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_PASSED=$((TESTS_PASSED + 1))
  echo -e "${GREEN}✓${NC} $message"
}

test_fail() {
  local message="$1"
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_FAILED=$((TESTS_FAILED + 1))
  echo -e "${RED}✗${NC} $message"
}

test_info() {
  local message="$1"
  echo -e "${BLUE}ℹ${NC} $message"
}

test_summary() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}TEST SUMMARY${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo "Tests Run: $TESTS_RUN"
  echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
  echo -e "Failed: ${RED}$TESTS_FAILED${NC}"

  if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}ALL TESTS PASSED ✓${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    return 0
  else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}SOME TESTS FAILED ✗${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    return 1
  fi
}

#############################################
# Test Environment Setup
#############################################

setup_test_env() {
  # Create temporary test directory
  TEST_ROOT=$(mktemp -d -t mini-coder-brain-test-XXXXXX)
  ORIGINAL_DIR=$(pwd)

  test_info "Created test environment: $TEST_ROOT"

  # Copy .claude/ structure to test directory
  mkdir -p "$TEST_ROOT/.claude"
  cp -r .claude/hooks "$TEST_ROOT/.claude/"
  cp -r .claude/commands "$TEST_ROOT/.claude/"
  cp -r .claude/patterns "$TEST_ROOT/.claude/" 2>/dev/null || true
  cp -r .claude/profiles "$TEST_ROOT/.claude/" 2>/dev/null || true
  cp -r .claude/rules "$TEST_ROOT/.claude/" 2>/dev/null || true
  cp -r .claude/docs "$TEST_ROOT/.claude/" 2>/dev/null || true

  # Create memory and tmp directories
  mkdir -p "$TEST_ROOT/.claude/memory"
  mkdir -p "$TEST_ROOT/.claude/memory/conversations"
  mkdir -p "$TEST_ROOT/.claude/memory/conversations/tool-tracking"
  mkdir -p "$TEST_ROOT/.claude/tmp"

  # Copy CLAUDE.md
  cp CLAUDE.md "$TEST_ROOT/" 2>/dev/null || true

  # Set environment variables for hooks
  export CLAUDE_PROJECT_DIR="$TEST_ROOT"
  export CLAUDE_MEMORY="$TEST_ROOT/.claude/memory"
  export CLAUDE_TMP="$TEST_ROOT/.claude/tmp"

  test_info "Test environment ready"
}

cleanup_test_env() {
  if [ -n "$TEST_ROOT" ] && [ -d "$TEST_ROOT" ]; then
    test_info "Cleaning up test environment: $TEST_ROOT"
    rm -rf "$TEST_ROOT"
  fi

  # Restore original directory
  if [ -n "$ORIGINAL_DIR" ]; then
    cd "$ORIGINAL_DIR"
  fi

  # Unset environment variables
  unset CLAUDE_PROJECT_DIR
  unset CLAUDE_MEMORY
  unset CLAUDE_TMP
}

#############################################
# Test Assertion Functions
#############################################

assert_file_exists() {
  local file="$1"
  local message="${2:-File should exist: $file}"

  if [ -f "$file" ]; then
    test_pass "$message"
    return 0
  else
    test_fail "$message (file not found)"
    return 1
  fi
}

assert_file_not_exists() {
  local file="$1"
  local message="${2:-File should not exist: $file}"

  if [ ! -f "$file" ]; then
    test_pass "$message"
    return 0
  else
    test_fail "$message (file exists)"
    return 1
  fi
}

assert_file_contains() {
  local file="$1"
  local pattern="$2"
  local message="${3:-File should contain: $pattern}"

  if [ ! -f "$file" ]; then
    test_fail "$message (file not found)"
    return 1
  fi

  if grep -q "$pattern" "$file"; then
    test_pass "$message"
    return 0
  else
    test_fail "$message (pattern not found)"
    return 1
  fi
}

assert_file_not_contains() {
  local file="$1"
  local pattern="$2"
  local message="${3:-File should not contain: $pattern}"

  if [ ! -f "$file" ]; then
    test_fail "$message (file not found)"
    return 1
  fi

  if ! grep -q "$pattern" "$file"; then
    test_pass "$message"
    return 0
  else
    test_fail "$message (pattern found)"
    return 1
  fi
}

assert_exit_code() {
  local expected="$1"
  local actual="$2"
  local message="${3:-Exit code should be $expected}"

  if [ "$actual" -eq "$expected" ]; then
    test_pass "$message (got $actual)"
    return 0
  else
    test_fail "$message (got $actual, expected $expected)"
    return 1
  fi
}

assert_output_contains() {
  local output="$1"
  local pattern="$2"
  local message="${3:-Output should contain: $pattern}"

  if echo "$output" | grep -q "$pattern"; then
    test_pass "$message"
    return 0
  else
    test_fail "$message"
    return 1
  fi
}

assert_output_not_contains() {
  local output="$1"
  local pattern="$2"
  local message="${3:-Output should not contain: $pattern}"

  if ! echo "$output" | grep -q "$pattern"; then
    test_pass "$message"
    return 0
  else
    test_fail "$message"
    return 1
  fi
}

assert_equals() {
  local expected="$1"
  local actual="$2"
  local message="${3:-Values should be equal}"

  if [ "$actual" = "$expected" ]; then
    test_pass "$message (got: $actual)"
    return 0
  else
    test_fail "$message (expected: $expected, got: $actual)"
    return 1
  fi
}

assert_not_equals() {
  local expected="$1"
  local actual="$2"
  local message="${3:-Values should not be equal}"

  if [ "$actual" != "$expected" ]; then
    test_pass "$message"
    return 0
  else
    test_fail "$message (both are: $actual)"
    return 1
  fi
}

#############################################
# Test Data Generators
#############################################

create_mock_memory_files() {
  local memory_dir="$TEST_ROOT/.claude/memory"

  # productContext.md
  cat > "$memory_dir/productContext.md" <<'EOF'
# Product Context — Test Project

**Last Updated**: 2025-10-16
**Project Type**: Test

---

## Project Overview
**Test Project** — A project for testing Mini-CoderBrain

### Technology Stack
- **Frontend**: React + TypeScript
- **Backend**: Node.js + Express
- **Database**: PostgreSQL
EOF

  # activeContext.md
  cat > "$memory_dir/activeContext.md" <<'EOF'
# Active Context — Test Project

**Last Updated**: 2025-10-16
**Current Sprint**: Testing Sprint

---

## 🎯 Current Focus
Testing Mini-CoderBrain v2.1 features

## ✅ Recent Achievements
- Created test suite

## 🚀 Next Priorities
1. Run all tests
2. Fix any issues
EOF

  # progress.md
  cat > "$memory_dir/progress.md" <<'EOF'
# Development Progress — Test Project

**Last Updated**: 2025-10-16

## CURRENT SPRINT: Testing
### ✅ COMPLETED
- Test suite setup

### 🔄 IN PROGRESS
- Running tests
EOF

  # decisionLog.md
  cat > "$memory_dir/decisionLog.md" <<'EOF'
# Decision Log — Test Project

## [2025-10-16] ADR-001 — Use Test Suite

**Decision**: Implement comprehensive test suite
**Rationale**: Ensure quality before production
EOF

  # systemPatterns.md
  cat > "$memory_dir/systemPatterns.md" <<'EOF'
# System Patterns — Test Project

## Testing Framework
- **Framework**: Bash test scripts
- **Coverage**: All hooks and commands
EOF

  test_info "Created mock memory files"
}

create_mock_tool_logs() {
  local tool_dir="$TEST_ROOT/.claude/memory/conversations/tool-tracking"
  local timestamp=$(date +%s)

  # Create some mock tool logs
  for i in {1..10}; do
    local tool_time=$((timestamp - (i * 60)))
    echo "Read" >> "$tool_dir/tool-log-$tool_time-$$-$i.txt"
  done

  for i in {1..5}; do
    local tool_time=$((timestamp - (i * 120)))
    echo "Edit" >> "$tool_dir/tool-log-$tool_time-$$-$i.txt"
  done

  test_info "Created mock tool logs (15 total)"
}

create_mock_session_files() {
  local tmp_dir="$TEST_ROOT/.claude/tmp"
  local timestamp=$(date +%s)

  # Session start time (1 hour ago)
  echo $((timestamp - 3600)) > "$tmp_dir/session-start-time"

  # Context loaded flag
  touch "$tmp_dir/context-loaded.flag"

  # Current profile
  echo "default" > "$tmp_dir/current-profile"

  # Last memory sync (30 minutes ago)
  echo $((timestamp - 1800)) > "$tmp_dir/last-memory-sync"

  test_info "Created mock session files"
}

#############################################
# Cleanup trap
#############################################

trap_cleanup() {
  cleanup_test_env
}

# Set trap for script interruption
trap trap_cleanup EXIT INT TERM

#############################################
# Export functions for use in test scripts
#############################################

export -f test_header
export -f test_section
export -f test_pass
export -f test_fail
export -f test_info
export -f test_summary
export -f setup_test_env
export -f cleanup_test_env
export -f assert_file_exists
export -f assert_file_not_exists
export -f assert_file_contains
export -f assert_file_not_contains
export -f assert_exit_code
export -f assert_output_contains
export -f assert_output_not_contains
export -f assert_equals
export -f assert_not_equals
export -f create_mock_memory_files
export -f create_mock_tool_logs
export -f create_mock_session_files
