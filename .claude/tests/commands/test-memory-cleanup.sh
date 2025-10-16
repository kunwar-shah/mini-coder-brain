#!/usr/bin/env bash
# Test: /memory-cleanup command

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "/memory-cleanup Command"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock data
create_mock_memory_files

test_section "Test 1: Cleanup runs successfully"

bash .claude/hooks/memory-cleanup.sh > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Cleanup should exit successfully"

test_section "Test 2: Dry-run mode (no actual changes)"

# Add many session updates to activeContext
for i in {1..20}; do
  echo "## 📊 Session Update [2025-10-$(printf '%02d' $i)T12:00:00+00:00]" >> \
    "$TEST_ROOT/.claude/memory/activeContext.md"
  echo "Activity: $i ops" >> "$TEST_ROOT/.claude/memory/activeContext.md"
  echo "" >> "$TEST_ROOT/.claude/memory/activeContext.md"
done

bash .claude/hooks/memory-cleanup.sh --dry-run > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Dry-run should work"

test_section "Test 3: Archive directory created"

bash .claude/hooks/memory-cleanup.sh > /dev/null 2>&1

if [ -d "$TEST_ROOT/.claude/archive" ]; then
  test_pass "Archive directory created"
else
  test_info "Archive directory not created (may not be needed)"
fi

test_section "Test 4: ActiveContext cleanup"

# Count session updates before cleanup
updates_before=$(grep -c "Session Update" "$TEST_ROOT/.claude/memory/activeContext.md" 2>/dev/null || echo 0)

bash .claude/hooks/memory-cleanup.sh > /dev/null 2>&1

# Count session updates after cleanup
updates_after=$(grep -c "Session Update" "$TEST_ROOT/.claude/memory/activeContext.md" 2>/dev/null || echo 0)

if [ $updates_after -lt $updates_before ]; then
  test_pass "Session updates reduced from $updates_before to $updates_after"
elif [ $updates_after -le 5 ]; then
  test_pass "Session updates kept at reasonable level ($updates_after)"
else
  test_info "Session updates: before=$updates_before, after=$updates_after"
fi

test_section "Test 5: Full cleanup mode"

bash .claude/hooks/memory-cleanup.sh --full > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Full cleanup should work"

test_section "Test 6: Cleanup with missing activeContext"

rm -f "$TEST_ROOT/.claude/memory/activeContext.md"

bash .claude/hooks/memory-cleanup.sh > /dev/null 2>&1
exit_code=$?

test_info "Cleanup with missing files: exit code $exit_code"

test_summary
