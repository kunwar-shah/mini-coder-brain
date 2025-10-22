#!/usr/bin/env bash
# Integration Test 02: Input Validation
# Tests hooks handle various input conditions gracefully

set -eu

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
HOOKS_DIR="$ROOT/.claude/hooks"

echo "=== INTEGRATION TEST 02: INPUT VALIDATION ==="
echo ""

test_passed=0
test_failed=0

# Test each hook with various inputs
hooks_to_test=(
  "user-prompt-submit.sh"
  "post-tool-use.sh"
  "stop.sh"
  "pre-compact-umb-sync.sh"
  "session-end.sh"
)

for hook in "${hooks_to_test[@]}"; do
  hook_path="$HOOKS_DIR/$hook"

  if [ ! -f "$hook_path" ]; then
    echo "⚠️  SKIP: $hook (not found)"
    continue
  fi

  # Test 1: Valid JSON
  echo -n "TEST: $hook with valid JSON... "
  echo '{"test":"valid"}' | bash "$hook_path" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "✅ PASS"
    test_passed=$((test_passed + 1))
  else
    echo "❌ FAIL"
    test_failed=$((test_failed + 1))
  fi

  # Test 2: Empty stdin
  echo -n "TEST: $hook with empty stdin... "
  echo '' | bash "$hook_path" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "✅ PASS"
    test_passed=$((test_passed + 1))
  else
    echo "❌ FAIL"
    test_failed=$((test_failed + 1))
  fi

  # Test 3: Invalid JSON
  echo -n "TEST: $hook with invalid JSON... "
  echo 'not json at all' | bash "$hook_path" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "✅ PASS"
    test_passed=$((test_passed + 1))
  else
    echo "❌ FAIL"
    test_failed=$((test_failed + 1))
  fi

  # Test 4: Malformed JSON
  echo -n "TEST: $hook with malformed JSON... "
  echo '{"unclosed": "bracket"' | bash "$hook_path" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "✅ PASS"
    test_passed=$((test_passed + 1))
  else
    echo "❌ FAIL"
    test_failed=$((test_failed + 1))
  fi

  echo ""
done

# Summary
echo "=== TEST RESULTS ==="
echo "PASSED: $test_passed"
echo "FAILED: $test_failed"
echo "TOTAL:  $((test_passed + test_failed))"
echo ""

if [ "$test_failed" -eq 0 ]; then
  echo "🎉 ALL INPUT VALIDATION TESTS PASSED"
  exit 0
else
  echo "⚠️  SOME TESTS FAILED"
  exit 1
fi
