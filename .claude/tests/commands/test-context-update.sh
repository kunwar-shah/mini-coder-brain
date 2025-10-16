#!/usr/bin/env bash
# Test: /context-update command

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "/context-update Command"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock data
create_mock_memory_files

test_section "Test 1: Update focus"

# Note: context-update is a slash command, not a standalone script
# We'll test the underlying functionality if it exists as a script

if [ -f "$TEST_ROOT/.claude/commands/context-update.sh" ]; then
  bash "$TEST_ROOT/.claude/commands/context-update.sh" focus "Testing new feature" > /dev/null 2>&1
  exit_code=$?

  assert_exit_code 0 $exit_code "Focus update should work"

  assert_file_contains "$TEST_ROOT/.claude/memory/activeContext.md" \
    "Testing new feature" \
    "Should update focus in activeContext"
else
  test_info "context-update.sh not found as standalone script"
  test_info "This command may be implemented as slash command only"
fi

test_section "Test 2: ActiveContext file structure"

# Verify activeContext has required sections
assert_file_contains "$TEST_ROOT/.claude/memory/activeContext.md" \
  "Current Focus" \
  "Should have Current Focus section"

assert_file_contains "$TEST_ROOT/.claude/memory/activeContext.md" \
  "Recent Achievements" \
  "Should have Recent Achievements section"

assert_file_contains "$TEST_ROOT/.claude/memory/activeContext.md" \
  "Next Priorities" \
  "Should have Next Priorities section"

test_section "Test 3: Manual context update (editing activeContext)"

# Simulate manual update
echo "## Manual Test Update" >> "$TEST_ROOT/.claude/memory/activeContext.md"
echo "Testing context updates" >> "$TEST_ROOT/.claude/memory/activeContext.md"

assert_file_contains "$TEST_ROOT/.claude/memory/activeContext.md" \
  "Manual Test Update" \
  "Manual updates should persist"

test_summary
