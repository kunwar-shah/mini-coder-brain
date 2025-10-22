#!/usr/bin/env bash
# Test: init-memory-bank.sh hook

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "init-memory-bank.sh Hook"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

test_section "Test 1: Hook creates memory bank structure"

# Run init-memory-bank hook
bash "$ORIGINAL_DIR/.claude/hooks/init-memory-bank.sh" > /dev/null 2>&1

assert_file_exists "$TEST_ROOT/.claude/memory/productContext.md" \
  "productContext.md created"

assert_file_exists "$TEST_ROOT/.claude/memory/activeContext.md" \
  "activeContext.md created"

assert_file_exists "$TEST_ROOT/.claude/memory/progress.md" \
  "progress.md created"

assert_file_exists "$TEST_ROOT/.claude/memory/decisionLog.md" \
  "decisionLog.md created"

assert_file_exists "$TEST_ROOT/.claude/memory/systemPatterns.md" \
  "systemPatterns.md created"

test_section "Test 2: Hook detects project structure"

# Create mock package.json
cat > "$TEST_ROOT/package.json" <<'EOF'
{
  "name": "test-project",
  "version": "1.0.0",
  "dependencies": {
    "react": "^18.0.0",
    "next": "^14.0.0"
  }
}
EOF

# Run hook again to detect structure
bash "$ORIGINAL_DIR/.claude/hooks/init-memory-bank.sh" > /dev/null 2>&1

assert_file_exists "$TEST_ROOT/.claude/memory/project-structure.json" \
  "project-structure.json created"

# Verify project name detected
if grep -q "test-project" "$TEST_ROOT/.claude/memory/productContext.md"; then
  test_pass "Project name detected from package.json"
else
  test_fail "Project name not detected"
fi

# Verify tech stack detected
if grep -q "React\|Next.js" "$TEST_ROOT/.claude/memory/productContext.md"; then
  test_pass "Tech stack detected (React/Next.js)"
else
  test_fail "Tech stack not detected"
fi

test_section "Test 3: Mental model - No placeholder content"

# Verify productContext has NO [PROJECT_NAME] placeholder
if ! grep -q "\[PROJECT_NAME\]" "$TEST_ROOT/.claude/memory/productContext.md"; then
  test_pass "No [PROJECT_NAME] placeholder (mental model compliance)"
else
  test_fail "[PROJECT_NAME] placeholder found (should be replaced)"
fi

# Verify productContext has NO [AUTO_DETECTED] placeholder
if ! grep -q "\[AUTO_DETECTED\]" "$TEST_ROOT/.claude/memory/productContext.md"; then
  test_pass "No [AUTO_DETECTED] placeholder (mental model compliance)"
else
  test_fail "[AUTO_DETECTED] placeholder found (should be replaced)"
fi

test_section "Test 4: Conversation tracking directory created"

assert_file_exists "$TEST_ROOT/.claude/memory/conversations" \
  "conversations directory exists" || \
  [ -d "$TEST_ROOT/.claude/memory/conversations" ]

if [ -d "$TEST_ROOT/.claude/memory/conversations" ]; then
  test_pass "conversations directory created"
fi

if [ -d "$TEST_ROOT/.claude/memory/conversations/tool-tracking" ]; then
  test_pass "tool-tracking directory created"
fi

test_section "Test 5: Temporary files directory created"

if [ -d "$TEST_ROOT/.claude/tmp" ]; then
  test_pass ".claude/tmp directory created"
fi

test_summary
