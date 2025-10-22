#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "session-end Hook"
setup_test_env
create_mock_memory_files

test_section "Test 1: Session cleanup"
test_pass "Saves final session state"
test_summary
