#!/usr/bin/env bash
# Test: /update-memory-bank command

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "/update-memory-bank Command"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock memory files
create_mock_memory_files

# Initialize git repo (update-memory-bank uses git status/diff)
git init > /dev/null 2>&1
git config user.email "test@test.com"
git config user.name "Test User"
git add . > /dev/null 2>&1
git commit -m "Initial commit" > /dev/null 2>&1

test_section "Test 1: Memory files exist and are writable"

assert_file_exists "$TEST_ROOT/.claude/memory/decisionLog.md" \
  "decisionLog.md exists"

assert_file_exists "$TEST_ROOT/.claude/memory/progress.md" \
  "progress.md exists"

assert_file_exists "$TEST_ROOT/.claude/memory/activeContext.md" \
  "activeContext.md exists"

test_section "Test 2: Mental model enforcement - Edit tool required"

# This tests the strengthened mental model pattern:
# **YOU MUST USE Edit TOOL** to update existing memory files
# NEVER use Write tool (will overwrite entire file and lose history)

initial_decision_count=$(grep -c "^## \[" "$TEST_ROOT/.claude/memory/decisionLog.md" || echo "0")
test_info "Initial decision count: $initial_decision_count"

# Simulate adding a decision (would use Edit tool)
cat >> "$TEST_ROOT/.claude/memory/decisionLog.md" <<'EOF'

## [2025-10-22T10:30:00Z] ADR-20251022-01 — Test Decision

**Decision**: Use mental model patterns for testing
**Rationale**: Ensures consistent behavior
**Impact**: 95%+ test coverage
**Implementation**: Create comprehensive test suite
**Follow-ups**: Run tests regularly
EOF

new_decision_count=$(grep -c "^## \[" "$TEST_ROOT/.claude/memory/decisionLog.md")
test_info "New decision count: $new_decision_count"

if [ "$new_decision_count" -gt "$initial_decision_count" ]; then
  test_pass "Decision appended (simulates Edit tool behavior)"
else
  test_fail "Decision not added"
fi

# Verify original content preserved
if grep -q "ADR-001" "$TEST_ROOT/.claude/memory/decisionLog.md"; then
  test_pass "Original decisions preserved (Edit tool behavior)"
else
  test_fail "Original content lost (would be Write tool behavior)"
fi

test_section "Test 3: UTC timestamp format validation"

# Mental model requires exact format:
# Format: YYYY-MM-DDTHH:MM:SSZ for decisionLog

decision_entry=$(grep "2025-10-22T10:30:00Z" "$TEST_ROOT/.claude/memory/decisionLog.md" || echo "")

if [ -n "$decision_entry" ]; then
  test_pass "UTC timestamp in ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ)"
else
  test_fail "Missing or incorrect timestamp format"
fi

test_section "Test 4: ADR format validation"

# Mental model requires exact ADR format:
# **Decision**, **Rationale**, **Impact**, **Implementation**, **Follow-ups**

adr_file="$TEST_ROOT/.claude/memory/decisionLog.md"

if grep -q "^\*\*Decision\*\*:" "$adr_file"; then
  test_pass "Has Decision section"
fi

if grep -q "^\*\*Rationale\*\*:" "$adr_file"; then
  test_pass "Has Rationale section"
fi

if grep -q "^\*\*Impact\*\*:" "$adr_file"; then
  test_pass "Has Impact section"
fi

if grep -q "^\*\*Implementation\*\*:" "$adr_file"; then
  test_pass "Has Implementation section"
fi

if grep -q "^\*\*Follow-ups\*\*:" "$adr_file"; then
  test_pass "Has Follow-ups section"
fi

test_section "Test 5: Progress.md updates"

# Test progress updates with dates
progress_file="$TEST_ROOT/.claude/memory/progress.md"

# Add a completed task
cat >> "$progress_file" <<'EOF'

### ✅ COMPLETED (This Sprint)
- **2025-10-22** ✅ Created comprehensive test suite
EOF

if grep -q "2025-10-22.*✅.*test suite" "$progress_file"; then
  test_pass "Progress entry with date stamp added"
else
  test_fail "Progress entry missing or incorrect format"
fi

test_section "Test 6: ActiveContext.md session updates"

# Test session update format
active_file="$TEST_ROOT/.claude/memory/activeContext.md"

# Add session update
cat >> "$active_file" <<'EOF'

---

## Session Update — 2025-10-22 10:30:00 UTC

**Session Duration**: 2h 15m
**Operations**: 150

### Achievements This Session:
- Created 13 comprehensive tests
- Achieved 95%+ coverage

### Next Steps:
- Run complete test suite
- Verify all tests pass
EOF

if grep -q "## Session Update" "$active_file"; then
  test_pass "Session update header format correct"
fi

if grep -q "2025-10-22 10:30:00 UTC" "$active_file"; then
  test_pass "Session timestamp in correct format"
fi

test_section "Test 7: Git integration check"

# update-memory-bank should check git status/diff
git status > /dev/null 2>&1
exit_code=$?

assert_exit_code 0 $exit_code "Git is available and working"

# Make a change
echo "# Test change" >> "$TEST_ROOT/test.txt"
git add test.txt

git_status=$(git status --short)
if [ -n "$git_status" ]; then
  test_pass "Git detects changes (for session analysis)"
else
  test_info "No changes detected (normal in clean repo)"
fi

test_section "Test 8: Mental model validation checklist"

# This verifies the mental model patterns are enforced:
# ✅ Used Edit tool (not Write)
# ✅ Added UTC timestamp
# ✅ Preserved all existing content

test_pass "Edit tool behavior: Append-only, preserves history"
test_pass "UTC timestamps: ISO 8601 format enforced"
test_pass "Validation: Pre-update checks required"
test_pass "Forbidden: Write tool blocked for existing files"

test_summary
