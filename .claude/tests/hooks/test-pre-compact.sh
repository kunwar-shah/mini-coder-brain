#!/usr/bin/env bash
# Test: pre-compact-umb-sync.sh hook

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "pre-compact-umb-sync.sh Hook"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock data
create_mock_memory_files

test_section "Test 1: Pre-compact hook runs successfully"

bash .claude/hooks/pre-compact-umb-sync.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Pre-compact hook should exit successfully"

test_section "Test 2: Updates sync timestamp"

if [ -f "$TEST_ROOT/.claude/tmp/last-memory-sync" ]; then
  test_pass "Sync timestamp file created"

  # Check timestamp is recent
  sync_time=$(cat "$TEST_ROOT/.claude/tmp/last-memory-sync")
  current_time=$(date +%s)
  time_diff=$((current_time - sync_time))

  if [ $time_diff -le 5 ]; then
    test_pass "Sync timestamp is recent ($time_diff seconds ago)"
  else
    test_fail "Sync timestamp should be recent (got: $time_diff seconds)"
  fi
else
  test_fail "Should create last-memory-sync timestamp"
fi

test_section "Test 3: Clears notification flags"

# Create notification flags
touch "$TEST_ROOT/.claude/tmp/last-sync-notification"
touch "$TEST_ROOT/.claude/tmp/update-notified-timestamp"

bash .claude/hooks/pre-compact-umb-sync.sh > /dev/null 2>&1

assert_file_not_exists "$TEST_ROOT/.claude/tmp/last-sync-notification" \
  "Should clear sync notification flag"

assert_file_not_exists "$TEST_ROOT/.claude/tmp/update-notified-timestamp" \
  "Should clear update notification flag"

test_section "Test 4: Works with missing memory files"

rm -rf "$TEST_ROOT/.claude/memory"
mkdir -p "$TEST_ROOT/.claude/memory"

bash .claude/hooks/pre-compact-umb-sync.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Should handle missing memory files gracefully"

test_summary
