#!/usr/bin/env bash
# Test: conversation-capture-user-prompt.sh hook (Enhanced Status Footer)

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "conversation-capture-user-prompt.sh Hook (Enhanced Status Footer)"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock data
create_mock_memory_files
create_mock_tool_logs
create_mock_session_files

test_section "Test 1: Hook generates enhanced status footer"

# Mock additionalContext file (simulating Claude Code injecting it)
mkdir -p "$TEST_ROOT/.claude/tmp"
# Provide mock input (hook reads from stdin)
echo '{"prompt": "test prompt"}' | bash .claude/hooks/conversation-capture-user-prompt.sh > /dev/null 2>&1
exit_code=$?
output="Hook completed"

assert_exit_code 0 $exit_code "Hook should exit successfully"

# Read the generated additionalContext
if [ -f "$TEST_ROOT/.claude/tmp/additionalContext" ]; then
  footer=$(cat "$TEST_ROOT/.claude/tmp/additionalContext")

  test_section "Test 2: Footer contains all 9 metrics"

  assert_output_contains "$footer" "🧠 MINI-CODER-BRAIN STATUS" "Should have status header"
  assert_output_contains "$footer" "📊 Activity:" "Should show activity count"
  assert_output_contains "$footer" "🗺️ Map:" "Should show map status"
  assert_output_contains "$footer" "⚡ Context:" "Should show context status"
  assert_output_contains "$footer" "🎭 Profile:" "Should show profile"
  assert_output_contains "$footer" "⏱️" "Should show session duration"
  assert_output_contains "$footer" "🎯 Focus:" "Should show current focus"
  assert_output_contains "$footer" "💾 Memory:" "Should show memory health"
  assert_output_contains "$footer" "🔄 Last sync:" "Should show last sync time"
  assert_output_contains "$footer" "🔧 Tools:" "Should show tool usage"

  test_section "Test 3: Session duration not 0m"

  assert_output_not_contains "$footer" "⏱️ 0m" "Session duration should not be 0m"

  test_section "Test 4: Sync time wording correct"

  # Should show "Just now", "Xm ago", "Xh ago", or "Xd ago" - NOT "0m ago"
  if echo "$footer" | grep -q "Last sync: 0m ago"; then
    test_fail "Should not show '0m ago' (use 'Just now' instead)"
  else
    test_pass "Sync time wording is correct (not '0m ago')"
  fi

  test_section "Test 5: Activity count matches tool logs"

  # Extract activity count from footer
  activity=$(echo "$footer" | grep -o 'Activity: [0-9]*' | grep -o '[0-9]*')

  if [ -n "$activity" ] && [ "$activity" -gt 0 ]; then
    test_pass "Activity count is positive: $activity ops"
  else
    test_fail "Activity count should be positive (got: $activity)"
  fi

  test_section "Test 6: Memory health status"

  if echo "$footer" | grep -q "Memory: Healthy\|Memory: Monitor\|Memory: Needs Cleanup"; then
    test_pass "Memory health shows valid status"
  else
    test_fail "Memory health should show Healthy/Monitor/Needs Cleanup"
  fi

  test_section "Test 7: Footer format (4 lines)"

  # Count lines in footer (excluding empty lines at start/end)
  line_count=$(echo "$footer" | grep -v '^$' | wc -l)

  if [ "$line_count" -ge 3 ] && [ "$line_count" -le 5 ]; then
    test_pass "Footer has correct format ($line_count lines)"
  else
    test_fail "Footer should be 3-5 lines (got: $line_count)"
  fi

else
  test_fail "Hook should create additionalContext file"
fi

test_summary
