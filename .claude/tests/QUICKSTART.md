# Test Suite Quick Start

## Current Status

The test suite is **partially functional**. Some tests work, some need refinement.

---

## What Works ✅

### `/metrics` Command Tests
```bash
bash .claude/tests/commands/test-metrics.sh
```
- ✅ Works without jq
- ✅ Shows all metrics sections
- ✅ Cross-platform compatible
- ✅ Handles missing data gracefully

### Edge Case Tests (Partial)
```bash
bash .claude/tests/edge-cases/test-missing-files.sh
bash .claude/tests/edge-cases/test-cross-platform.sh
```
- ✅ Missing file handling
- ✅ Cross-platform stat commands
- ✅ Line ending checks

---

## What Needs Work ⚠️

### Hook Tests
The hook tests need refinement because:
- Hooks expect to run in Claude Code environment
- Some hooks read from stdin (need mock input)
- Some hooks depend on Claude Code injecting data

**Recommendation**: Test hooks manually in real Claude Code session for now.

---

## Manual Testing Guide

### Test Enhanced Status Footer
1. Open Mini-CoderBrain project in Claude Code
2. Send any message
3. Check footer shows all 9 metrics:
   - Activity count
   - Map status
   - Context status
   - Profile
   - Session duration (not 0m)
   - Current focus
   - Memory health
   - Last sync time (not "0m ago")
   - Tool usage

### Test `/metrics` Command
1. Run: `/metrics`
2. Should show session report with:
   - Date, duration, profile
   - Tool usage breakdown
   - Memory health
   - Sync status
   - Map status

### Test Memory Commands
1. Run: `/update-memory-bank "test update"`
2. Check: `Last sync` in footer updates
3. Run: `/memory-cleanup`
4. Check: Old session updates archived

### Test Session Lifecycle
1. Start session → Check boot status
2. Work for a while → Check activity count increases
3. End session → Check activeContext updated

---

## Running Tests

### Run All Tests (Some Will Fail)
```bash
bash .claude/tests/run-tests.sh all
```

### Run Working Tests Only
```bash
# Metrics tests (mostly work)
bash .claude/tests/commands/test-metrics.sh

# Edge case tests (mostly work)
bash .claude/tests/edge-cases/test-missing-files.sh
bash .claude/tests/edge-cases/test-cross-platform.sh
```

---

## Known Issues

1. **Hook Tests Fail**: Hooks expect Claude Code environment
   - **Fix**: Mock stdin input, environment variables
   - **Workaround**: Test manually in real session

2. **Some Assertions Too Strict**: Minor output differences
   - **Fix**: Loosen assertion patterns
   - **Workaround**: Check test output manually

3. **Test Environment Differences**: Temp dirs, paths
   - **Fix**: Better environment setup
   - **Workaround**: Run hooks from project root

---

## Priority for v2.1 Release

**HIGH PRIORITY**:
- ✅ `/metrics` command works
- ✅ Enhanced status footer works
- ✅ Cross-platform compatibility
- ✅ Edge case handling

**MEDIUM PRIORITY**:
- ⚠️ Automated hook testing
- ⚠️ Full command testing
- ⚠️ CI/CD integration

**LOW PRIORITY**:
- ⏸️ 100% test coverage
- ⏸️ Performance benchmarks
- ⏸️ Stress testing

---

## Recommendation

**For v2.1 release**:
1. Manual testing in real project (CRITICAL)
2. Basic automated tests pass (metrics, edge cases)
3. Known issues documented
4. Test suite refined in v2.2

**The most valuable testing**: Use Mini-CoderBrain on a real project for a full day and see what breaks!
