# Debugging Guide for Production Claude Code Sessions

## Two UI Modes in Claude Code

### Mode 1: Enhanced UI (VS Code Icon)
**Access**: Click Claude Code icon on VS Code welcome screen (top right)

**Visibility**:
- ❌ NO session-start output visible
- ❌ NO status line visible
- ✅ Footer MAY appear in responses
- ✅ Hooks run silently in background

**Use for**: Regular development (clean interface)

### Mode 2: CLI Mode (Terminal)
**Access**: Run `claude` or `claude --resume` in terminal

**Visibility**:
- ✅ Session-start output shown (boot status)
- ✅ Status line visible in terminal bar
- ✅ Footer visible at end of responses
- ✅ Full technical details

**Use for**: Testing, debugging, troubleshooting

---

## Running Specific Tests in Live Session

### Method 1: Direct Bash Execution
```bash
# In terminal (recommended):
bash .claude/tests/integration/test-01-session-lifecycle.sh
bash .claude/tests/integration/test-02-input-validation.sh
bash .claude/tests/production-verification.sh

# Run all integration tests:
bash .claude/tests/integration/run-all.sh
```

### Method 2: Ask Claude in Conversation
```
"Run the integration tests"
"Run production verification checklist"
"Test the session lifecycle"
```

### Method 3: Test Individual Hooks
```bash
# Test any hook manually:
echo '{"test":"data"}' | bash .claude/hooks/session-start.sh
echo '{"session_id":"test"}' | bash .claude/hooks/stop.sh
echo '{"tool_name":"Read"}' | bash .claude/hooks/post-tool-use.sh

# Check exit codes (must be 0):
echo '{}' | bash .claude/hooks/user-prompt-submit.sh
echo "Exit code: $?"  # Should output: 0
```

---

## Debugging in Live Production Session

### Debug Mode: Enable Verbose Logging

**Enable debug mode**:
```bash
# In terminal or ask Claude:
export MCB_DEBUG=1
```

**Debug logs location**:
- `.claude/tmp/status-line-debug.log` - Status line updates
- `logs/*.jsonl` - Hook execution logs
- `.claude/tmp/*.log` - Temporary debug files

**View debug logs**:
```bash
# Status line debug:
tail -f .claude/tmp/status-line-debug.log

# Hook activity:
tail -f logs/session-start.jsonl
tail -f logs/stop.jsonl
tail -f logs/user-prompt-submit.jsonl
```

---

## Common Debugging Scenarios

### Scenario 1: Session Start Not Working

**Symptoms**:
- Claude doesn't know project name
- No boot status displayed
- Context not loaded

**Debug steps**:
```bash
# 1. Check if hook ran:
ls -la .claude/tmp/context-loaded.flag
ls -la .claude/tmp/session-start-time

# 2. Test hook manually:
bash .claude/hooks/session-start.sh

# 3. Check logs:
cat logs/session-start.jsonl | tail -5

# 4. Verify memory files exist:
ls -la .claude/memory/productContext.md
ls -la .claude/memory/activeContext.md
```

**Fix**:
```bash
# If memory files missing, initialize:
bash .claude/commands/init-memory-bank.sh

# If hook has errors, check:
bash .claude/hooks/session-start.sh 2>&1 | head -20
```

---

### Scenario 2: Footer Not Appearing

**Symptoms**:
- No footer at end of AI responses
- Activity count not showing
- Notifications missing

**Debug steps**:
```bash
# 1. Check if user-prompt-submit hook registered:
grep "user-prompt-submit" .claude/settings.json

# 2. Test hook manually:
echo '{"session_id":"test","prompt":"hello"}' | bash .claude/hooks/user-prompt-submit.sh

# 3. Check if using .sh (not .py):
cat .claude/settings.json | grep -A 3 "UserPromptSubmit"

# 4. Verify hook exists and is executable:
ls -la .claude/hooks/user-prompt-submit.sh
```

**Fix**:
```bash
# If hook missing or not executable:
chmod +x .claude/hooks/user-prompt-submit.sh

# If still using .py version, update settings.json to use .sh
```

---

### Scenario 3: Tool Tracking Not Working

**Symptoms**:
- Activity count always 0
- Tool tracking file not created
- PostToolUse hook errors

**Debug steps**:
```bash
# 1. Check tool tracking directory:
ls -la .claude/memory/conversations/tool-tracking/

# 2. Check today's log file:
today=$(date '+%Y-%m-%d')
cat .claude/memory/conversations/tool-tracking/${today}-tools.log

# 3. Test PostToolUse hook:
echo '{"tool_name":"Read","file_path":"test.md"}' | bash .claude/hooks/post-tool-use.sh

# 4. Check logs:
cat logs/post-tool-use.jsonl | tail -5
```

**Fix**:
```bash
# Create directory if missing:
mkdir -p .claude/memory/conversations/tool-tracking

# Test hook manually:
echo '{"tool_name":"Test"}' | bash .claude/hooks/post-tool-use.sh
```

---

### Scenario 4: Stop Hook Not Updating Memory

**Symptoms**:
- activeContext.md not updated at session end
- No session summary created
- Session duration not recorded

**Debug steps**:
```bash
# 1. Check if stop hook registered:
grep "stop.sh" .claude/settings.json

# 2. Test stop hook manually:
echo '{"session_id":"test-123"}' | bash .claude/hooks/stop.sh

# 3. Check activeContext for recent updates:
tail -20 .claude/memory/activeContext.md

# 4. Check logs:
cat logs/stop.jsonl | tail -5
```

