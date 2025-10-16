#!/usr/bin/env bash
# Test: session-end.sh (stop hook)

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "session-end.sh (Stop Hook)"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock data
create_mock_memory_files
create_mock_tool_logs
create_mock_session_files

test_section "Test 1: Stop hook updates activeContext"

# Run stop hook
bash .claude/hooks/session-end.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Stop hook should exit successfully"

test_section "Test 2: Session update appended to activeContext"

if [ -f "$TEST_ROOT/.claude/memory/activeContext.md" ]; then
  assert_file_contains "$TEST_ROOT/.claude/memory/activeContext.md" \
    "Session Update" \
    "Should append session update"

  test_pass "activeContext.md exists and updated"
else
  test_fail "activeContext.md should exist after stop hook"
fi

test_section "Test 3: Stop hook with missing activeContext"

# Remove activeContext to test creation
rm -f "$TEST_ROOT/.claude/memory/activeContext.md"

bash .claude/hooks/session-end.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Should handle missing activeContext gracefully"

test_section "Test 4: Stop hook with high activity"

# Create many tool logs (high activity)
for i in {1..100}; do
  echo "Write" >> "$TEST_ROOT/.claude/memory/conversations/tool-tracking/tool-log-$(date +%s)-$$-$i.txt"
done

bash .claude/hooks/session-end.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Should handle high activity gracefully"

test_summary
