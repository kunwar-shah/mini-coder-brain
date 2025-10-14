# Mini-CoderBrain Setup Guide

**Version**: 2.0.0
**Last Updated**: 2025-10-14

Complete post-installation setup guide for mini-coder-brain. Follow these steps to ensure 100% effectiveness.

---

## 📋 Prerequisites

Before starting, ensure you have:
- ✅ Claude Code v2 installed and configured
- ✅ Git repository initialized (recommended, not required)
- ✅ Project documentation (SRS, technical specs) - highly recommended

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Install Mini-CoderBrain

```bash
# Navigate to your project
cd /path/to/your/project

# Run installer
/path/to/mini-coder-brain/install.sh .

# Or with full path
/path/to/mini-coder-brain/install.sh ~/projects/my-app
```

**Expected Output**:
```
✅ Mini-CoderBrain v2.0.0 installed successfully!

⚠️  IMPORTANT - REQUIRED SETUP:
🔴 MANDATORY: Run this command first:
   /init-memory-bank
```

### Step 2: Open Project in Claude Code

```bash
# Open your project in Claude Code
cd ~/projects/my-app
# Then open in Claude Code IDE
```

### Step 3: Run Mandatory Initialization

**CRITICAL**: This step is **mandatory** for mini-coder-brain to work!

```bash
# If you have documentation (HIGHLY RECOMMENDED):
/init-memory-bank --docs-path ./docs

# If starting without docs (minimum setup):
/init-memory-bank
```

**What happens**:
- 🔍 Scans project structure and detects tech stack
- 📄 Reads README, package.json, and config files
- 🔄 Analyzes git history (if available)
- 📚 Reads documentation from --docs-path (if provided)
- 💾 Populates all memory bank files with real data
- ✅ Ready for 100% context-aware development

---

## 📊 Context Quality Requirements

Mini-CoderBrain's effectiveness depends on context quality:

| Context Quality | Effectiveness | Requirements |
|----------------|---------------|--------------|
| 🔴 **Minimum** | 60% | Project name, tech stack (3+ items), core features (2+) |
| 🟡 **Recommended** | 80% | + SRS/technical docs, architecture overview |
| 🟢 **Optimal** | 100% | + Complete documentation, API specs, decision history |

### Minimum Setup (Required)

After `/init-memory-bank`, verify these are filled in [productContext.md](.claude/memory/productContext.md):

```markdown
# Product Context — [YOUR_PROJECT_NAME]

**Project Type**: [Node.js / Python / Rust / etc]

## Project Overview
[At least 2-3 sentences describing your project]

## Core Features
- [Feature 1]
- [Feature 2]
- [Feature 3]

## Technology Stack
- **Frontend**: [Framework/Library]
- **Backend**: [Framework/Library]
- **Database**: [Database system]
```

### Recommended Setup (80%+ Effectiveness)

Provide documentation paths during init:

```bash
/init-memory-bank --docs-path ./documentation
```

**Supported documentation formats**:
- 📄 Markdown files (`.md`)
- 📋 Text files (`.txt`)
- 📑 PDF documents (`.pdf`)
- 📊 JSON/YAML specs (API docs, OpenAPI)

**Common documentation files**:
- `SRS.md` - Software Requirements Specification
- `ARCHITECTURE.md` - System architecture
- `API.md` - API documentation
- `TECHNICAL_SPEC.md` - Technical specifications
- `DESIGN.md` - Design decisions

### Optimal Setup (100% Effectiveness)

1. **Complete Documentation**:
   ```
   docs/
   ├── SRS.md                    # Complete requirements
   ├── ARCHITECTURE.md            # System design
   ├── API.md                     # API reference
   ├── DEVELOPMENT.md             # Dev guidelines
   └── DECISIONS.md               # ADR log
   ```

2. **Run initialization with docs**:
   ```bash
   /init-memory-bank --docs-path ./docs
   ```

3. **Verify context files populated**:
   - `.claude/memory/productContext.md` - Project overview
   - `.claude/memory/systemPatterns.md` - Coding patterns
   - `.claude/memory/decisionLog.md` - Technical decisions
   - `.claude/memory/progress.md` - Development status
   - `.claude/memory/activeContext.md` - Current focus

---

## 🎯 Scenarios

### Scenario 1: New Empty Project

**Context**: Starting a brand new project from scratch.

