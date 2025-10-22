# Integration Test Framework

## Purpose
Test hooks with **real Claude Code behavior** - simulating actual hook execution environment.

## Test Categories

### 1. Hook Lifecycle Tests
- SessionStart → UserPromptSubmit → PostToolUse → Stop
- PreCompact hook triggers
- SessionEnd hook triggers

### 2. Input Validation Tests
- Valid JSON input
- Empty stdin
- Invalid JSON
- Missing fields
- Malformed data

### 3. Exit Code Tests
- All hooks MUST exit 0
- Never crash with errors
- Graceful degradation

### 4. File Operation Tests
- Memory bank file creation
- activeContext.md updates
- Logging to logs/
- Temp file management

### 5. Data Integrity Tests
- Footer calculations correct
- Session duration accurate
- Activity count tracking
- Notification detection

## Test Structure

```
.claude/tests/integration/
├── test-01-session-lifecycle.sh
├── test-02-input-validation.sh
├── test-03-exit-codes.sh
├── test-04-file-operations.sh
├── test-05-data-integrity.sh
└── helpers/
    ├── mock-stdin.sh
    ├── assert.sh
    └── cleanup.sh
```

## Running Tests

```bash
# Run all integration tests
bash .claude/tests/integration/run-all.sh

# Run specific test
bash .claude/tests/integration/test-01-session-lifecycle.sh
```

## Expected Results

✅ **100% Pass Rate** - All hooks must pass all tests
✅ **Exit Code 0** - Never crash, always graceful
✅ **Data Accuracy** - Calculations within 1% error
✅ **File Safety** - No corruption, proper permissions
