---
layout: page
title: How to Use Mini-CoderBrain
subtitle: Complete usage guide for all scenarios
---

# How to Use Mini-CoderBrain v2.0

Comprehensive guide for setting up and using mini-coder-brain effectively in any project type.

---

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Project Scenarios](#project-scenarios)
3. [Essential Commands](#essential-commands)
4. [Best Practices](#best-practices)
5. [Context Quality](#context-quality)
6. [Troubleshooting](#troubleshooting)

---

## 🚀 Quick Start

### Installation + Setup (2 Minutes)

**Step 1: Install**
```bash
git clone https://github.com/kunwar-shah/mini-coder-brain.git
cd mini-coder-brain
./install.sh /path/to/your/project
```

**Step 2: Initialize (MANDATORY)**
```
# In Claude Code, run ONE of these:
/init-memory-bank --docs-path ./docs  # With documentation
/init-memory-bank                     # Auto-detect
```

**Step 3: Verify**
```
/validate-context
```

Expected: `📊 Context Quality: 85% (Recommended) ✅`

---

## 🎯 Project Scenarios

### Scenario 1: New Empty Project

**Context**: Starting from scratch, no code yet

**Steps**:
1. Install mini-coder-brain
2. Run `/init-memory-bank`
3. Answer interactive prompts:
   - Project name?
   - What type of app?
   - Tech stack preference?
   - Core features?
4. Start building with Claude's help

**Result**: 60-70% quality (minimum but functional)

**Example**:
```
You: /init-memory-bank

Claude: What is your project name?
You: my-saas-app

Claude: What type of application?
You: A SaaS platform for team collaboration

Claude: What technology stack?
You: Next.js 14, TypeScript, Prisma, PostgreSQL

✅ Context initialized! Quality: 65%
```

---

### Scenario 2: Existing Project (No Docs)

**Context**: You have code but no formal documentation

**Steps**:
1. Install mini-coder-brain
2. Run `/init-memory-bank` (no arguments)
3. Claude auto-detects:
   - Tech stack from package.json
   - Project structure
   - Git history
   - Coding patterns
4. Confirm detected information
5. Provide missing details when prompted

**Result**: 75-85% quality (recommended)

**What gets auto-detected**:
- ✅ Project name (from package.json)
- ✅ Dependencies → tech stack
- ✅ File structure → frontend/backend
- ✅ Recent commits → progress
- ✅ Test files → testing framework

---

### Scenario 3: Existing Project (With Docs)

**Context**: You have comprehensive documentation

**Steps**:
1. Install mini-coder-brain
2. Run `/init-memory-bank --docs-path ./docs`
3. Claude reads:
   - README.md
   - SRS.md
   - ARCHITECTURE.md
   - API.md
   - Any .md files in docs/
4. Extracts features, architecture, decisions
5. Generates rich context automatically

**Result**: 90-95% quality (optimal)

**Documentation files recognized**:
- `SRS.md` / `REQUIREMENTS.md` → Features
- `ARCHITECTURE.md` / `DESIGN.md` → System design
- `API.md` / `API_SPEC.md` → API patterns
- `DECISIONS.md` / `ADR*.md` → Technical decisions
- `README.md` → Project overview

---

## 🛠️ Essential Commands

### /init-memory-bank

**Purpose**: Initialize project context (MANDATORY after installation)

**Usage**:
```
/init-memory-bank                      # Auto-detect
/init-memory-bank --docs-path ./docs   # With documentation
/init-memory-bank --dry-run            # Preview only
```

**When to use**: Once after installation, or after major project changes

---

### /validate-context

**Purpose**: Check context quality with detailed report

**Usage**:
```
/validate-context                # Check quality
/validate-context --fix          # Interactive improvements
```

**Output**:
```
📊 Context Quality: 85% (Recommended) ✅

✅ Project name: defined
✅ Tech stack: 5 technologies
✅ Core features: 4 features
✅ Architecture: defined
⚠️  Development goals: missing

Recommendations:
  • Add development goals to productContext.md
```

**When to use**:
- After initialization
- When Claude seems confused
- Periodically to ensure quality

---

### /update-memory-bank

**Purpose**: Update memory after major development work

**Usage**:
```
/update-memory-bank                              # Standard update
/update-memory-bank "Completed feature X"        # With note
```

**When to use**:
- After completing major features
- After making technical decisions
- End of development session
- When prompted by footer status

**What gets updated**:
- `decisionLog.md` - Technical decisions
- `progress.md` - Completed tasks
- `activeContext.md` - Current focus

---

### /import-docs

**Purpose**: Import documentation after initialization

**Usage**:
```
/import-docs ./docs                     # Import folder
/import-docs ./specs/SRS.md             # Import file
/import-docs ./docs --type srs          # With type hint
```

**When to use**:
- Found documentation after initial setup
- Documentation was updated
- Want to add more context

---

### /map-codebase

**Purpose**: Enable instant file access

**Usage**:
```
/map-codebase --rebuild       # First time (30 seconds)
/map-codebase                 # Load existing (instant)
```

**When to use**: Once per project, rebuild when structure changes

---

### /memory-cleanup

**Purpose**: Archive old data to prevent "Prompt too long"

**Usage**:
```
/memory-cleanup                # Standard cleanup
/memory-cleanup --dry-run      # Preview only
/memory-cleanup --full         # Aggressive cleanup
```

**When to use**: When notified by status footer, or quarterly

---

## 🎓 Best Practices

### 1. Always Provide Documentation Paths

```bash
# ✅ GOOD: With documentation
/init-memory-bank --docs-path ./docs

# ❌ BAD: Without docs (when you have them)
/init-memory-bank
```

### 2. Validate Quality After Setup

```bash
/init-memory-bank --docs-path ./docs
/validate-context  # Always check!
```

**Target**: Aim for 80%+ quality

### 3. Update Memory After Major Work

```bash
# After completing features
/update-memory-bank "Completed authentication with JWT"

# After technical decisions
/update-memory-bank "Chose Redis for sessions"
```

### 4. Keep productContext.md Current

Manually update when:
- Adding major features
- Changing tech stack
- Updating project goals

### 5. Run Cleanup When Notified

When you see:
```
💡 Memory cleanup recommended: 12 session updates
   Run /memory-cleanup
```

Run: `/memory-cleanup` immediately

---

## 📊 Context Quality Guide

### Quality Levels

| Score | Level | Meaning | Action |
|-------|-------|---------|--------|
| <40% | 🔴 Below Minimum | Won't work well | **CRITICAL**: Run `/init-memory-bank` |
| 40-60% | 🟡 Minimum | Works but limited | Run `/validate-context --fix` |
| 60-80% | 🟢 Recommended | Good effectiveness | Optional improvements |
| 80-100% | 🌟 Optimal | Excellent | Perfect! |

### Minimum Requirements

**Must Have**:
- ✅ Project name (not placeholder)
- ✅ Technology stack (3+ items)
- ✅ Core features (2+ items)

**Should Have** (for 80%+):
- ✅ Architecture description
- ✅ Development goals
- ✅ Project documentation

### Improving Quality

**From 60% → 80%**:
1. Add architecture description
2. Define development goals
3. Document key patterns
4. Run `/import-docs` if you have documentation

**From 80% → 95%**:
1. Import comprehensive documentation
2. Add decision history
3. Document API patterns
4. Include success metrics

---

## 🚨 Troubleshooting

### Problem: "Claude asks what framework I'm using"

**Cause**: Context not loaded or quality too low

**Solution**:
1. Run `/validate-context`
2. If quality <60%, run `/validate-context --fix`
3. Verify productContext.md has tech stack
4. Re-run `/init-memory-bank` if needed

---

### Problem: "Context quality is 45%"

**Cause**: Insufficient information in memory bank

**Solution**:
1. Run `/validate-context --fix`
2. Follow interactive prompts
3. Or manually edit `.claude/memory/productContext.md`
4. Add: tech stack, features, architecture
5. Re-validate: `/validate-context`

---

### Problem: "/init-memory-bank doesn't populate files"

**Cause**: Templates exist but not initialized

**Solution**:
1. Check if files exist: `ls .claude/memory/*.md`
2. If they exist, back them up
3. Re-run installer
4. Run `/init-memory-bank` in Claude Code (not bash!)

---

### Problem: "Prompt is too long" error

**Cause**: Memory bank bloat from many sessions

**Solution**:
1. Run `/memory-cleanup` immediately
2. Verify: check `.claude/archive/` for backed up data
3. Quality should be maintained
4. Run cleanup quarterly

---

## 📚 Additional Resources

- **SETUP.md**: https://github.com/kunwar-shah/mini-coder-brain/blob/main/SETUP.md
- **Examples**: https://github.com/kunwar-shah/mini-coder-brain/tree/main/examples
- **Commands**: [Full Command Reference]({{ '/commands' | relative_url }})
- **Issues**: https://github.com/kunwar-shah/mini-coder-brain/issues

---

## ✅ Quick Reference Card

```
# Installation
./install.sh /path/to/project

# Setup (MANDATORY)
/init-memory-bank --docs-path ./docs

# Validation
/validate-context

# Daily Use
/update-memory-bank "note"
/map-codebase

# Maintenance
/memory-cleanup  (when notified)
```

---

**Ready to master Mini-CoderBrain?** Follow these guides and reach 95% context quality!