**Steps**:
1. Install mini-coder-brain: `./install.sh ~/projects/new-project`
2. Open in Claude Code
3. Run initialization: `/init-memory-bank`
4. Claude will prompt you for:
   - Project name and description
   - Technology stack preferences
   - Architecture type (monolith, microservices, etc.)
   - Core features to build
5. Start developing with Claude's help!

**Example Interaction**:
```
You: /init-memory-bank

Claude: I'll help initialize your project context.

What is your project name?
You: modern-saas-app

What type of application are you building?
You: A SaaS platform for team collaboration with real-time features

What technology stack do you want to use?
You: Next.js 14, TypeScript, Prisma, PostgreSQL, Tailwind CSS

[Claude populates all memory files and you're ready to build]
```

### Scenario 2: Existing Project (No Documentation)

**Context**: You have an existing codebase but no formal documentation.

**Steps**:
1. Install mini-coder-brain: `./install.sh ~/projects/existing-app`
2. Open in Claude Code
3. Run initialization: `/init-memory-bank`
4. Auto-detects:
   - ✅ Project name (from package.json, Cargo.toml, etc.)
   - ✅ Tech stack (from dependencies)
   - ✅ File structure (frontend/backend/database)
   - ✅ Recent work (from git history)
   - ✅ Coding patterns (from code analysis)
5. Review and enhance `.claude/memory/productContext.md` with missing details

**What gets auto-detected**:
```
✅ Detected: Node.js + TypeScript project
✅ Found: my-app v2.3.0
✅ Tech Stack: React 18, Express, Prisma, PostgreSQL
✅ Structure: Frontend (src/), Backend (api/), Database (prisma/)
✅ Recent commits: 47 commits in last 30 days
```

### Scenario 3: Existing Project (With Documentation)

**Context**: You have comprehensive documentation (SRS, architecture docs, etc.).

**Steps**:
1. Install mini-coder-brain: `./install.sh ~/projects/documented-app`
2. Open in Claude Code
3. Run with docs path: `/init-memory-bank --docs-path ./documentation`
4. Auto-reads and integrates:
   - ✅ SRS.md → Core features, requirements
   - ✅ ARCHITECTURE.md → System design, patterns
   - ✅ API.md → API structure, endpoints
   - ✅ TECHNICAL_SPEC.md → Technical decisions
5. Result: 100% context awareness immediately!

**Example Output**:
```
🔍 Scanning project structure...
✅ Detected: Full-stack TypeScript application

📚 Reading documentation from ./documentation...
✅ Read: SRS.md (158 lines) - Requirements extracted
✅ Read: ARCHITECTURE.md (94 lines) - System design understood
✅ Read: API.md (203 lines) - API structure mapped

📝 Populating memory bank...
✅ productContext.md - 89% populated from docs
✅ systemPatterns.md - 76% populated from code + docs
✅ decisionLog.md - 12 decisions extracted from ARCHITECTURE.md

🎯 Context Quality: 95% (Optimal)
⚡ Ready for 100% effective development!
```

### Scenario 4: Re-initializing After Major Changes

**Context**: Your project structure or tech stack changed significantly.

**Steps**:
1. Open project in Claude Code
2. Run re-initialization: `/init-memory-bank`
3. Confirms: "Memory bank already exists. Re-scan and update? (y/n)"
4. Updates all context files with new information
5. Preserves existing manual edits in merge

---

## 🛠 Essential Commands

### After Installation

| Command | When to Use | Frequency |
|---------|-------------|-----------|
| `/init-memory-bank` | After installation (MANDATORY) | Once, or after major changes |
| `/init-memory-bank --docs-path ./docs` | With documentation (RECOMMENDED) | Once |
| `/map-codebase` | Enable instant file access | Once, or after structural changes |

### During Development

| Command | When to Use | Frequency |
|---------|-------------|-----------|
| `/update-memory-bank` | After major features/decisions | After milestones |
| `/context-update focus "..."` | Quick context updates | As needed |
| `/memory-sync` | Full context sync | Weekly or as suggested |
| `/memory-cleanup` | Clean memory bloat | When notified (quarterly) |

---

## ✅ Verification Checklist

After setup, verify these items:

### 1. Memory Bank Files Populated

```bash
# Check file sizes (should NOT be just templates)
ls -lh .claude/memory/

# Expected output:
productContext.md   ~3-5KB   (NOT 1KB template)
systemPatterns.md   ~2-4KB   (NOT 1KB template)
activeContext.md    ~2-3KB   (NOT 1KB template)
progress.md         ~2-3KB   (NOT 1KB template)
decisionLog.md      ~1-2KB   (may be small if new project)
```

