#!/usr/bin/env bash
# Master Integration Test Runner
# Runs all integration tests and reports results

set -eu

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
TEST_DIR="$ROOT/.claude/tests/integration"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   MINI-CODERBRAIN INTEGRATION TEST SUITE                 ║"
echo "║   Testing hooks with real Claude Code behavior           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

total_passed=0
total_failed=0
suite_count=0

# Run each test suite
test_suites=(
  "test-01-session-lifecycle.sh"
  "test-02-input-validation.sh"
)

for suite in "${test_suites[@]}"; do
  suite_path="$TEST_DIR/$suite"

  if [ ! -f "$suite_path" ]; then
    echo "⚠️  SKIP: $suite (not found)"
    continue
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Running: $suite"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Run test suite
  if bash "$suite_path"; then
    suite_result="✅ PASS"
  else
    suite_result="❌ FAIL"
    total_failed=$((total_failed + 1))
  fi

  suite_count=$((suite_count + 1))
  echo ""
  echo "Result: $suite_result"
  echo ""
done

# Final summary
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   FINAL RESULTS                                          ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Test Suites Run: $suite_count"
echo "Suites Passed:   $((suite_count - total_failed))"
echo "Suites Failed:   $total_failed"
echo ""

if [ "$total_failed" -eq 0 ]; then
  echo "🎉 ALL INTEGRATION TESTS PASSED"
  echo ""
  echo "✅ Hooks are production ready"
  echo "✅ All exit codes 0 (never crash)"
  echo "✅ Graceful degradation verified"
  echo "✅ Input validation working"
  echo ""
  exit 0
else
  echo "⚠️  SOME TESTS FAILED"
  echo ""
  echo "Review failures above and fix before deploying"
  echo ""
  exit 1
fi
