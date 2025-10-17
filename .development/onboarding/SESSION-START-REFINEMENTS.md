# Session-Start Refinements

**Purpose**: Concrete improvements to make session-start hook better

**Status**: Recommendations for implementation

---

## 🎯 Current Issues

### Issue 1: Too Verbose (400+ Lines of Placeholders)

**Problem**: Session-start hook outputs entire memory file contents including placeholders

**Example (What User Sees)**:
```
<session-start-hook>
# Product Context — [PROJECT_NAME]
**Last Updated**: [AUTO_GENERATED]
[... 100 more lines of template ...]

# Active Context — [PROJECT_NAME]
**Last Updated**: [AUTO_GENERATED]
[... 80 more lines of template ...]

# System Patterns — [PROJECT_NAME]
**Last Updated**: [AUTO_GENERATED]
[... 120 more lines of template ...]

🧠 [MINI-CODERBRAIN: ACTIVE] - PROJECT_NAME
💡 Memory cleanup recommended
</session-start-hook>
```

**Impact**:
- Confusing for users (why so many placeholders?)
- Wastes token budget (400 lines)
- Looks unprofessional
- Hides the actual useful boot status

---

### Issue 2: No Placeholder Detection

**Problem**: Hook doesn't check if memory bank is initialized

**What Should Happen**:
```bash
# If placeholders detected
if grep -q "\[PROJECT_NAME\]" "$MB/productContext.md"; then
    echo "⚠️ Memory bank not initialized. Run: /init-memory-bank"
    exit 0
fi
```

**Current Behavior**: Loads placeholder-filled files anyway

---

### Issue 3: Duplicate Content in Conversation

**Problem**: Files are loaded at session-start AND shown in `<session-start-hook>` tags

**Result**: Same content appears twice in Claude's context

---

### Issue 4: Memory Health Warning Always Shows

**Problem**: "Memory cleanup recommended (12 session updates)" shows even when inappropriate

**When It Shouldn't Show**:
- First session after initialization
- Right after running `/memory-cleanup`
- In demo/testing scenarios

---

## ✅ Proposed Refinements

### Refinement 1: Silent Loading + Concise Boot Status

**Goal**: Load files silently, show ONLY boot status (4 lines)

**Implementation**:

```bash
# File: .claude/hooks/session-start.sh

#!/bin/bash
set -eu

MB=".claude/memory"
TMP=".claude/tmp"

# Create tmp directory
mkdir -p "$TMP"

# Check if memory bank exists
if [ ! -d "$MB" ]; then
    echo "⚠️ Memory bank not found. Run: /init-memory-bank"
    exit 0
fi

# Check if initialized (no placeholders)
if grep -q "\[PROJECT_NAME\]" "$MB/productContext.md" 2>/dev/null; then
    echo "⚠️ Memory bank not initialized. Run: /init-memory-bank"
    echo ""
    echo "📚 Setup takes 60 seconds. Claude will:"
    echo "   1. Detect your tech stack automatically"
    echo "   2. Map your project structure"
    echo "   3. Ask you 3-4 quick questions"
    echo "   4. Save everything to .claude/memory/"
    exit 0
fi

# Load memory files SILENTLY (no output, just load into Claude's context)
# Files are already being loaded by Claude's @-mention system
# We don't need to output their contents again

# Extract key info
PROJECT_NAME=$(grep -m1 "^# Product Context —" "$MB/productContext.md" | sed 's/# Product Context — //')
CURRENT_FOCUS=$(sed -n '/^## 🎯 Current Focus$/,/^---$/p' "$MB/activeContext.md" | sed '1d;$d' | head -n 1)
PROFILE=$(cat "$TMP/current-profile" 2>/dev/null || echo "default")
SESSION_ID="sessionstart-$(date +%s)"

# Save session start time
date +%s > "$TMP/session-start-time"

# Generate concise boot status (4 lines only)
echo "🧠 [MINI-CODERBRAIN: ACTIVE] - $PROJECT_NAME"
echo "🎯 Focus: $CURRENT_FOCUS"
echo "📂 Context: .claude/memory/ (loaded)"
echo "🎭 Profile: $PROFILE"
echo "⚡ Ready for development | Session: $SESSION_ID"

# Memory health check (only if legitimately needed)
SESSION_COUNT=$(grep -c "^## 📊 Session Update" "$MB/activeContext.md" 2>/dev/null || echo "0")
if [ "$SESSION_COUNT" -gt 10 ]; then
    echo ""
    echo "💡 Memory cleanup recommended ($SESSION_COUNT session updates). Run /memory-cleanup to reduce token usage."
fi
```

**Result**: Only ~6 lines output instead of 400+ lines!

---

### Refinement 2: Smart Initialization Detection