### 2. Context Quality Check

Open [.claude/memory/productContext.md](.claude/memory/productContext.md) and verify:
- ✅ Project name is filled (not `[PROJECT_NAME]`)
- ✅ Technology stack has 3+ items
- ✅ Core features has 2+ items
- ✅ Project overview has actual description

### 3. CLAUDE.md Metadata

Open [CLAUDE.md](CLAUDE.md) and verify the **Project Setup Metadata** section is filled:
```yaml
uses_git: true
git_host: github
repository_url: "https://github.com/user/repo"
uses_docker: true
# ... etc
```

### 4. Test Context Awareness

Start a conversation in Claude Code:
```
You: "What tech stack is this project using?"

Claude: "This project uses Next.js 14, TypeScript, Prisma,
        and PostgreSQL..." (should answer immediately without asking)
```

**If Claude asks what framework you're using** → Context not loaded properly, re-run `/init-memory-bank`!

---

## 🎓 Best Practices

### 1. Always Provide Documentation Paths

```bash
# ✅ GOOD: With documentation
/init-memory-bank --docs-path ./docs

# ❌ BAD: Without docs (when you have them)
/init-memory-bank
```

### 2. Update Memory Bank After Major Work

```bash
# After completing features
/update-memory-bank "Completed authentication system with JWT and RBAC"

# After technical decisions
/update-memory-bank "Chose Redis for session storage, updated architecture"
```

### 3. Keep productContext.md Current

Manually update [.claude/memory/productContext.md](.claude/memory/productContext.md) when:
- Adding new major features
- Changing technology stack
- Updating project goals
- Modifying architecture

### 4. Use /memory-cleanup Regularly

When you see this notification:
```
💡 Memory cleanup recommended: 12 session updates in activeContext.md
   Run /memory-cleanup to reduce bloat
```

Run: `/memory-cleanup` to prevent "Prompt is too long" errors.

---

## 🚨 Troubleshooting

### Problem: "Claude asks me what framework I'm using"

**Cause**: Context not loaded or productContext.md empty
**Solution**:
1. Verify `.claude/memory/productContext.md` is populated
2. Re-run `/init-memory-bank --docs-path ./docs`
3. Restart Claude Code session

### Problem: "Context files still have [PROJECT_NAME] placeholders"

**Cause**: `/init-memory-bank` not run or failed
**Solution**:
1. Run `/init-memory-bank` in Claude Code (not bash)
2. Provide information when prompted
3. Manually edit files if auto-detection failed

### Problem: "/init-memory-bank command not found"

**Cause**: Installation incomplete
**Solution**:
1. Verify `.claude/commands/init-memory-bank.md` exists
2. Re-run install.sh
3. Restart Claude Code

### Problem: "Prompt is too long" error

**Cause**: Memory bank bloat from many session updates
**Solution**:
1. Run `/memory-cleanup` immediately
2. Continue development normally
3. Set reminder to run cleanup quarterly

### Problem: "Context quality only 60%"

**Cause**: Missing documentation or insufficient context
**Solution**:
1. Add documentation to project
2. Run `/init-memory-bank --docs-path ./docs`
3. Manually enhance productContext.md with missing details

---

## 📚 Next Steps

After successful setup:

1. **Start Development**: Begin working on your project with Claude
2. **Use /map-codebase**: Enable instant file access with `/map-codebase`
3. **Regular Updates**: Run `/update-memory-bank` after major milestones
4. **Monitor Status**: Check footer status for suggestions

**Status Footer Example**:
```
🧠 Context: Active | Activity: 23 ops | Map: Fresh (2h)
💡 Consider running /update-memory-bank to preserve session context
```

---

## 🔗 Resources

- **GitHub Repository**: https://github.com/kunwar-shah/mini-coder-brain
- **Full Documentation**: https://github.com/kunwar-shah/mini-coder-brain/tree/main/docs
- **SRS (Software Requirements)**: https://github.com/kunwar-shah/mini-coder-brain/blob/main/docs/SRS-MINI-CODERBRAIN.md
- **Issues & Support**: https://github.com/kunwar-shah/mini-coder-brain/issues

---

**Mini-CoderBrain v2.0** - Universal AI Context Awareness System
© 2025 | MIT License | Made with ❤️ for developers
