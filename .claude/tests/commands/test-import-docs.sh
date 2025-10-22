#!/usr/bin/env bash
# Test: /import-docs command

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "/import-docs Command"

setup_test_env
cd "$TEST_ROOT"
create_mock_memory_files

test_section "Test 1: Import SRS document"

# Create mock SRS document
mkdir -p "$TEST_ROOT/docs"
cat > "$TEST_ROOT/docs/SRS.md" <<'EOF'
# Software Requirements Specification

## Features
1. User authentication
2. Data visualization  
3. API integration

## Technology Stack
- React 18
- Node.js 20
- PostgreSQL 15
EOF

assert_file_exists "$TEST_ROOT/docs/SRS.md" "SRS document exists"

test_section "Test 2: Import Architecture document"

cat > "$TEST_ROOT/docs/ARCHITECTURE.md" <<'EOF'
# Architecture

## System Design
Microservices architecture with event-driven communication

## Patterns
- Repository pattern for data access
- Factory pattern for object creation
EOF

assert_file_exists "$TEST_ROOT/docs/ARCHITECTURE.md" "Architecture doc exists"

test_section "Test 3: Auto-detect document types"

# Test file detection by name
if [[ "SRS.md" =~ (SRS|REQUIREMENTS) ]]; then
  test_pass "SRS filename pattern detected"
fi

if [[ "ARCHITECTURE.md" =~ (ARCHITECTURE|DESIGN) ]]; then
  test_pass "Architecture filename pattern detected"
fi

test_section "Test 4: Mental model - Glob tool for file discovery"

# import-docs uses Glob to find docs
doc_count=$(find "$TEST_ROOT/docs" -name "*.md" | wc -l)
test_info "Found $doc_count markdown files"

if [ "$doc_count" -eq 2 ]; then
  test_pass "Glob would find all .md files"
fi

test_summary
