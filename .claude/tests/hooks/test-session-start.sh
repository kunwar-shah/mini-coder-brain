#!/usr/bin/env bash
# Test: session-start.sh hook

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "session-start.sh Hook"

# Setup test environment
setup_test_env

# Navigate to test directory
cd "$TEST_ROOT"

# Create mock memory files
create_mock_memory_files

test_section "Test 1: Hook creates session files"

# Run session-start hook
output=$(bash .claude/hooks/session-start.sh 2>&1)
exit_code=$?

assert_exit_code 0 $exit_code "Hook should exit successfully"
assert_file_exists "$TEST_ROOT/.claude/tmp/session-start-time" "Should create session-start-time file"
assert_file_exists "$TEST_ROOT/.claude/tmp/context-loaded.flag" "Should create context-loaded flag"
assert_file_exists "$TEST_ROOT/.claude/tmp/current-profile" "Should create current-profile file"

test_section "Test 2: Profile detection"

# Check default profile
profile=$(cat "$TEST_ROOT/.claude/tmp/current-profile" 2>/dev/null || echo "")
assert_equals "default" "$profile" "Should detect default profile from CLAUDE.md"

test_section "Test 3: Boot status output"

assert_output_contains "$output" "MINI-CODER-BRAIN" "Should output boot status header"
assert_output_contains "$output" "Focus:" "Should show current focus"
assert_output_contains "$output" "Recent:" "Should show recent achievements"

test_section "Test 4: Session start time is valid"

if [ -f "$TEST_ROOT/.claude/tmp/session-start-time" ]; then
  start_time=$(cat "$TEST_ROOT/.claude/tmp/session-start-time")
  current_time=$(date +%s)

  # Start time should be within last 10 seconds
  time_diff=$((current_time - start_time))

  if [ $time_diff -ge 0 ] && [ $time_diff -le 10 ]; then
    test_pass "Session start time is recent and valid ($time_diff seconds ago)"
  else
    test_fail "Session start time is invalid (diff: $time_diff seconds)"
  fi
fi

test_section "Test 5: Context files loaded"

# Check if hook reads productContext
assert_output_contains "$output" "Test Project" "Should read productContext.md" || true

test_summary