**Goal**: Guide users through setup if not initialized

**Implementation**: Already shown in Refinement 1 above

**User Experience**:

**Before Initialization**:
```
⚠️ Memory bank not initialized. Run: /init-memory-bank

📚 Setup takes 60 seconds. Claude will:
   1. Detect your tech stack automatically
   2. Map your project structure
   3. Ask you 3-4 quick questions
   4. Save everything to .claude/memory/
```

**After Initialization**:
```
🧠 [MINI-CODERBRAIN: ACTIVE] - TaskMaster Pro
🎯 Focus: Implementing JWT authentication
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default
⚡ Ready for development | Session: sessionstart-1760693716
```

---

### Refinement 3: Remove Duplicate Content Loading

**Goal**: Files are already @-mentioned by CLAUDE.md, don't output them again

**Current Flow**:
```
1. CLAUDE.md tells Claude to @-mention productContext.md → LOADED ✅
2. session-start.sh outputs productContext.md contents → DUPLICATE ❌
```

**Fixed Flow**:
```
1. CLAUDE.md tells Claude to @-mention productContext.md → LOADED ✅
2. session-start.sh outputs ONLY boot status → CONCISE ✅
```

**Implementation**: Already in Refinement 1 - just remove the `cat` commands

---

### Refinement 4: Conditional Memory Health Warning

**Goal**: Only warn when truly needed

**Logic**:
```bash
# Count session updates
SESSION_COUNT=$(grep -c "^## 📊 Session Update" "$MB/activeContext.md" 2>/dev/null || echo "0")

# Check when last cleanup was done
LAST_CLEANUP=$(cat "$TMP/last-memory-cleanup" 2>/dev/null || echo "0")
TIME_NOW=$(date +%s)
TIME_SINCE_CLEANUP=$(( TIME_NOW - LAST_CLEANUP ))
DAYS_SINCE_CLEANUP=$(( TIME_SINCE_CLEANUP / 86400 ))

# Only warn if:
# - More than 10 session updates AND
# - No cleanup in last 7 days
if [ "$SESSION_COUNT" -gt 10 ] && [ "$DAYS_SINCE_CLEANUP" -gt 7 ]; then
    echo ""
    echo "💡 Memory cleanup recommended ($SESSION_COUNT session updates, last cleanup ${DAYS_SINCE_CLEANUP}d ago)."
    echo "   Run /memory-cleanup to reduce token usage by ~40%."
fi
```

---

### Refinement 5: Progressive Disclosure Boot Status

**Goal**: Show different information based on project state

**States**:
1. **Not Initialized** → Setup prompt
2. **Fresh Project** → Full boot status + welcome
3. **Active Development** → Boot status + current focus
4. **High Activity** → Boot status + memory warning

**Implementation**:

```bash
# Detect state
if grep -q "\[PROJECT_NAME\]" "$MB/productContext.md"; then
    STATE="not_initialized"
elif [ ! -f "$TMP/session-count" ]; then
    STATE="fresh"
    echo "1" > "$TMP/session-count"
elif [ "$SESSION_COUNT" -gt 10 ]; then
    STATE="high_activity"
else
    STATE="active"
    # Increment session count
    PREV_COUNT=$(cat "$TMP/session-count")
    echo $(( PREV_COUNT + 1 )) > "$TMP/session-count"
fi

# Show appropriate message
case "$STATE" in
    not_initialized)
        echo "⚠️ Memory bank not initialized. Run: /init-memory-bank"
        ;;
    fresh)
        echo "🧠 [MINI-CODERBRAIN: ACTIVE] - $PROJECT_NAME"
        echo "🎯 Focus: $CURRENT_FOCUS"
        echo "📂 Context: .claude/memory/ (loaded)"
        echo "🎭 Profile: $PROFILE"
        echo "⚡ Ready for development | Session: $SESSION_ID"
        echo ""
        echo "✨ First session! Memory bank initialized and ready."
        ;;
    active)
        echo "🧠 [MINI-CODERBRAIN: ACTIVE] - $PROJECT_NAME"
        echo "🎯 Focus: $CURRENT_FOCUS"
        echo "📂 Context: .claude/memory/ (loaded)"
        echo "🎭 Profile: $PROFILE"
        echo "⚡ Ready for development | Session: $SESSION_ID"
        ;;
    high_activity)
        echo "🧠 [MINI-CODERBRAIN: ACTIVE] - $PROJECT_NAME"
        echo "🎯 Focus: $CURRENT_FOCUS"
        echo "📂 Context: .claude/memory/ (loaded)"
        echo "🎭 Profile: $PROFILE"
        echo "⚡ Ready for development | Session: $SESSION_ID"
        echo ""
        echo "💡 High activity detected ($SESSION_COUNT session updates)."
        echo "   Consider: /memory-cleanup to optimize token usage."
        ;;
esac
```

