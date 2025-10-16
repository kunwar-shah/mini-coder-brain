#!/usr/bin/env bash
# Test: Cross-Platform Compatibility (Linux vs macOS)

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "Cross-Platform Compatibility"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create test data
create_mock_session_files
create_mock_tool_logs

test_section "Test 1: Detect platform"

if [ "$(uname)" = "Darwin" ]; then
  PLATFORM="macOS"
  test_info "Platform: macOS"
elif [ "$(uname)" = "Linux" ]; then
  PLATFORM="Linux"
  test_info "Platform: Linux"
else
  PLATFORM="Unknown"
  test_info "Platform: Unknown ($(uname))"
fi

test_section "Test 2: stat command compatibility"

# Create test file
test_file="$TEST_ROOT/.claude/tmp/test-stat-file"
echo "test" > "$test_file"

# Try Linux stat syntax
linux_stat=$(stat -c %Y "$test_file" 2>/dev/null || echo "")

# Try macOS stat syntax
macos_stat=$(stat -f %m "$test_file" 2>/dev/null || echo "")

if [ -n "$linux_stat" ]; then
  test_pass "Linux stat syntax works (got: $linux_stat)"
elif [ -n "$macos_stat" ]; then
  test_pass "macOS stat syntax works (got: $macos_stat)"
else
  test_fail "Neither Linux nor macOS stat syntax works"
fi

test_section "Test 3: Metrics report cross-platform"

# Run metrics (should auto-detect correct stat command)
output=$(bash .claude/hooks/metrics-report.sh --session 2>&1)
exit_code=$?

assert_exit_code 0 $exit_code "Metrics should work on this platform"
assert_output_contains "$output" "Session Duration:" "Should calculate duration"

test_section "Test 4: Status footer cross-platform"

# Run user-prompt hook (uses stat for timestamps)
output=$(bash .claude/hooks/conversation-capture-user-prompt.sh 2>&1)
exit_code=$?

assert_exit_code 0 $exit_code "Status footer should work on this platform"

if [ -f "$TEST_ROOT/.claude/tmp/additionalContext" ]; then
  footer=$(cat "$TEST_ROOT/.claude/tmp/additionalContext")
  assert_output_contains "$footer" "Last sync:" "Should show sync time"
  assert_output_not_contains "$footer" "⏱️ 0m" "Duration should not be 0m"
else
  test_fail "Should create additionalContext"
fi

test_section "Test 5: POSIX compliance"

# Check that scripts don't use bash-specific features
test_info "Checking for pipefail (bash-specific)..."

if grep -q "set -euo pipefail" .claude/hooks/metrics-report.sh; then
  test_fail "metrics-report.sh uses bash-specific 'pipefail'"
else
  test_pass "metrics-report.sh is POSIX compliant (no pipefail)"
fi

test_section "Test 6: Line ending compatibility"

# Check for CRLF (Windows line endings)
test_info "Checking for Windows line endings (CRLF)..."

if file .claude/hooks/metrics-report.sh | grep -q "CRLF"; then
  test_fail "Script has Windows line endings (CRLF)"
else
  test_pass "Script has Unix line endings (LF)"
fi

if file .claude/hooks/conversation-capture-user-prompt.sh | grep -q "CRLF"; then
  test_fail "conversation-capture script has CRLF"
else
  test_pass "conversation-capture script has LF"
fi

test_summary
