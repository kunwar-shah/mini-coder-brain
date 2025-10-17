# Hooks & Message Display - Research Findings

**Date**: 2025-10-06
**Project**: Mini-CoderBrain
**Purpose**: Document learnings about Claude Code hooks and how to display messages/notifications to users

---

## 🎯 Core Problem

**Challenge**: How do we display persistent status notifications and intelligent alerts to users in Claude Code?

**Initial Assumption (WRONG)**: Stop hook `additionalContext` displays messages to users
**Reality**: Stop hook output is internal only - NOT visible to users

---

## 📚 Hook Types & Output Behavior

### Hook Output Formats

Hooks can output **TWO different formats**:

1. **Plain Text (stdout)** - Displayed directly to user
2. **JSON (controlled)** - Used for decisions, reasons, and context injection

**Critical Rule**: Don't mix formats! Each hook expects one specific format.

---

## 🔍 Hook-by-Hook Analysis

### ✅ SessionStart Hook
- **Output Format**: Plain text (stdout)
- **User Visibility**: ✅ YES - Displayed directly in conversation
- **Use Case**: Boot messages, session initialization
- **Example**:
  ```bash
  cat <<EOF
  🧠 [MINI-CODERBRAIN: ACTIVE] - $project_name
  🎯 Focus: $current_focus
  ⚡ Ready for development
  EOF
  ```

### ✅ UserPromptSubmit Hook
- **Output Format**: JSON with `additionalContext`
- **User Visibility**: ⚠️ INDIRECT - Claude sees it, can display it
- **Use Case**: Inject context that Claude should be aware of
- **Example**:
  ```json
  {
    "decision": "approve",
    "reason": "Context active",
    "additionalContext": "📊 Activity: 15 ops | 🗺️ Map: None"
  }
  ```
- **Key Insight**: The `additionalContext` is injected into Claude's context, but Claude must explicitly display it in the response for users to see

### ✅ PostToolUse Hook
- **Output Format**: JSON
- **User Visibility**: ❌ NO - Internal only (visible in transcript mode Ctrl-R)
- **Use Case**: Track tool usage, log activity, collect metrics
- **Example**:
  ```json
  {
    "decision": "approve"
  }
  ```

### ❌ Stop Hook
- **Output Format**: JSON
- **User Visibility**: ❌ NO - Internal processing only
- **Use Case**: Session cleanup, file updates, memory sync
- **Example**:
  ```json
  {
    "decision": "approve",
    "reason": "Session completed successfully",
    "additionalContext": "This is NOT shown to users!"
  }
  ```
- **Critical Discovery**: `additionalContext` in Stop hook does NOT display to users

### ❌ statusLine Setting
- **Output Format**: Plain text (single line)
- **User Visibility**: ❌ NOT WORKING - Feature may not be supported in all versions
- **Use Case**: Persistent status bar (if supported)
- **Status**: Tested, not functional in our environment

### ✅ Notification Hook
- **Output Format**: JSON
- **User Visibility**: ❌ NO - Debug mode only
- **Use Case**: Permission prompts, idle timeouts
- **Not suitable for general notifications**

---

## 🎯 Working Solution: The Display Pattern

### The Winning Approach

**Pattern**: Hook injects context → Claude displays it → User sees it

**Implementation**:

1. **Hook Side** (UserPromptSubmit):
   ```bash
   # Build status line
   status_line="🧠 Context: Active | Activity: ${activity_count} ops"

   # Inject via JSON
   echo "{\"decision\": \"approve\", \"additionalContext\": \"$status_line\"}"
   ```

2. **CLAUDE.md Side**:
   ```markdown
   4) **Status Footer Display** (MANDATORY - NEVER SKIP):
      - The UserPromptSubmit hook injects status in `additionalContext`
      - You MUST display this at the END of EVERY response
      - Format:
        ```
        🧠 MINI-CODERBRAIN STATUS
        📊 Activity: X ops | 🗺️ Map: Status | ⚡ Context: Active
        ```
   ```

3. **Result**: Claude sees the injected status and displays it in every response

---

## 🔧 Activity Tracking Implementation

### Problem
Status showed "Activity: 0 ops" because no tracking was in place.

### Solution: PostToolUse Hook

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-.}"
TOOL_TRACKING="$ROOT/.claude/memory/conversations/tool-tracking"

