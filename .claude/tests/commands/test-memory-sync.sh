#!/usr/bin/env bash
# Test: /memory-sync command

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "/memory-sync Command"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock data
create_mock_memory_files

test_section "Test 1: Memory sync runs successfully"

bash .claude/hooks/memory-sync.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Memory sync should exit successfully"

test_section "Test 2: Updates sync timestamp"

if [ -f "$TEST_ROOT/.claude/tmp/last-memory-sync" ]; then
  test_pass "Sync timestamp created"

  sync_time=$(cat "$TEST_ROOT/.claude/tmp/last-memory-sync")
  current_time=$(date +%s)
  time_diff=$((current_time - sync_time))

  if [ $time_diff -le 5 ]; then
    test_pass "Sync timestamp is recent ($time_diff seconds ago)"
  else
    test_fail "Sync timestamp should be recent (got: $time_diff seconds)"
  fi
else
  test_fail "Should create sync timestamp"
fi

test_section "Test 3: Full sync mode"

bash .claude/hooks/memory-sync.sh --full > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Full sync should work"

test_section "Test 4: Quick sync mode"

bash .claude/hooks/memory-sync.sh --quick > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Quick sync should work"

test_section "Test 5: Sync with missing memory files"

rm -rf "$TEST_ROOT/.claude/memory/activeContext.md"

bash .claude/hooks/memory-sync.sh > /dev/null 2>&1
exit_code=$?

# Should handle gracefully (create missing files or continue)
test_info "Sync with missing files: exit code $exit_code"

test_section "Test 6: Clears notification flags"

# Create notification flag
touch "$TEST_ROOT/.claude/tmp/last-sync-notification"

bash .claude/hooks/memory-sync.sh > /dev/null 2>&1

assert_file_not_exists "$TEST_ROOT/.claude/tmp/last-sync-notification" \
  "Should clear notification flags after sync"

test_summary
