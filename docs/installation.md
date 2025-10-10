---
layout: page
title: Installation Guide
subtitle: Get Mini-CoderBrain running in 30 seconds
---

# Installation Guide

Complete installation guide for Mini-CoderBrain Universal AI Context Awareness System.

---

## 📋 Prerequisites

### Required
- **Claude Code** - Get it from [claude.ai](https://claude.ai/claude-code)
- **Bash shell** - macOS/Linux/WSL on Windows

### Optional (Recommended)
- **jq** - Enables enhanced features
  - Ubuntu/Debian: `sudo apt-get install jq`
  - macOS: `brew install jq`
  - Windows WSL: `sudo apt-get install jq`

---

## 🚀 Method 1: Automatic Install (Recommended)

### Step 1: Clone Repository

```bash
git clone https://github.com/kunwar-shah/mini-coder-brain.git
cd mini-coder-brain
```

### Step 2: Run Installer

```bash
# Make installer executable
chmod +x install.sh

# Run installer (interactive mode)
./install.sh

# Or provide path directly
./install.sh /path/to/your/project
```

### What the Installer Does

- ✅ Detects your project type (React, Python, Rust, etc.)
- ✅ Backs up existing `.claude` folder (if any)
- ✅ Copies `.claude/` system folder with all hooks
- ✅ Copies `CLAUDE.md` controller
- ✅ **Initializes memory bank from templates**
- ✅ Creates required directories (tmp, cache, archive)
- ✅ Makes hooks executable
- ✅ Customizes with your project name
- ✅ Verifies installation

---

## 🛠️ Method 2: Manual Install (Fallback)

If automatic installation fails, use these manual steps:

### Step 1: Clone Repository

```bash
git clone https://github.com/kunwar-shah/mini-coder-brain.git
cd mini-coder-brain
```

### Step 2: Copy System Files

```bash
# Copy .claude folder to your project
cp -r .claude /path/to/your/project/

# Copy CLAUDE.md controller to your project
cp CLAUDE.md /path/to/your/project/
```

### Step 3: Initialize Memory Bank from Templates

```bash
# Navigate to your project
cd /path/to/your/project

# Copy templates to actual memory files
cp .claude/memory/templates/productContext-template.md .claude/memory/productContext.md
cp .claude/memory/templates/activeContext-template.md .claude/memory/activeContext.md
cp .claude/memory/templates/progress-template.md .claude/memory/progress.md
cp .claude/memory/templates/decisionLog-template.md .claude/memory/decisionLog.md
cp .claude/memory/templates/systemPatterns-template.md .claude/memory/systemPatterns.md
```

### Step 4: Make Hooks Executable

```bash
chmod +x .claude/hooks/*.sh
```

### Step 5: Create Required Directories

```bash
mkdir -p .claude/tmp .claude/cache .claude/archive
```

### Step 6: Customize Your Memory Bank

```bash
# Edit productContext.md with your project details
nano .claude/memory/productContext.md

# Replace [PROJECT_NAME] with your project name
# Update technology stack, features, and architecture
```

---

## ✅ Verify Installation

### Step 1: Check Files

Verify these files exist in your project:

```bash
your-project/
├── .claude/
│   ├── hooks/
│   │   ├── session-start.sh ✅
│   │   ├── conversation-capture-user-prompt.sh ✅
│   │   ├── optimized-intelligent-stop.sh ✅
│   │   └── intelligent-status-notification.sh ✅
│   ├── commands/
│   │   ├── memory-cleanup.md ✅
│   │   └── ... (other commands) ✅
│   ├── memory/
│   │   ├── productContext.md ✅
│   │   ├── activeContext.md ✅
│   │   └── ... (other memory files) ✅
│   └── settings.json ✅
└── CLAUDE.md ✅
```

### Step 2: Test Claude Code

1. Open your project in Claude Code
2. Start a new conversation
3. You should see:

```
🧠 [MINI-CODERBRAIN: ACTIVE] - YourProjectName
🎯 Focus: General Development
📂 Context: .claude/memory/ (loaded)
⚡ Ready for development
```

### Step 3: Test Commands

Try these commands:
```
/memory-sync
/context-update
/memory-cleanup --dry-run
```

If commands work, installation is successful! ✅

---

## 🔧 Post-Installation

### Customize Your Memory Bank

Edit these files for your project:

**1. productContext.md** - Project overview
```bash
nano .claude/memory/productContext.md
```
Update: Project name, technology stack, architecture, key features

**2. systemPatterns.md** - Coding standards
```bash
nano .claude/memory/systemPatterns.md
```
Add: Code style, error handling patterns, testing approach, security requirements

**3. activeContext.md** - Current focus
```bash
nano .claude/memory/activeContext.md
```
Set: Current development phase, active priorities, known blockers

---

## 🛠️ Troubleshooting

### "Hooks not executable"

**Solution**:
```bash
chmod +x .claude/hooks/*.sh
```

### "jq command not found"

**Solution** (optional but recommended):
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

### "Context not loading"

**Solution**:
1. Verify `CLAUDE.md` exists in project root
2. Check `.claude/memory/` files exist
3. Restart Claude Code
4. Look for boot status message

---

## 🎯 Next Steps

- ✅ Customize memory bank files
- ✅ Run `/map-codebase --rebuild` for instant file access
- ✅ Test commands: `/memory-sync`, `/context-update`
- ✅ Start developing with perfect context!

---

## 📚 Additional Resources

- [Quick Start Guide]({{ '/quickstart' | relative_url }})
- [Features Overview]({{ '/features' | relative_url }})
- [Commands Reference]({{ '/commands' | relative_url }})
- [GitHub Repository](https://github.com/kunwar-shah/mini-coder-brain)

---

<div style="text-align: center; margin-top: 50px;">
  <a class="btn btn-success" href="{{ '/quickstart' | relative_url }}">Continue to Quick Start →</a>
</div>
