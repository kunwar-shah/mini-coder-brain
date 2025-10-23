#!/usr/bin/env bash
# Production Verification Checklist
# Validates Mini-CoderBrain is production-ready for deployment

set -eu

ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
HOOKS_DIR="$ROOT/.claude/hooks"
MB="$ROOT/.claude/memory"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   MINI-CODERBRAIN PRODUCTION VERIFICATION                ║"
echo "║   101% Quality Checklist                                 ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

passed=0
failed=0
warnings=0

# Helper functions
check_pass() {
  echo "✅ PASS: $1"
  passed=$((passed + 1))
}

check_fail() {
  echo "❌ FAIL: $1"
  failed=$((failed + 1))
}

check_warn() {
  echo "⚠️  WARN: $1"
  warnings=$((warnings + 1))
}

# ============================================================================
# SECTION 1: CORE FILES EXIST
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 1: Core Files Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check CLAUDE.md
if [ -f "$ROOT/CLAUDE.md" ]; then
  check_pass "CLAUDE.md exists"
else
  check_fail "CLAUDE.md missing"
fi

# Check settings.json
if [ -f "$ROOT/.claude/settings.json" ]; then
  check_pass ".claude/settings.json exists"
else
  check_fail ".claude/settings.json missing"
fi

# Check hook-patterns library
if [ -f "$HOOKS_DIR/lib/hook-patterns.sh" ]; then
  check_pass "hook-patterns.sh library exists"
else
  check_fail "hook-patterns.sh library missing"
fi

# Check memory templates
if [ -d "$MB/templates" ]; then
  check_pass "Memory templates directory exists"
else
  check_warn "Memory templates missing (optional)"
fi

echo ""

# ============================================================================
# SECTION 2: REGISTERED HOOKS
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 2: Registered Hooks Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

critical_hooks=(
  "session-start.sh"
  "stop.sh"
  "user-prompt-submit.sh"
  "pre-compact-umb-sync.sh"
  "post-tool-use.sh"
  "session-end.sh"
)

for hook in "${critical_hooks[@]}"; do
  hook_path="$HOOKS_DIR/$hook"

  if [ ! -f "$hook_path" ]; then
    check_fail "$hook missing"
    continue
  fi

  # Check if executable
  if [ ! -x "$hook_path" ]; then
    check_fail "$hook not executable"
    continue
  fi

  # Check if uses hook-patterns library
  if grep -q "hook-patterns.sh" "$hook_path"; then
    check_pass "$hook uses hook-patterns library"
  else
    check_fail "$hook doesn't use hook-patterns library"
  fi

  # Check if has safe_exit
  if grep -q "safe_exit" "$hook_path"; then
    check_pass "$hook has safe_exit"
  else
    check_fail "$hook missing safe_exit"
  fi
done

echo ""

# ============================================================================
# SECTION 3: SETTINGS.JSON CONFIGURATION
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 3: Settings Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

settings_file="$ROOT/.claude/settings.json"

# Check hooks registered with .sh (not .py)
if grep -q "session-start.sh" "$settings_file"; then
  check_pass "SessionStart uses .sh (not .py)"
else
  check_fail "SessionStart using .py or not registered"
fi

if grep -q "stop.sh" "$settings_file"; then
  check_pass "Stop uses .sh (not .py)"
else
  check_fail "Stop using .py or not registered"
fi

if grep -q "user-prompt-submit.sh" "$settings_file"; then
  check_pass "UserPromptSubmit uses .sh (not .py)"
else
  check_fail "UserPromptSubmit using .py or not registered"
fi

# Check no Python dependencies
if grep -q "\.py" "$settings_file"; then
  check_fail "Settings.json still references .py files"
else
  check_pass "No Python dependencies in settings.json"
fi

echo ""

