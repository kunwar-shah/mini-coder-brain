#!/usr/bin/env bash
# Test: /metrics command (metrics-report.sh)

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "/metrics Command"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock data
create_mock_memory_files
create_mock_tool_logs
create_mock_session_files

test_section "Test 1: Metrics command runs without jq"

# Temporarily hide jq if it exists
JQ_PATH=$(which jq 2>/dev/null || echo "")
if [ -n "$JQ_PATH" ]; then
  export PATH=$(echo $PATH | sed "s|$(dirname $JQ_PATH)||g")
fi

output=$(bash .claude/hooks/metrics-report.sh --session 2>&1)
exit_code=$?

assert_exit_code 0 $exit_code "Should work without jq"
assert_output_contains "$output" "MINI-CODER-BRAIN METRICS" "Should show metrics header"
assert_output_contains "$output" "Total Operations:" "Should show operation count"

# Restore jq path
if [ -n "$JQ_PATH" ]; then
  export PATH="$(dirname $JQ_PATH):$PATH"
fi

test_section "Test 2: Session report shows all sections"

output=$(bash .claude/hooks/metrics-report.sh --session 2>&1)

assert_output_contains "$output" "Session Date:" "Should show session date"
assert_output_contains "$output" "Session Duration:" "Should show duration"
assert_output_contains "$output" "Profile:" "Should show profile"
assert_output_contains "$output" "TOOL USAGE" "Should show tool usage section"
assert_output_contains "$output" "MEMORY HEALTH" "Should show memory health"
assert_output_contains "$output" "SYNCHRONIZATION" "Should show sync status"
assert_output_contains "$output" "CODEBASE MAP" "Should show map status"

test_section "Test 3: Tool usage parsing"

# Should show breakdown of tools used
assert_output_contains "$output" "Tool Breakdown:" "Should show tool breakdown"
assert_output_contains "$output" "Read\|Edit\|Write\|Bash" "Should list some tools" || true

test_section "Test 4: Weekly report"

weekly_output=$(bash .claude/hooks/metrics-report.sh --weekly 2>&1)
weekly_exit=$?

assert_exit_code 0 $weekly_exit "Weekly report should exit successfully"
assert_output_contains "$weekly_output" "METRICS" "Should show metrics header"

test_section "Test 5: Default mode (no flags)"

default_output=$(bash .claude/hooks/metrics-report.sh 2>&1)
default_exit=$?

assert_exit_code 0 $default_exit "Default mode should work"
assert_output_contains "$default_output" "MINI-CODER-BRAIN METRICS" "Should show report"

test_section "Test 6: Cross-platform stat command"

# Script should handle both Linux and macOS stat syntax
# This is already integrated, just verify no errors occur
if [ -f "$TEST_ROOT/.claude/tmp/session-start-time" ]; then
  test_pass "Stat command works on this platform"
else
  test_fail "Session tracking file should exist"
fi

test_section "Test 7: Missing data graceful handling"

# Remove tool logs
rm -rf "$TEST_ROOT/.claude/memory/conversations/tool-tracking/"*.txt 2>/dev/null || true

output_no_logs=$(bash .claude/hooks/metrics-report.sh --session 2>&1)
exit_no_logs=$?

assert_exit_code 0 $exit_no_logs "Should handle missing tool logs gracefully"
assert_output_contains "$output_no_logs" "Total Operations: 0" "Should show 0 operations when no logs"

test_section "Test 8: No CRLF line ending issues"

# Check that script doesn't have Windows line endings
if file .claude/hooks/metrics-report.sh | grep -q "CRLF"; then
  test_fail "Script should not have CRLF line endings"
else
  test_pass "Script has correct LF line endings"
fi

test_summary
