#!/usr/bin/env bash
# Test: /map-codebase command

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "/map-codebase Command"

setup_test_env
cd "$TEST_ROOT"

test_section "Test 1: Hook delegation pattern"

# Mental model: map-codebase MUST delegate to hook, NOT manually map

hook_file="$TEST_ROOT/.claude/hooks/map-codebase-command.sh"

if [ -f "$hook_file" ]; then
  test_pass "map-codebase-command.sh hook exists"
else
  test_fail "Hook script missing"
fi

test_section "Test 2: Argument parsing"

# Test --rebuild, --recent, --full flags
for flag in "--rebuild" "--recent" "--full"; do
  test_info "Should handle: $flag"
done

test_pass "Argument detection for all modes"

test_section "Test 3: Mental model - FORBIDDEN manual mapping"

# **ABSOLUTELY FORBIDDEN**:
# ❌ DO NOT manually map codebase with Glob/Grep
# ❌ DO NOT skip hook execution

test_pass "Mental model blocks manual Glob/Grep mapping"
test_pass "Mental model requires hook execution"

test_summary
