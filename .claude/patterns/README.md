# Behavioral Patterns Library

**Purpose**: Core behavioral patterns that make Mini-CoderBrain intelligent

**Usage**: These patterns are **referenced, not injected** - read on-demand only to preserve tokens.

---

## 📋 Available Patterns

1. **pre-response-protocol.md** - Mandatory checks before every response
2. **context-utilization.md** - How to use memory bank effectively
3. **proactive-behavior.md** - When to make suggestions
4. **anti-patterns.md** - What NOT to do (banned behaviors)
5. **tool-selection-rules.md** - Which tool to use when

---

## 🎯 How Patterns Work

### CLAUDE.md References Patterns:
```markdown
Before responding, follow: @.claude/patterns/pre-response-protocol.md
```

### AI Reads On-Demand:
- Pattern file opened only when needed
- NOT injected into every prompt
- Zero token duplication

### Token Impact: **+0**
- Patterns read reactively, not proactively
- No automatic loading
- Only accessed when AI needs guidance

---

## 📝 Pattern Format

Each pattern file follows this structure:

```markdown
# Pattern Name

**Purpose**: Brief explanation (1 line)

**When to Use**: Triggering condition

**Implementation**: Step-by-step guide

**Example**: Before/after comparison

**Token Cost**: Estimated impact
```

---

**Version**: 2.1.0
**Created**: 2025-10-15
