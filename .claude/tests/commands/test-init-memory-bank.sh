#!/usr/bin/env bash
# Test: /init-memory-bank command

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "/init-memory-bank Command"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

test_section "Test 1: Init creates all memory files"

# Run init command
bash .claude/hooks/init-memory-bank.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Init should exit successfully"

test_section "Test 2: All required memory files created"

assert_file_exists "$TEST_ROOT/.claude/memory/productContext.md" \
  "Should create productContext.md"

assert_file_exists "$TEST_ROOT/.claude/memory/activeContext.md" \
  "Should create activeContext.md"

assert_file_exists "$TEST_ROOT/.claude/memory/progress.md" \
  "Should create progress.md"

assert_file_exists "$TEST_ROOT/.claude/memory/decisionLog.md" \
  "Should create decisionLog.md"

assert_file_exists "$TEST_ROOT/.claude/memory/systemPatterns.md" \
  "Should create systemPatterns.md"

test_section "Test 3: Memory files contain templates"

assert_file_contains "$TEST_ROOT/.claude/memory/productContext.md" \
  "Product Context" \
  "productContext should have header"

assert_file_contains "$TEST_ROOT/.claude/memory/activeContext.md" \
  "Active Context" \
  "activeContext should have header"

assert_file_contains "$TEST_ROOT/.claude/memory/progress.md" \
  "Development Progress" \
  "progress should have header"

test_section "Test 4: Project structure detection"

if [ -f "$TEST_ROOT/.claude/memory/project-structure.json" ]; then
  test_pass "project-structure.json created"

  assert_file_contains "$TEST_ROOT/.claude/memory/project-structure.json" \
    "{" \
    "Should be valid JSON"
else
  test_info "project-structure.json not created (optional)"
fi

test_section "Test 5: Init is idempotent (can run multiple times)"

# Run init again
bash .claude/hooks/init-memory-bank.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Init should be idempotent"

# Files should still exist
assert_file_exists "$TEST_ROOT/.claude/memory/productContext.md" \
  "Files should persist after re-init"

test_summary