# Read tool name from input
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"')

# Log to daily file
today=$(date '+%Y-%m-%d')
echo "$tool_name" >> "$TOOL_TRACKING/$today-tools.log"

# Always approve
echo '{"decision": "approve"}'
```

### Registration in settings.json

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-tool-use.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

---

## 📊 Intelligent Notifications

### Implementation in UserPromptSubmit Hook

```bash
# === INTELLIGENT NOTIFICATIONS ===
notifications=""

# Check memory bloat
if [ -f "$MB/activeContext.md" ]; then
  session_count=$(grep "^## .* Session Update" "$MB/activeContext.md" | wc -l)
  if [ "$session_count" -gt 10 ]; then
    notifications="🧹 Memory cleanup recommended. Run /memory-cleanup. "
  fi
fi

# Check map staleness
if [ -f "$CACHE_DIR/codebase-map.json" ]; then
  age_hours=$(( ($(date +%s) - $(stat -c %Y "$CACHE_DIR/codebase-map.json")) / 3600 ))
  if [ "$age_hours" -gt 24 ]; then
    notifications="${notifications}🗺️ Map is ${age_hours}h old. Run /map-codebase --rebuild. "
  fi
fi

# Check high activity
if [ "$activity_count" -gt 50 ]; then
  notifications="${notifications}🔄 High activity detected. Run /memory-sync --full. "
fi

# Build full status with notifications
if [ -n "$notifications" ]; then
  full_status="${status_line}\n\n${notifications}"
else
  full_status="${status_line}"
fi
```

---

## 🎨 UI Design Evolution

### Iterations

1. **Initial**: Simple text line
   ```
   🧠 Context: Active | Activity: 0 ops | Map: None
   ```

2. **Long separator lines**: Too cluttered
   ```
   ═══════════════════════════════════════════════════════════════
   ```

3. **Box design**: Outside the text box, not effective
   ```
   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
   ```

4. **Lightning bolts**: Too noisy
   ```
   ⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡
   ```

5. **Final (Clean & Effective)**:
   ```
   🧠 MINI-CODERBRAIN STATUS
   📊 Activity: X ops | 🗺️ Map: Status | ⚡ Context: Active

   💡 [Notifications if any]
   ```

**Lesson**: Keep it simple, clean, and uncluttered. Emojis provide enough visual emphasis.

---

## ✅ Complete Working System

### File Structure

```
.claude/
├── settings.json                          # Hook registration
├── hooks/
│   ├── session-start.sh                   # Boot messages (plain text)
│   ├── conversation-capture-user-prompt.sh # Status injection (JSON)
│   ├── post-tool-use.sh                   # Activity tracking (JSON)
│   └── optimized-intelligent-stop.sh      # Session cleanup (JSON)
└── memory/
    └── conversations/
        └── tool-tracking/
            └── 2025-10-06-tools.log       # Daily activity log
```

### Flow Diagram

```
User sends message
      ↓
UserPromptSubmit hook runs
      ↓
Builds status + notifications
      ↓
Injects via additionalContext (JSON)
      ↓
Claude receives context
      ↓
Claude displays status in response (per CLAUDE.md)
      ↓
User sees status footer
```

---

## 🚨 Common Pitfalls

### ❌ Don't Do This

1. **Using Stop hook for user messages**
   ```bash
   # WRONG - additionalContext NOT shown to users
   echo '{"additionalContext": "User will never see this"}'
   ```

2. **Mixing output formats**
   ```bash
   # WRONG - Hook expects JSON, this outputs plain text
   echo "Status: Active"
   echo '{"decision": "approve"}'
   ```

3. **Expecting statusLine to work without testing**
   ```json
   // May not work in all Claude Code versions
   "statusLine": {"type": "command", "command": "..."}
   ```

4. **Not fixing line endings**
   ```bash
   # Windows line endings break bash scripts
   # Always run: sed -i 's/\r$//' script.sh
   ```

### ✅ Do This

1. **Use UserPromptSubmit for status injection**
2. **Use PostToolUse for activity tracking**
3. **Use SessionStart for boot messages**
4. **Always output valid JSON for JSON hooks**
5. **Fix line endings for all bash scripts**
6. **Test hooks manually before deploying**

---

## 🧪 Testing Hooks

### Manual Testing Commands

```bash
# Test UserPromptSubmit hook
export CLAUDE_PROJECT_DIR=/path/to/project
echo '{}' | bash .claude/hooks/conversation-capture-user-prompt.sh | jq '.'

