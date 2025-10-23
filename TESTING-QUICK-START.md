# Testing Quick Start Guide

## 🎯 Two Ways to Use Claude Code

### 1️⃣ Enhanced UI (VS Code Welcome Screen)
**How**: Click Claude Code icon (top right) on VS Code welcome screen

**What You See**:
- ❌ NO session-start output
- ❌ NO status line
- ❓ Footer may appear
- Clean, minimal interface

**Use For**: Regular development (after testing passes)

### 2️⃣ CLI Mode (Terminal) ← **USE THIS FOR TESTING**
**How**: Run `claude` or `claude --resume` in terminal

**What You See**:
- ✅ Session-start output (boot status)
- ✅ Status line in terminal bar
- ✅ Footer at end of responses
- ✅ Full technical visibility

**Use For**: Testing, debugging, validation

---

## ⚡ Quick Testing Steps

### Step 1: Start in CLI Mode
```bash
# In terminal:
claude
```

### Step 2: Basic Test (2 minutes)
```
Say: "Hello, what project are we working on?"

Expected:
✅ Claude knows: Mini-CoderBrain
✅ Claude knows tech stack: Bash, Markdown
✅ Footer appears at end
✅ No "SessionStart:compact hook error"
```

### Step 3: Tool Tracking Test (1 minute)
```
Say: "Read CLAUDE.md and tell me the version"

Expected:
✅ Activity count increases in footer
✅ Tool tracking working
```

### Step 4: Verify in Terminal
```bash
# Check activity logged:
today=$(date '+%Y-%m-%d')
cat .claude/memory/conversations/tool-tracking/${today}-tools.log

# Should show entries
```

---

## 🔍 Running Specific Tests

### In Terminal (Best Method)
```bash
# Integration tests:
bash .claude/tests/integration/run-all.sh

# Production verification:
bash .claude/tests/production-verification.sh

# Specific test:
bash .claude/tests/integration/test-01-session-lifecycle.sh
```

### In Claude Conversation
```
"Run integration tests"
"Run production verification"
"Test session lifecycle"
```

---

## 🐛 Quick Debugging

### Enable Debug Mode
```bash
export MCB_DEBUG=1
```

### Check Logs
```bash
# Hook logs:
tail -20 logs/session-start.jsonl
tail -20 logs/stop.jsonl

# Tool tracking:
today=$(date '+%Y-%m-%d')
cat .claude/memory/conversations/tool-tracking/${today}-tools.log
```

### Test Hook Manually
```bash
# Test any hook:
echo '{}' | bash .claude/hooks/session-start.sh
echo "Exit: $?"  # Must be 0
```

---

## 📚 Full Documentation

- **End-to-End Testing**: `.claude/docs/END-TO-END-TESTING.md` (moved to test-docs)
- **Debugging Guide**: `.claude/docs/DEBUGGING-GUIDE.md`
- **Status Line Info**: Moved to test-docs/STATUS-LINE-VS-FOOTER.md

---

## ✅ Success Criteria

After testing in fresh CLI session, you should have:

- ✅ No "SessionStart:compact hook error"
- ✅ Context loads (Claude knows project)
- ✅ Footer in every response
- ✅ Activity count increasing
- ✅ Status line showing in terminal
- ✅ Stop hook updates activeContext.md

---

## 🎬 Next Steps

1. Read documentation in test-docs folder
2. Start fresh session with `claude` command
3. Run basic tests (Steps 1-4 above)
4. If all pass → Deploy to 5-8 projects! 🚀

---

## ⚠️ Important Notes

**For Testing**: Always use CLI mode (`claude`), not Enhanced UI
**Debug Mode**: Only enable when troubleshooting (`export MCB_DEBUG=1`)
**Logs**: Check `logs/*.jsonl` for hook execution
**Status Line v2**: Already configured (no duplication with footer)

---

**Quick Answer to Your Questions**:
- **Running tests**: Use `bash .claude/tests/...` or ask in conversation
- **Debugging**: Enable MCB_DEBUG=1, check logs/*.jsonl
- **Two UIs**: Enhanced = clean (no hooks visible), CLI = full visibility
- **Use CLI mode for all testing and validation!**
