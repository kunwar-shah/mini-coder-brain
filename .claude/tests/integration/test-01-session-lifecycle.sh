#!/usr/bin/env bash
# Integration Test 01: Session Lifecycle
# Tests complete session flow: start → prompt → tool → stop

set -eu

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
TEST_DIR="$ROOT/.claude/tests/integration"
HOOKS_DIR="$ROOT/.claude/hooks"

# Load helpers
source "$TEST_DIR/helpers/assert.sh"

echo "=== INTEGRATION TEST 01: SESSION LIFECYCLE ==="
echo ""

test_passed=0
test_failed=0

# Setup test environment
setup_test_env() {
  export CLAUDE_TMP="$ROOT/.claude/tmp"
  export MB="$ROOT/.claude/memory"

  # Ensure clean state
  mkdir -p "$CLAUDE_TMP" "$MB"
  rm -f "$CLAUDE_TMP/context-loaded.flag" 2>/dev/null || true
}

cleanup_test_env() {
  # Optional: cleanup temp files
  true
}

# Test 1: SessionStart hook
echo -n "TEST 1: SessionStart hook executes... "
setup_test_env
output=$(bash "$HOOKS_DIR/session-start.sh" 2>&1)
exit_code=$?
if [ $exit_code -eq 0 ]; then
  echo "✅ PASS"
  test_passed=$((test_passed + 1))
else
  echo "❌ FAIL (exit: $exit_code)"
  test_failed=$((test_failed + 1))
fi

# Test 2: Context loaded flag created
echo -n "TEST 2: Context flag created... "
if [ -f "$CLAUDE_TMP/context-loaded.flag" ]; then
  echo "✅ PASS"
  test_passed=$((test_passed + 1))
else
  echo "❌ FAIL"
  test_failed=$((test_failed + 1))
fi

# Test 3: SessionStart with empty stdin
echo -n "TEST 3: SessionStart with empty stdin... "
echo '' | bash "$HOOKS_DIR/session-start.sh" >/dev/null 2>&1
exit_code=$?
if [ $exit_code -eq 0 ]; then
  echo "✅ PASS"
  test_passed=$((test_passed + 1))
else
  echo "❌ FAIL (exit: $exit_code)"
  test_failed=$((test_failed + 1))
fi

# Test 4: UserPromptSubmit hook
echo -n "TEST 4: UserPromptSubmit hook executes... "
input='{"session_id":"test-123","prompt":"test prompt"}'
output=$(echo "$input" | bash "$HOOKS_DIR/user-prompt-submit.sh" 2>&1)
exit_code=$?
if [ $exit_code -eq 0 ] && echo "$output" | grep -q "hookEventName"; then
  echo "✅ PASS"
  test_passed=$((test_passed + 1))
else
  echo "❌ FAIL (exit: $exit_code)"
  test_failed=$((test_failed + 1))
fi

# Test 5: PostToolUse hook
echo -n "TEST 5: PostToolUse hook executes... "
input='{"tool_name":"Read","file_path":"test.md"}'
output=$(echo "$input" | bash "$HOOKS_DIR/post-tool-use.sh" 2>&1)
exit_code=$?
if [ $exit_code -eq 0 ] && echo "$output" | grep -q "approve"; then
  echo "✅ PASS"
  test_passed=$((test_passed + 1))
else
  echo "❌ FAIL (exit: $exit_code)"
  test_failed=$((test_failed + 1))
fi

# Test 6: Stop hook
echo -n "TEST 6: Stop hook executes... "
input='{"session_id":"test-123"}'
output=$(echo "$input" | bash "$HOOKS_DIR/stop.sh" 2>&1)
exit_code=$?
if [ $exit_code -eq 0 ]; then
  echo "✅ PASS"
  test_passed=$((test_passed + 1))
else
  echo "❌ FAIL (exit: $exit_code)"
  test_failed=$((test_failed + 1))
fi

# Test 7: PreCompact hook
echo -n "TEST 7: PreCompact hook executes... "
input='{"reason":"conversation_length"}'
output=$(echo "$input" | bash "$HOOKS_DIR/pre-compact-umb-sync.sh" 2>&1)
exit_code=$?
if [ $exit_code -eq 0 ]; then
  echo "✅ PASS"
  test_passed=$((test_passed + 1))
else
  echo "❌ FAIL (exit: $exit_code)"
  test_failed=$((test_failed + 1))
fi

# Test 8: SessionEnd hook
echo -n "TEST 8: SessionEnd hook executes... "
input='{"reason":"user_exit"}'
output=$(echo "$input" | bash "$HOOKS_DIR/session-end.sh" 2>&1)
exit_code=$?
if [ $exit_code -eq 0 ]; then
  echo "✅ PASS"
  test_passed=$((test_passed + 1))
else
  echo "❌ FAIL (exit: $exit_code)"
  test_failed=$((test_failed + 1))
fi

# Summary
echo ""
echo "=== TEST RESULTS ==="
echo "PASSED: $test_passed"
echo "FAILED: $test_failed"
echo "TOTAL:  $((test_passed + test_failed))"
echo ""

cleanup_test_env

if [ "$test_failed" -eq 0 ]; then
  echo "🎉 ALL LIFECYCLE TESTS PASSED"
  exit 0
else
  echo "⚠️  SOME TESTS FAILED"
  exit 1
fi
