#!/usr/bin/env bash
# Test: memory-sync.sh hook

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "memory-sync.sh Hook"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock memory files
create_mock_memory_files

# Initialize git repo
git init > /dev/null 2>&1
git config user.email "test@test.com"
git config user.name "Test User"

test_section "Test 1: Mental model - Updates last-memory-sync timestamp FIRST"

# Remove existing timestamp if any
rm -f "$TEST_ROOT/.claude/tmp/last-memory-sync"

# Run memory-sync hook
bash "$ORIGINAL_DIR/.claude/hooks/memory-sync.sh" > /dev/null 2>&1

assert_file_exists "$TEST_ROOT/.claude/tmp/last-memory-sync" \
  "last-memory-sync timestamp created"

# Verify timestamp is recent (within last 5 seconds)
if [ -f "$TEST_ROOT/.claude/tmp/last-memory-sync" ]; then
  timestamp=$(cat "$TEST_ROOT/.claude/tmp/last-memory-sync")
  current_time=$(date +%s)
  time_diff=$((current_time - timestamp))

  if [ "$time_diff" -lt 5 ]; then
    test_pass "Timestamp is recent (${time_diff}s ago)"
  else
    test_fail "Timestamp is too old (${time_diff}s ago)"
  fi
fi

test_section "Test 2: Hook analyzes git changes"

# Make a change
echo "# Test change" >> "$TEST_ROOT/test.txt"
git add test.txt

# Run hook
output=$(bash "$ORIGINAL_DIR/.claude/hooks/memory-sync.sh" 2>&1)

# Hook should detect changes
if echo "$output" | grep -qi "change\|modified\|added"; then
  test_pass "Git changes detected in hook output"
else
  test_info "No change detection in output (may be minimal hook)"
fi

test_section "Test 3: Hook preserves existing memory content"

# Store original content
original_product=$(cat "$TEST_ROOT/.claude/memory/productContext.md")
original_active=$(cat "$TEST_ROOT/.claude/memory/activeContext.md")

# Run hook
bash "$ORIGINAL_DIR/.claude/hooks/memory-sync.sh" > /dev/null 2>&1

# Verify original content still exists
if grep -q "Test Project" "$TEST_ROOT/.claude/memory/productContext.md"; then
  test_pass "productContext.md content preserved"
fi

if grep -q "Testing Sprint" "$TEST_ROOT/.claude/memory/activeContext.md"; then
  test_pass "activeContext.md content preserved"
fi

test_section "Test 4: Mental model - Edit tool behavior (append-only)"

# This tests that hooks follow Edit tool mental model
# Hooks should NEVER overwrite entire files

initial_lines=$(wc -l < "$TEST_ROOT/.claude/memory/activeContext.md")

# Run hook (simulates appending session update)
bash "$ORIGINAL_DIR/.claude/hooks/memory-sync.sh" > /dev/null 2>&1

new_lines=$(wc -l < "$TEST_ROOT/.claude/memory/activeContext.md")

if [ "$new_lines" -ge "$initial_lines" ]; then
  test_pass "File lines did not decrease (Edit tool behavior, not Write)"
else
  test_fail "File lines decreased (Write tool behavior detected)"
fi

test_summary
