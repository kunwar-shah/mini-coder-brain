# Mini-CoderBrain Examples

This folder contains example projects showing how mini-coder-brain should be set up for different scenarios.

## Examples Included

### 1. `empty-project/`
**Scenario**: Starting a brand new project from scratch
**Context Quality**: 60% (Minimum)
**Best For**: New projects, prototypes, MVPs

Shows what mini-coder-brain looks like when:
- No existing code
- No documentation
- Interactive `/init-memory-bank` was used
- User provided minimal required info

**Key Files**:
- `.claude/memory/productContext.md` - Basic project info from user input
- `.claude/memory/activeContext.md` - Planning phase focus
- `.claude/memory/progress.md` - Empty with template structure

---

### 2. `existing-nodejs/`
**Scenario**: Existing Node.js + TypeScript project with some code
**Context Quality**: 80% (Recommended)
**Best For**: Mature codebases, mid-development projects

Shows what mini-coder-brain looks like when:
- Existing codebase (package.json, src/, tests/)
- README.md exists
- `/init-memory-bank` auto-detected project info
- Git history analyzed
- No formal documentation (SRS/Architecture)

**Key Files**:
- `.claude/memory/productContext.md` - Auto-populated from package.json + README
- `.claude/memory/systemPatterns.md` - Detected patterns from code
- `.claude/memory/progress.md` - Generated from git commits
- `.claude/memory/project-structure.json` - Auto-detected structure

---

### 3. `complex-fullstack/`
**Scenario**: Full-stack project with comprehensive documentation
**Context Quality**: 95% (Optimal)
**Best For**: Enterprise projects, well-documented codebases

Shows what mini-coder-brain looks like when:
- Complex codebase (frontend + backend + database)
- Comprehensive documentation (SRS, ARCHITECTURE, API docs)
- `/init-memory-bank --docs-path ./docs` used
- All docs auto-integrated
- High-quality context

**Key Files**:
- `.claude/memory/productContext.md` - Rich context from SRS + README
- `.claude/memory/systemPatterns.md` - Detailed patterns from ARCHITECTURE.md
- `.claude/memory/decisionLog.md` - ADRs extracted from docs
- `.claude/memory/progress.md` - Comprehensive sprint tracking
- `.claude/memory/project-structure.json` - Complete structure mapping

---

## How to Use These Examples

### Study the Examples
```bash
# View each example's memory bank files
cd examples/empty-project/.claude/memory/
cat productContext.md
```

### Copy as Template
```bash
# Use an example as starting point for your project
cp -r examples/existing-nodejs/.claude /path/to/your/project/
```

### Compare Quality Levels
Run `/validate-context` in each example to see quality scores:
- Empty: ~60% (Minimum)
- Existing: ~80% (Recommended)
- Complex: ~95% (Optimal)

---

## Quick Start Guide

### If Your Project Matches "Empty"
1. Install mini-coder-brain
2. Run `/init-memory-bank`
3. Answer prompts interactively
4. Start building!

### If Your Project Matches "Existing"
1. Install mini-coder-brain
2. Run `/init-memory-bank` (auto-detects everything)
3. Confirm detected info
4. Enhance productContext.md manually if needed

### If Your Project Matches "Complex"
1. Install mini-coder-brain
2. Run `/init-memory-bank --docs-path ./docs`
3. Review auto-integrated context
4. Start developing with 95%+ context!

---

**Note**: These are reference examples. Real projects will vary. Use `/validate-context` to check your actual context quality.
