#!/usr/bin/env bash
# Mini-CoderBrain Test Runner
# Runs all tests or specific test categories

set -eu

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Test categories
TEST_CATEGORY="${1:-all}"

# Global test counters
TOTAL_TESTS=0
TOTAL_PASSED=0
TOTAL_FAILED=0
FAILED_TESTS=()

#############################################
# Banner
#############################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  MINI-CODER-BRAIN v2.1 TEST SUITE${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Project Root: $PROJECT_ROOT"
echo "Test Category: $TEST_CATEGORY"
echo ""

# Change to project root
cd "$PROJECT_ROOT"

#############################################
# Run test file
#############################################

run_test_file() {
  local test_file="$1"
  local test_name=$(basename "$test_file" .sh)

  echo ""
  echo -e "${YELLOW}Running: $test_name${NC}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Run test and capture output
  if bash "$test_file"; then
    echo -e "${GREEN}✓ $test_name PASSED${NC}"
    TOTAL_PASSED=$((TOTAL_PASSED + 1))
  else
    echo -e "${RED}✗ $test_name FAILED${NC}"
    TOTAL_FAILED=$((TOTAL_FAILED + 1))
    FAILED_TESTS+=("$test_name")
  fi

  TOTAL_TESTS=$((TOTAL_TESTS + 1))
}

#############################################
# Run test category
#############################################

run_test_category() {
  local category="$1"
  local test_dir="$SCRIPT_DIR/$category"

  if [ ! -d "$test_dir" ]; then
    echo -e "${RED}Error: Test category '$category' not found${NC}"
    return 1
  fi

  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}  TEST CATEGORY: $(echo $category | tr '[:lower:]' '[:upper:]')${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"

  # Find all test files in category
  local test_files=$(find "$test_dir" -name "test-*.sh" -type f | sort)

  if [ -z "$test_files" ]; then
    echo -e "${YELLOW}No tests found in $category${NC}"
    return 0
  fi

  # Run each test file
  for test_file in $test_files; do
    run_test_file "$test_file"
  done
}

#############################################
# Main test execution
#############################################

case "$TEST_CATEGORY" in
  all)
    # Run all test categories
    run_test_category "hooks"
    run_test_category "commands"
    run_test_category "edge-cases"
    ;;
  hooks|commands|edge-cases)
    # Run specific category
    run_test_category "$TEST_CATEGORY"
    ;;
  *)
    echo -e "${RED}Error: Unknown test category '$TEST_CATEGORY'${NC}"
    echo ""
    echo "Usage: bash run-tests.sh [category]"
    echo ""
    echo "Categories:"
    echo "  all         - Run all tests (default)"
    echo "  hooks       - Test hook scripts"
    echo "  commands    - Test slash commands"
    echo "  edge-cases  - Test edge cases"
    echo ""
    exit 1
    ;;
esac

#############################################
# Final summary
#############################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  FINAL TEST SUMMARY${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Total Test Suites: $TOTAL_TESTS"
echo -e "Passed: ${GREEN}$TOTAL_PASSED${NC}"
echo -e "Failed: ${RED}$TOTAL_FAILED${NC}"
echo ""

if [ $TOTAL_FAILED -gt 0 ]; then
  echo -e "${RED}Failed Test Suites:${NC}"
  for test in "${FAILED_TESTS[@]}"; do
    echo -e "  ${RED}✗${NC} $test"
  done
  echo ""
  echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${RED}  TESTS FAILED ✗${NC}"
  echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  exit 1
else
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  ALL TESTS PASSED ✓${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  exit 0
fi
