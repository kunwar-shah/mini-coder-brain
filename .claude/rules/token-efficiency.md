# Token Efficiency Rules

**Purpose**: Prevent "Prompt is too long" errors in Claude Code v2

---

## Critical Rules

### 1. Context Injection Limits
- **Session Start**: MAX 4-5 lines output
- **Micro-Context**: MAX 3-4 lines (< 200 chars)
- **Stop Hook**: Update files, don't output verbose logs

### 2. Memory Bank Size Limits
- **productContext.md**: < 2KB (high-level overview only)
- **activeContext.md**: < 3KB (current focus + recent only)
- **progress.md**: < 2KB (summarize old history)
- **decisionLog.md**: Unlimited (append-only, read on demand)

### 3. Hook Output Rules
- Output only what AI needs RIGHT NOW
- Full context lives in files, not hook output
- Reference files with paths, don't duplicate content

### 4. Forbidden Patterns
❌ Never dump entire files in hook output
❌ Never inject > 1000 chars in micro-context
❌ Never output verbose logs to session
❌ Never duplicate memory bank content

### 5. Smart Injection
✅ Check file size before injecting
✅ Skip injection if > 1000 chars
✅ Always provide fallback minimal output
✅ Save to files even if not injected

---

## Implementation

```bash
# Check size before injection
micro_size=$(wc -c < "$file" 2>/dev/null || echo "9999")
if [ "$micro_size" -lt 1000 ]; then
    # Inject
else
    # Skip, preserve tokens
fi
```

---

**Remember**: Concise is sustainable. Verbose causes "Prompt too long"! 🎯