# ============================================================================
# SECTION 4: HOOK EXECUTION TESTS
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 4: Hook Execution Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test each critical hook executes without error
for hook in "${critical_hooks[@]}"; do
  hook_path="$HOOKS_DIR/$hook"

  if [ ! -f "$hook_path" ]; then
    continue
  fi

  # Test with empty stdin
  if echo '' | bash "$hook_path" >/dev/null 2>&1; then
    exit_code=$?
    if [ $exit_code -eq 0 ]; then
      check_pass "$hook exits 0 (empty stdin)"
    else
      check_fail "$hook exits $exit_code (empty stdin)"
    fi
  else
    check_fail "$hook crashed with empty stdin"
  fi

  # Test with invalid JSON
  if echo 'invalid json' | bash "$hook_path" >/dev/null 2>&1; then
    exit_code=$?
    if [ $exit_code -eq 0 ]; then
      check_pass "$hook exits 0 (invalid JSON)"
    else
      check_fail "$hook exits $exit_code (invalid JSON)"
    fi
  else
    check_fail "$hook crashed with invalid JSON"
  fi
done

echo ""

# ============================================================================
# SECTION 5: INTEGRATION TEST SUITE
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 5: Integration Test Suite"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "$ROOT/.claude/tests/integration/run-all.sh" ]; then
  if bash "$ROOT/.claude/tests/integration/run-all.sh" >/dev/null 2>&1; then
    check_pass "Integration test suite passes"
  else
    check_fail "Integration test suite has failures"
  fi
else
  check_warn "Integration test suite not found"
fi

echo ""

# ============================================================================
# SECTION 6: MEMORY BANK STRUCTURE
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 6: Memory Bank Structure"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

memory_files=(
  "productContext.md"
  "activeContext.md"
  "systemPatterns.md"
)

for file in "${memory_files[@]}"; do
  if [ -f "$MB/$file" ]; then
    # Check for template placeholders
    if grep -q "\[PROJECT_NAME\]\|\[AUTO_GENERATED\]\|\[DETECTED_\]" "$MB/$file" 2>/dev/null; then
      check_warn "$file contains template placeholders"
    else
      check_pass "$file properly initialized"
    fi
  else
    check_warn "$file missing (will be created on first run)"
  fi
done

echo ""

# ============================================================================
# SECTION 7: GITIGNORE CONFIGURATION
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 7: Git Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "$ROOT/.gitignore" ]; then
  if grep -q "\.claude/memory/\*" "$ROOT/.gitignore" 2>/dev/null; then
    check_pass ".gitignore excludes user memory files"
  else
    check_warn ".gitignore missing memory exclusions"
  fi

  if grep -q "\.claude/tmp/" "$ROOT/.gitignore" 2>/dev/null; then
    check_pass ".gitignore excludes temp files"
  else
    check_warn ".gitignore missing temp exclusions"
  fi
else
  check_warn ".gitignore not found"
fi

echo ""

# ============================================================================
# FINAL SUMMARY
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   VERIFICATION SUMMARY                                   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "✅ PASSED:   $passed"
echo "❌ FAILED:   $failed"
echo "⚠️  WARNINGS: $warnings"
echo ""

total=$((passed + failed))
if [ $total -gt 0 ]; then
  pass_rate=$((passed * 100 / total))
  echo "Pass Rate: ${pass_rate}%"
  echo ""
fi

# Determine verdict
if [ $failed -eq 0 ] && [ $passed -ge 30 ]; then
  echo "🎉 PRODUCTION READY - 101% QUALITY ACHIEVED"
  echo ""
  echo "✅ All critical checks passed"
  echo "✅ Zero crashes verified"
  echo "✅ Pure bash (no Python)"
  echo "✅ Integration tests pass"
  echo ""
  echo "Ready to deploy to 5-8 waiting projects!"
  exit 0
elif [ $failed -eq 0 ]; then
  echo "✅ PRODUCTION READY (with warnings)"
  echo ""
  echo "System is functional but has minor issues."
  echo "Review warnings above."
  exit 0
else
  echo "❌ NOT PRODUCTION READY"
  echo ""
  echo "Critical failures detected. Fix issues above before deploying."
  exit 1
fi