**Fix**:
```bash
# Ensure stop.sh is used (not stop.py):
# Edit .claude/settings.json if needed

# Test stop hook:
echo '{}' | bash .claude/hooks/stop.sh
echo "Exit code: $?"  # Must be 0
```

---

### Scenario 5: High Activity Notification Not Showing

**Symptoms**:
- Activity count > 50 ops
- No sync notification in footer
- Last sync > 10 minutes ago

**Debug steps**:
```bash
# 1. Check activity count:
today=$(date '+%Y-%m-%d')
wc -l .claude/memory/conversations/tool-tracking/${today}-tools.log

# 2. Check last sync time:
cat .claude/tmp/last-memory-sync

# 3. Calculate minutes since sync:
last_sync=$(cat .claude/tmp/last-memory-sync)
current_time=$(date +%s)
min_ago=$(( (current_time - last_sync) / 60 ))
echo "Minutes since last sync: $min_ago"

# 4. Test notification logic:
echo '{"session_id":"test"}' | bash .claude/hooks/user-prompt-submit.sh | grep "High activity"
```

**Fix**:
```bash
# Update last sync time:
date +%s > .claude/tmp/last-memory-sync

# Or run memory sync:
# Ask Claude: "Run /memory-sync"
```

---

## Live Debugging Commands

### Check Current Session State
```bash
# Session info:
cat .claude/tmp/session-start-time
cat .claude/tmp/current-profile
cat .claude/tmp/context-loaded.flag

# Activity count:
today=$(date '+%Y-%m-%d')
wc -l .claude/memory/conversations/tool-tracking/${today}-tools.log

# Memory health:
grep -c "## Session Update" .claude/memory/activeContext.md
```

### Verify All Hooks Working
```bash
# Quick test all registered hooks:
for hook in session-start stop user-prompt-submit post-tool-use pre-compact-umb-sync session-end; do
  echo "Testing: $hook.sh"
  echo '{}' | bash .claude/hooks/${hook}.sh >/dev/null 2>&1 && echo "✅ PASS" || echo "❌ FAIL"
done
```

### Check Hook Registration
```bash
# View all registered hooks:
cat .claude/settings.json | grep -A 5 "hooks"

# Verify using .sh (not .py):
cat .claude/settings.json | grep "\.sh"
```

### Monitor Hook Execution in Real-Time
```bash
# Watch logs live:
tail -f logs/*.jsonl

# Watch status line updates:
tail -f .claude/tmp/status-line-debug.log

# Watch tool tracking:
today=$(date '+%Y-%m-%d')
watch -n 1 wc -l .claude/memory/conversations/tool-tracking/${today}-tools.log
```

---

## Using Claude for Debugging

### Ask Claude to Check System State
```
"Check if all hooks are working"
"Show me the last 10 tool tracking entries"
"What's in the session-start log?"
"Check activeContext.md for session updates"
"Verify context-loaded flag exists"
```

### Ask Claude to Run Tests
```
"Run integration tests"
"Run production verification"
"Test the session-start hook"
"Check if stop hook is working"
```

### Ask Claude to Diagnose Issues
```
"Why isn't the footer showing?"
"Why is activity count 0?"
"Debug the user-prompt-submit hook"
"Check for hook errors in logs"
```

---

## Emergency Troubleshooting

### If Everything Breaks
```bash
# 1. Run production verification:
bash .claude/tests/production-verification.sh

# 2. Check all hooks exit 0:
for hook in .claude/hooks/*.sh; do
  echo "Testing: $(basename $hook)"
  echo '{}' | bash "$hook" >/dev/null 2>&1 || echo "❌ FAILED: $(basename $hook)"
done

# 3. Verify hook-patterns library:
bash .claude/tests/test-hook-patterns-lib.sh

# 4. Check settings.json valid JSON:
cat .claude/settings.json | python3 -m json.tool >/dev/null 2>&1 && echo "✅ Valid JSON" || echo "❌ Invalid JSON"
```

### Reset to Clean State
```bash
# WARNING: Removes temporary data
rm -rf .claude/tmp/*
rm -rf .claude/cache/*

# Re-initialize:
bash .claude/hooks/session-start.sh
```

---

## Best Practices

### For Testing
1. ✅ Use CLI mode (`claude`) - full visibility
2. ✅ Enable debug mode (`export MCB_DEBUG=1`)
3. ✅ Monitor logs in separate terminal
4. ✅ Test hooks manually before live testing

### For Debugging
1. ✅ Check logs first (`logs/*.jsonl`)
2. ✅ Test hooks manually (`echo '{}' | bash hook.sh`)
3. ✅ Verify exit codes (must be 0)
4. ✅ Run production verification script

### For Production Use
1. ✅ Use Enhanced UI (clean interface)
2. ✅ Only enable debug mode when troubleshooting
3. ✅ Check footer for notifications
4. ✅ Run `/memory-cleanup` when prompted

---

## Summary

**Two Modes**:
- Enhanced UI: Clean, minimal (for regular use)
- CLI Mode: Full visibility (for testing/debugging)

**Testing**: Use CLI mode + terminal monitoring
**Debugging**: Enable MCB_DEBUG=1 + check logs
**Emergency**: Run production-verification.sh

**Key Insight**: Enhanced UI hides technical details, CLI mode shows everything. For testing Mini-CoderBrain, always use CLI mode!
