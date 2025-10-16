# Mini-CoderBrain Test Suite

**Purpose**: Comprehensive testing for all hooks, commands, and edge cases before production deployment.

---

## Test Structure

```
.claude/tests/
├── README.md                    # This file
├── run-tests.sh                 # Main test runner
├── test-helpers.sh              # Shared test utilities
├── hooks/
│   ├── test-session-start.sh
│   ├── test-user-prompt.sh
│   ├── test-stop-hook.sh
│   └── test-pre-compact.sh
├── commands/
│   ├── test-init-memory-bank.sh
│   ├── test-update-memory-bank.sh
│   ├── test-memory-sync.sh
│   ├── test-context-update.sh
│   ├── test-memory-cleanup.sh
│   └── test-metrics.sh
└── edge-cases/
    ├── test-missing-files.sh
    ├── test-corrupted-data.sh
    ├── test-permissions.sh
    └── test-cross-platform.sh
```

---

## Running Tests

### Run All Tests
```bash
bash .claude/tests/run-tests.sh
```

### Run Specific Test Category
```bash
bash .claude/tests/run-tests.sh hooks
bash .claude/tests/run-tests.sh commands
bash .claude/tests/run-tests.sh edge-cases
```

### Run Individual Test
```bash
bash .claude/tests/hooks/test-session-start.sh
bash .claude/tests/commands/test-metrics.sh
```

---

## Test Coverage

### Hooks (4 tests)
- ✅ session-start.sh - Context loading, profile detection, boot status
- ✅ conversation-capture-user-prompt.sh - Enhanced status footer, all 9 metrics
- ✅ stop.sh - Session summary, activeContext update
- ✅ pre-compact-umb-sync.sh - Auto-sync before compaction

### Commands (6 tests)
- ✅ /init-memory-bank - Fresh initialization, template creation
- ✅ /update-memory-bank - Memory updates with notes
- ✅ /memory-sync - Full/quick sync modes
- ✅ /context-update - Focus/blocker/priority/achievement updates
- ✅ /memory-cleanup - Archive old data, prevent bloat
- ✅ /metrics - Session/weekly reports, jq optional

### Edge Cases (4 tests)
- ✅ Missing files - Graceful fallbacks
- ✅ Corrupted data - Error handling
- ✅ Permissions - Read/write issues
- ✅ Cross-platform - Linux vs macOS stat commands

---

## Test Approach

### Unit Tests
Test individual functions/scripts in isolation:
- Hook output format
- Command exit codes
- File creation/modification
- Error handling

### Integration Tests
Test workflows across multiple components:
- Session lifecycle (start → work → stop)
- Memory update flow (update → sync → cleanup)
- Status footer accuracy (metrics match reality)

### Edge Case Tests
Test failure scenarios and edge cases:
- Missing .claude/ directory
- Empty memory files
- Corrupted JSON
- No write permissions
- jq not installed

---

## Test Assertions

### Success Criteria
- ✅ Exit code 0 for successful operations
- ✅ Expected output format
- ✅ Files created/modified correctly
- ✅ No unexpected errors

### Failure Handling
- ❌ Exit code non-zero for errors
- ❌ Helpful error messages
- ❌ Graceful degradation
- ❌ No data corruption

---

## Test Environment

Tests run in isolated environment:
- Temporary test directory
- Clean .claude/ structure
- No interference with actual project
- Cleanup after tests

---

## CI/CD Integration

Tests can be integrated with:
- GitHub Actions
- GitLab CI
- Pre-commit hooks
- Manual QA workflow

---

**Next**: Run `bash .claude/tests/run-tests.sh` to execute all tests.
