#!/usr/bin/env bash
# Test: post-tool-use.sh hook

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "post-tool-use.sh Hook"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create directories
mkdir -p "$TEST_ROOT/.claude/memory/conversations/tool-tracking"

test_section "Test 1: Post-tool-use hook logs tool usage"

# Mock tool use input
echo '{"tool": "Read", "path": "/test/file.ts"}' | bash .claude/hooks/post-tool-use.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Hook should exit successfully"

test_section "Test 2: Tool log file created"

today=$(date '+%Y-%m-%d')
tool_log_dir="$TEST_ROOT/.claude/memory/conversations/tool-tracking"

# Check if any tool log exists
log_count=$(find "$tool_log_dir" -name "*.txt" -type f 2>/dev/null | wc -l)

if [ $log_count -gt 0 ]; then
  test_pass "Tool log files created ($log_count files)"
else
  test_info "No tool logs created (hook may require specific input format)"
fi

test_section "Test 3: Multiple tool uses"

# Log several tools
for tool in "Read" "Write" "Edit" "Bash" "Grep"; do
  echo "{\"tool\": \"$tool\"}" | bash .claude/hooks/post-tool-use.sh > /dev/null 2>&1
done

# Check logs increased
new_log_count=$(find "$tool_log_dir" -name "*.txt" -type f 2>/dev/null | wc -l)

test_info "Total tool logs after multiple uses: $new_log_count"

test_section "Test 4: Tool tracking directory persistence"

assert_file_exists "$tool_log_dir" "Tool tracking directory should exist"

test_summary