---

### Refinement 6: Enhanced Boot Status for Mini-CoderBrain Itself

**Goal**: Make mini-coder-brain's own boot status useful

**Current (Generic)**:
```
🧠 [MINI-CODERBRAIN: ACTIVE] - PROJECT_NAME
🎯 Focus: Enhanced Status Footer (v2.1)...
```

**Better (Specific)**:
```
🧠 [MINI-CODERBRAIN: ACTIVE] - Mini-CoderBrain v2.1
🎯 Focus: Marketing asset creation (ProductHunt launch prep)
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default
⚡ Ready for development | Session: sessionstart-1760693716
📊 Project: 99% complete | Sprint: v2.1 Testing Phase
```

**Implementation**: Fill mini-coder-brain's own productContext.md!

---

## 🚀 Implementation Priority

### Phase 1: Critical (Do Now)
1. **Refinement 1**: Silent loading + concise boot status ⭐⭐⭐
2. **Refinement 2**: Initialization detection ⭐⭐⭐
3. **Refinement 4**: Conditional memory warnings ⭐⭐

### Phase 2: Important (This Week)
4. **Refinement 6**: Fill mini-coder-brain's own memory files ⭐⭐
5. **Refinement 3**: Remove duplicate loading ⭐

### Phase 3: Enhancement (Next Week)
6. **Refinement 5**: Progressive disclosure ⭐

---

## 📝 Implementation Checklist

- [ ] Backup current session-start.sh
- [ ] Implement Refinement 1 (silent loading)
- [ ] Implement Refinement 2 (init detection)
- [ ] Test with uninitialized project
- [ ] Test with initialized project
- [ ] Implement Refinement 4 (conditional warnings)
- [ ] Test memory health detection
- [ ] Run `/init-memory-bank` on mini-coder-brain itself
- [ ] Verify boot status shows real data
- [ ] Document changes in CHANGELOG
- [ ] Update README with new boot status format

---

## 📊 Before/After Comparison

### Before (Current)

**Token Cost**: ~400 lines = ~8,000 tokens
**User Experience**: Confusing (lots of placeholders)
**Professional**: ❌ Looks like broken template
**Useful**: ⚠️ Boot status buried in noise

```
<session-start-hook>
# Product Context — [PROJECT_NAME]
**Last Updated**: [AUTO_GENERATED]
**Project Type**: [AUTO_DETECTED]
[... 300 more lines ...]
🧠 [MINI-CODERBRAIN: ACTIVE] - PROJECT_NAME
💡 Memory cleanup recommended (12 session updates)
</session-start-hook>
```

---

### After (Proposed)

**Token Cost**: ~6 lines = ~120 tokens
**User Experience**: Clear and helpful
**Professional**: ✅ Polished and informative
**Useful**: ✅ Shows exactly what's needed

**Uninitialized**:
```
⚠️ Memory bank not initialized. Run: /init-memory-bank

📚 Setup takes 60 seconds. Claude will:
   1. Detect your tech stack automatically
   2. Map your project structure
   3. Ask you 3-4 quick questions
   4. Save everything to .claude/memory/
```

**Initialized**:
```
🧠 [MINI-CODERBRAIN: ACTIVE] - TaskMaster Pro
🎯 Focus: Implementing JWT authentication
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default
⚡ Ready for development | Session: sessionstart-1760693716
```

**High Activity**:
```
🧠 [MINI-CODERBRAIN: ACTIVE] - TaskMaster Pro
🎯 Focus: Implementing JWT authentication
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default
⚡ Ready for development | Session: sessionstart-1760693716

💡 Memory cleanup recommended (13 session updates, last cleanup 8d ago).
   Run /memory-cleanup to reduce token usage by ~40%.
```

---

## 🎯 Success Metrics

After implementing these refinements:

✅ **Token Reduction**: 98% reduction (8000 → 120 tokens)
✅ **User Clarity**: No more placeholder confusion
✅ **Professional**: Clean, polished boot status
✅ **Helpful**: Guides users through setup
✅ **Smart**: Warns only when truly needed

---

## 📚 Related Documents

- [SESSION-START-EXPLAINED.md](./SESSION-START-EXPLAINED.md) - How it works
- [PLACEHOLDER-FILLING-GUIDE.md](./PLACEHOLDER-FILLING-GUIDE.md) - All placeholders reference
- [REAL-WORLD-COMPARISON.md](./REAL-WORLD-COMPARISON.md) - Mini-CoderBrain vs User Projects

---

**Next Step**: Implement Phase 1 refinements and test with both initialized and uninitialized projects!
