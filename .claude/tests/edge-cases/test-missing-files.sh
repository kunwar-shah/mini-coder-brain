#!/usr/bin/env bash
# Test: Edge Case - Missing Files

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "Edge Case: Missing Files"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

test_section "Test 1: Metrics with no tool logs"

# Run metrics without any tool logs
output=$(bash .claude/hooks/metrics-report.sh --session 2>&1)
exit_code=$?

assert_exit_code 0 $exit_code "Should handle missing tool logs gracefully"
assert_output_contains "$output" "Total Operations: 0" "Should show 0 operations"

test_section "Test 2: Metrics with no session files"

# No session-start-time or last-memory-sync files
output=$(bash .claude/hooks/metrics-report.sh --session 2>&1)

assert_exit_code 0 $exit_code "Should handle missing session files"
assert_output_contains "$output" "Session Duration:" "Should show duration (with fallback)"

test_section "Test 3: Status footer with missing memory files"

# Create minimal session files but no memory files
create_mock_session_files

output=$(bash .claude/hooks/conversation-capture-user-prompt.sh 2>&1)
exit_code=$?

assert_exit_code 0 $exit_code "Should handle missing memory files"

if [ -f "$TEST_ROOT/.claude/tmp/additionalContext" ]; then
  footer=$(cat "$TEST_ROOT/.claude/tmp/additionalContext")
  assert_output_contains "$footer" "MINI-CODER-BRAIN STATUS" "Should still generate footer"
else
  test_fail "Should create additionalContext even with missing files"
fi

test_section "Test 4: Status footer with missing activeContext.md"

# Create other memory files but not activeContext
mkdir -p "$TEST_ROOT/.claude/memory"
cat > "$TEST_ROOT/.claude/memory/productContext.md" <<'EOF'
# Product Context
Test project
EOF

output=$(bash .claude/hooks/conversation-capture-user-prompt.sh 2>&1)
exit_code=$?

assert_exit_code 0 $exit_code "Should handle missing activeContext.md"

test_section "Test 5: Session start with empty .claude directory"

# Clean slate - only .claude/ exists
rm -rf "$TEST_ROOT/.claude/memory" "$TEST_ROOT/.claude/tmp"
mkdir -p "$TEST_ROOT/.claude/memory" "$TEST_ROOT/.claude/tmp"

output=$(bash .claude/hooks/session-start.sh 2>&1)
exit_code=$?

# Should still work, creating necessary files
assert_exit_code 0 $exit_code "Should handle empty .claude directory"
assert_file_exists "$TEST_ROOT/.claude/tmp/session-start-time" "Should create session tracking"

test_summary
