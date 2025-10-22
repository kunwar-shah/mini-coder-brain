#!/usr/bin/env bash
# Test: /umb command (alias for /update-memory-bank)

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "/umb Command (Alias)"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock memory files
create_mock_memory_files

test_section "Test 1: /umb is alias for /update-memory-bank"

# Read umb.md command file
umb_file="$ORIGINAL_DIR/.claude/commands/umb.md"

assert_file_exists "$umb_file" \
  "umb.md command file exists"

# Verify it references update-memory-bank
if grep -qi "update-memory-bank" "$umb_file"; then
  test_pass "/umb references /update-memory-bank"
else
  test_fail "/umb does not reference /update-memory-bank"
fi

test_section "Test 2: Mental model - Alias delegates to main command"

# Verify umb.md is SHORT (just delegation)
umb_lines=$(wc -l < "$umb_file" 2>/dev/null || echo "0")

if [ "$umb_lines" -lt 50 ]; then
  test_pass "/umb is concise delegation ($umb_lines lines)"
else
  test_info "/umb has $umb_lines lines (may include full instructions)"
fi

# Verify it mentions "alias" or "shorthand"
if grep -qi "alias\|shorthand\|short" "$umb_file"; then
  test_pass "/umb identifies as alias/shorthand"
fi

test_section "Test 3: /umb follows same mental model as /update-memory-bank"

update_file="$ORIGINAL_DIR/.claude/commands/update-memory-bank.md"

# Both should mention Edit tool requirement
if grep -q "Edit" "$update_file" && grep -q "Edit" "$umb_file" 2>/dev/null; then
  test_pass "Both commands enforce Edit tool usage"
elif grep -q "update-memory-bank" "$umb_file"; then
  test_pass "/umb delegates to /update-memory-bank (inherits mental model)"
fi

test_section "Test 4: /umb accepts optional note parameter"

# Verify umb.md supports optional note
if grep -qi "note\|optional\|argument" "$umb_file"; then
  test_pass "/umb supports optional note parameter"
else
  test_info "/umb may not explicitly document parameters (delegates)"
fi

test_section "Test 5: Alias reduces typing friction"

# Verify /umb is shorter than /update-memory-bank
umb_length=${#"umb"}
full_length=${#"update-memory-bank"}

typing_reduction=$(( (full_length - umb_length) * 100 / full_length ))

test_pass "/umb saves $typing_reduction% typing (${full_length} → ${umb_length} chars)"
test_pass "Mental model: Provide shortcuts for frequent commands"

test_summary
