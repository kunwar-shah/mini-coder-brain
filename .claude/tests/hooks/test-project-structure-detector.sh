#!/usr/bin/env bash
# Test: project-structure-detector.sh hook

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "project-structure-detector Hook"

setup_test_env
cd "$TEST_ROOT"

test_section "Test 1: Detect Node.js project"

# Create package.json
cat > "$TEST_ROOT/package.json" <<'EOF'
{
  "name": "test-project",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

bash "$TEST_ROOT/.claude/hooks/project-structure-detector.sh" > /dev/null 2>&1

if [ -f "$TEST_ROOT/.claude/memory/project-structure.json" ]; then
  test_pass "Created project-structure.json"
  
  if grep -q "Node.js" "$TEST_ROOT/.claude/memory/project-structure.json"; then
    test_pass "Detected Node.js stack"
  fi
else
  test_fail "project-structure.json not created"
fi

test_section "Test 2: Detect common directory structures"

mkdir -p "$TEST_ROOT/src"
mkdir -p "$TEST_ROOT/tests"
mkdir -p "$TEST_ROOT/lib"

bash "$TEST_ROOT/.claude/hooks/project-structure-detector.sh" > /dev/null 2>&1

structure_file="$TEST_ROOT/.claude/memory/project-structure.json"

if [ -f "$structure_file" ]; then
  if grep -q "src" "$structure_file"; then
    test_pass "Detected src/ directory"
  fi
  
  if grep -q "tests" "$structure_file"; then
    test_pass "Detected tests/ directory"
  fi
fi

test_summary
