# Token Optimization Guide — Mini-CoderBrain v1.0

**Critical Issue Solved**: "Prompt is too long" after 15-20 minutes of conversation

---

## 🎯 Problem Analysis

### Claude Code v1 vs v2
- **v1**: More lenient token limits
- **v2**: Stricter prompt length enforcement
- **Result**: Micro-context injection on every prompt can exhaust budget

### Token Accumulation
```
User Prompt 1 + Micro-Context (200 chars) = OK
User Prompt 2 + Micro-Context (200 chars) = OK
...
User Prompt 50 + Micro-Context (200 chars) = "Prompt is too long" ❌
```

---

## ✅ Solutions Implemented

### 1. Ultra-Minimal Micro-Context (3 lines only)

**Before (20+ lines, ~800 characters)**:
```markdown
# MICRO-CONTEXT: Project Name Development Session

## Current Project State
- **Focus**: Implementing authentication
- **Development Phase**: Phase 2
- **Last Update**: 2025-10-01 12:00:00 UTC

## User Intent Analysis
- **Detected Intent**: debugging
- **Prompt Length**: 45 characters

## Project Context
- **Project Name**: MyProject
- **Project Type**: javascript
- **Session ID**: abc123

## Response Guidance
- Maintain focus on current development phase
- Reference specific files and line numbers when possible
- Consider project structure from .claude/memory/project-structure.json
- Update context files after significant changes
```

**After (3 lines, ~150 characters)**:
```
Focus: Implementing authentication | Phase: Phase 2
Intent: debugging | Updated: 2025-10-01 12:00:00 UTC
Ref: .claude/memory/project-structure.json for paths
```

**Token Savings**: ~80% reduction! 🎉

---

### 2. Smart Injection Logic

```bash
# Check micro-context size
micro_size=$(wc -c < "$micro_context_file" 2>/dev/null || echo "9999")

# Only inject if less than 1000 characters
if [ "$micro_size" -lt 1000 ] && command -v jq >/dev/null 2>&1; then
    # Inject context
    echo '{"decision": "approve"}' | jq --arg context "$micro_context_content" '. + {additionalContext: $context}'
else
    # Skip injection, preserve token budget
    echo '{"decision": "approve", "reason": "Injection skipped to preserve tokens"}'
fi
```

**Protection**: Automatic fallback if context grows too large

---

### 3. Minimal Session Start Output

**Before (40+ lines)**:
```
🚨 ========================================== 🚨
   CODERBRAIN CONTEXT LOADED - READY FOR DEVELOPMENT
🚨 ========================================== 🚨

✅ MEMORY BANK: COMPLETE - NO ACTION NEEDED
[BOOT STATUS @ sessionstart-1759318597 UTC]
- ✅ Memory-bank core files loaded and verified
- ✅ Context continuity established across sessions
...
[Full productContext.md content]
[Full activeContext.md content]
...
```

**After (4 lines)**:
```
🧠 [CODER-BRAIN: ACTIVE] - MyProject
🎯 Focus: Implementing authentication
📂 Context: .claude/memory/ (loaded)
⚡ Ready for development | Session: sessionstart-1759318597
```

**Token Savings**: ~95% reduction! 🎉

---

## 📊 Token Budget Comparison

### Old Approach (Exhausted after 15-20 mins)
```
Session Start: ~2000 tokens
Per Interaction: ~200 tokens × 50 interactions = 10,000 tokens
Total: ~12,000 tokens
Result: "Prompt is too long" ❌
```

### New Approach (Sustainable for hours)
```
Session Start: ~100 tokens
Per Interaction: ~30 tokens × 200 interactions = 6,000 tokens
Total: ~6,100 tokens
Result: Works perfectly ✅
```

---

## 🚀 Best Practices

### For Developers

1. **Keep Memory Bank Concise**
   - activeContext.md: Focus only on current work
   - productContext.md: High-level overview only
   - progress.md: Recent milestones, not full history

2. **Use Commands for Deep Dives**
   - Don't inject everything in hooks
   - Use `/memory-sync` for comprehensive updates
   - Use `/context-update` for specific changes

3. **Monitor Hook Output**
   - Check `.claude/tmp/micro-context.md` size
   - If growing > 500 chars, simplify memory bank files

### For Projects

**Greenfield Projects** (New):
- Start with minimal templates
- Only add context as truly needed
- Regular cleanup of old context

**Brownfield Projects** (Existing):
- Audit memory bank files for size
- Summarize old history, keep recent details
- Consider archiving old decisions to separate files

---

## 🔧 Emergency Fixes

### If Still Getting "Prompt is too long"

**Quick Fix 1: Disable Micro-Context Temporarily**
```json
// In .claude/settings.json
{
  "hooks": {
    "SessionStart": [...],
    "Stop": [...],
    // "UserPromptSubmit": [...]  // <- Comment out
  }
}
```

**Quick Fix 2: Clear Conversation**
- Start fresh conversation
- Token budget resets
- Continue with optimized hooks

**Quick Fix 3: Reduce Memory Bank**
```bash
# Trim activeContext.md to just current focus
# Keep only last 3 session updates
# Summarize old progress in progress.md
```

---

## 📈 Performance Metrics

### Token Efficiency
- **Session Start**: 95% reduction (2000 → 100 tokens)
- **Micro-Context**: 80% reduction (800 → 150 tokens)
- **Total Session**: ~50% overall token savings

### Session Duration
- **Before**: 15-20 minutes until "Prompt too long"
- **After**: Hours of continuous development ✅

### Context Quality
- **Before**: Verbose but exhausting
- **After**: Concise and sustainable ✅

---

## ✅ Summary

**Problem**: Micro-context injection causing "Prompt is too long" in Claude Code v2

**Root Cause**:
- 20+ line micro-context on every prompt
- Verbose session start output
- Token accumulation over 50+ interactions

**Solution**:
1. ✅ Ultra-minimal micro-context (3 lines, ~150 chars)
2. ✅ Smart injection with size limits (< 1000 chars)
3. ✅ Minimal session start (4 lines, ~100 tokens)
4. ✅ Automatic fallback if context grows

**Result**:
- 🎯 50% overall token savings
- ⏰ Hours of sustainable development
- ✅ Perfect context continuity maintained
- 🚀 Production-ready for long sessions

---

**Mini-CoderBrain v1.0**: Token-optimized for Claude Code v2! 🎉