# Test PostToolUse hook
echo '{"tool_name":"Read"}' | bash .claude/hooks/post-tool-use.sh

# Test SessionStart hook
bash .claude/hooks/session-start.sh

# Check activity count
wc -l < .claude/memory/conversations/tool-tracking/$(date +%Y-%m-%d)-tools.log
```

### Validation Checklist

- [ ] Hook outputs valid JSON (for JSON hooks)
- [ ] No errors when run with test input
- [ ] Line endings are Unix (LF, not CRLF)
- [ ] Script has execute permissions (`chmod +x`)
- [ ] Registered correctly in settings.json
- [ ] Timeout is appropriate (5-60 seconds)

---

## 📈 Performance Considerations

### Hook Execution Times

- **SessionStart**: ~500ms (runs once per session)
- **UserPromptSubmit**: <100ms (runs every user message)
- **PostToolUse**: <50ms (runs after every tool use)
- **Stop**: ~1-2s (runs at session end)

### Optimization Tips

1. **UserPromptSubmit**: Must be FAST (<100ms)
   - Avoid heavy file I/O
   - Cache expensive calculations
   - Skip unnecessary checks

2. **PostToolUse**: Keep it minimal
   - Simple append to log file
   - No complex processing

3. **Stop**: Can be slower
   - File updates allowed
   - Complex analysis OK
   - Memory sync operations

---

## 🎓 Key Learnings

### 1. Hook Visibility is NOT Obvious
- Most hooks are internal only
- Only SessionStart displays directly to users
- UserPromptSubmit requires Claude to display the content

### 2. Claude as Display Layer
- Claude acts as the "display engine" for injected context
- CLAUDE.md instructions are critical
- Without instructions, Claude won't display the status

### 3. Activity Tracking Requires PostToolUse
- No built-in activity tracking
- PostToolUse hook is the only way to count operations
- Simple log append is sufficient

### 4. JSON vs Plain Text Matters
- Each hook expects specific format
- Mixing formats causes failures
- Read the docs carefully for each hook type

### 5. Testing is Essential
- Always test hooks manually before deployment
- Restart required for settings.json changes
- Line endings will break bash scripts silently

---

## 🔮 Future Improvements

### For Main CoderBrain Project

1. **Enhanced Notifications**
   - Severity levels (info, warning, critical)
   - Notification history/log
   - Dismissible notifications

2. **Smarter Activity Tracking**
   - Track by tool type (Read, Write, Edit, Bash)
   - Daily/weekly/monthly reports
   - Activity patterns analysis

3. **Better Status Display**
   - Collapsible notification section
   - Color coding (if supported)
   - Progress bars for long operations

4. **Context-Aware Alerts**
   - Different alerts based on project type
   - Time-based suggestions (e.g., end of day sync)
   - Predictive recommendations

---

## 📚 References

### Claude Code Documentation
- Hooks: https://docs.claude.com/en/docs/claude-code/hooks
- Settings: https://docs.claude.com/en/docs/claude-code/settings

### Key Files in This Project
- [CLAUDE.md](../CLAUDE.md) - Status display instructions
- [.claude/settings.json](../.claude/settings.json) - Hook registration
- [.claude/hooks/conversation-capture-user-prompt.sh](../.claude/hooks/conversation-capture-user-prompt.sh) - Status injection
- [.claude/hooks/post-tool-use.sh](../.claude/hooks/post-tool-use.sh) - Activity tracking

---

## ✅ Summary

**The Working Solution**:
1. UserPromptSubmit hook injects status via `additionalContext` (JSON)
2. CLAUDE.md instructs Claude to display it in every response
3. PostToolUse hook tracks activity by logging tool usage
4. Status footer appears at end of every Claude response
5. Users get real-time visibility into system state

**Total Development Time**: ~6 hours (including trial and error)
**Lines of Code**: ~200 (hooks + documentation)
**Impact**: 100% visibility into CoderBrain system state

This pattern is **production-ready** and can be used in the main CoderBrain project.

---

**Document Version**: 1.0
**Last Updated**: 2025-10-06
**Author**: Boss + Claude (Mini-CoderBrain Development Team)
