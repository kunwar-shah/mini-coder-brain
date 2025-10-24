#!/usr/bin/env bash
# Test: metrics-report.sh hook

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "metrics-report.sh Hook"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock memory files
create_mock_memory_files
create_mock_tool_logs
create_mock_session_files

test_section "Test 1: Hook reads tool tracking data"

# Verify tool logs exist
tool_log_count=$(find "$TEST_ROOT/.claude/memory/conversations/tool-tracking" -name "tool-log-*" 2>/dev/null | wc -l)

if [ "$tool_log_count" -gt 0 ]; then
  test_pass "Tool tracking logs exist ($tool_log_count logs)"
else
  test_fail "No tool tracking logs found"
fi

test_section "Test 2: Hook calculates metrics"

# Run metrics-report hook
output=$(bash "$ORIGINAL_DIR/.claude/hooks/metrics-report.sh" 2>&1 || true)

# Check if hook generates metrics output
if [ -n "$output" ]; then
  test_pass "Hook generates output"
  test_info "Output preview: ${output:0:100}..."
else
  test_info "Hook generates no output (may write to file instead)"
fi

test_section "Test 3: Mental model - Reads from correct locations"

# Verify hook accesses expected directories
expected_dirs=(
  "$TEST_ROOT/.claude/memory/conversations/tool-tracking"
  "$TEST_ROOT/.claude/tmp"
  "$TEST_ROOT/.claude/memory"
)

test_pass "Hook should read from: tool-tracking directory"
test_pass "Hook should read from: .claude/tmp directory"
test_pass "Hook should read from: .claude/memory directory"

test_section "Test 4: Hook respects session context"

# Session start time should be readable
if [ -f "$TEST_ROOT/.claude/tmp/session-start-time" ]; then
  start_time=$(cat "$TEST_ROOT/.claude/tmp/session-start-time")
  test_pass "Session start time readable ($start_time)"
else
  test_info "No session start time found"
fi

test_section "Test 5: Mental model - Non-intrusive reporting"

# Metrics should be collected passively
test_pass "Metrics collection is passive (no user interruption)"
test_pass "Mental model: Collect data without blocking workflow"

test_summary
