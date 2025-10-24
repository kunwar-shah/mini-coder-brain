# Installation Guide - Mini-CoderBrain v2.2

Complete installation guide for Universal AI Context Awareness System with Production-Verified Quality.

**Current Version**: v2.2.0 (October 2025)
**Latest Features**: 3-Layer Footer Enforcement, Zero-Tolerance Co-Author Policy, Docker Safety, 100% Production Verification

**⚠️ IMPORTANT**: Version 2.2 requires **MANDATORY** initialization after installation. Follow all steps carefully!

---

## 📋 Prerequisites

### Required
- **Claude Code** - Get it from [claude.ai](https://claude.ai/claude-code)
- **Bash shell** - macOS/Linux/WSL on Windows
- **Git repository** - Recommended for full features (optional for basic use)

### Optional (Recommended)
- **jq** - Enables enhanced features
  - Ubuntu/Debian: `sudo apt-get install jq`
  - macOS: `brew install jq`
  - Windows WSL: `sudo apt-get install jq`
- **Project Documentation** - SRS, Architecture docs for optimal context quality

---

## 🚀 Installation Methods

### Method 1: Smart Installer (Recommended)

**Step 1: Clone Repository**
```bash
git clone https://github.com/kunwar-shah/mini-coder-brain.git
cd mini-coder-brain
```

**Step 2: Run Installer**
```bash
# Make installer executable (first time only)
chmod +x install.sh

# Interactive mode (prompts for project path)
./install.sh

# Or provide path directly
./install.sh /path/to/your/project
```

**What the installer does**:
- ✅ Detects project type (React, Python, Rust, etc.)
- ✅ Backs up existing `.claude` folder (if any)
- ✅ Copies `.claude/` system folder with all hooks
- ✅ Copies `CLAUDE.md` controller
- ✅ Creates required directories (tmp, cache, archive)
- ✅ Makes hooks executable
- ✅ **Copies templates to memory bank** (DO NOT edit templates directly!)
- ✅ Customizes with your project name
- ✅ Verifies installation
- ⚠️ **Shows mandatory `/init-memory-bank` requirement**

**💡 After installation, you MUST run `/init-memory-bank`** - See "Mandatory Initialization" section below.

---

## 🔴 MANDATORY: Initialize Context

**⚠️ CRITICAL**: This step is **REQUIRED** for mini-coder-brain to work!

After running the installer, open your project in Claude Code and run:

### Option A: With Documentation (RECOMMENDED)
```
/init-memory-bank --docs-path ./docs
```

**Best for**: Projects with SRS, ARCHITECTURE.md, API.md, or technical documentation

**What it does**:
- 🔍 Auto-detects your project type
- 📚 Reads all documentation files
- 🎯 Extracts features, architecture, tech stack
- ✅ Populates memory bank with real data
- 📊 Shows context quality score (aim for 80%+)

### Option B: Auto-Detection (Existing Projects)
```
/init-memory-bank
```

**Best for**: Existing projects with code but no documentation

**What it does**:
- 🔍 Scans package.json, README.md, code structure
- 🎯 Auto-detects tech stack and patterns
- ✅ Generates project-structure.json
- 📊 Confirms detected info with you

### Option C: Interactive Wizard (New Projects)
```
/init-memory-bank
```

**Best for**: Brand new projects starting from scratch

**What it does**:
- 💬 Asks about project name, tech stack, features
- 🎯 Guides you through all required info
- ✅ Creates complete memory bank from your answers
- 📊 Validates minimum requirements met

### Verify Initialization

After initialization, check your context quality:

```
/validate-context
```

**Expected output**:
```
📊 Context Quality: 85% (Recommended) ✅

✅ Project name: your-project
✅ Tech stack: 5 technologies
✅ Core features: 4 features
✅ Architecture: Defined

✅ Ready for development!
```

**If quality < 60%**: Run `/validate-context --fix` for guided improvements.

---

### Method 2: Manual Installation (Fallback)

If the automatic installer fails, use these manual steps:

**Step 1: Clone Repository**
```bash
git clone https://github.com/kunwar-shah/mini-coder-brain.git
cd mini-coder-brain
```

**Step 2: Copy System Files**
```bash
# Copy .claude folder to your project
cp -r .claude /path/to/your/project/

# Copy CLAUDE.md controller to your project
cp CLAUDE.md /path/to/your/project/
```

**Step 3: Initialize Memory Bank from Templates**
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

**Step 4: Make Hooks Executable**
```bash
chmod +x .claude/hooks/*.sh
```

**Step 5: Create Required Directories**
```bash
mkdir -p .claude/tmp .claude/cache .claude/archive
```

**Step 6: Customize Your Memory Bank**
```bash
# Edit productContext.md with your project details
nano .claude/memory/productContext.md

# Replace [PROJECT_NAME] with your project name
# Update technology stack, features, and architecture
```

---

### Method 3: One-Liner (Advanced)

```bash
curl -sL https://raw.githubusercontent.com/kunwar-shah/mini-coder-brain/main/install.sh | bash -s /path/to/your/project
```

⚠️ **Security Note**: Always review scripts before piping to bash!

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
│   │   ├── intelligent-status-notification.sh ✅
│   │   └── memory-cleanup.sh ✅
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
🧠 [CODERBRAIN: ACTIVE] - YourProjectName
🎯 Focus: [Current focus]
📂 Context: .claude/memory/ (loaded)
⚡ Ready for development
```

### Step 3: Initialize Context (MANDATORY)

Run the mandatory initialization:
```
/init-memory-bank
```

Or with documentation:
```
/init-memory-bank --docs-path ./docs
```

### Step 4: Test Commands

Try these commands:
```
/validate-context              # Check context quality
/update-memory-bank            # Update memory (renamed from /umb)
/memory-cleanup --dry-run      # Test cleanup
/import-docs ./path/to/docs    # Import documentation (if you have it)
```

If commands work and context quality >= 60%, installation is successful! ✅

---

## 🔧 Configuration

### Customize Memory Bank

Edit these files for your project:

**1. productContext.md** - Project overview
```bash
nano .claude/memory/productContext.md
```
Update:
- Project name
- Technology stack
- Architecture overview
- Key features

**2. systemPatterns.md** - Coding standards
```bash
nano .claude/memory/systemPatterns.md
```
Add your:
- Code style preferences
- Error handling patterns
- Testing approach
- Security requirements

**3. activeContext.md** - Current focus
```bash
nano .claude/memory/activeContext.md
```
Set your:
- Current development phase
- Active priorities
- Known blockers

---

## 🛠️ Troubleshooting

### Issue 1: "context-loaded.flag not created"

**Symptoms**: Hooks report flag missing

**Solution**:
```bash
# Verify session-start.sh has flag creation
grep "context-loaded.flag" .claude/hooks/session-start.sh

# Should show: echo "$(date +%s)" > "$CLAUDE_TMP/context-loaded.flag"
```

### Issue 2: "Hooks not executable"

**Symptoms**: Permission denied errors

**Solution**:
```bash
chmod +x .claude/hooks/*.sh
```

### Issue 3: "jq command not found"

**Symptoms**: Hooks show jq errors

**Solution**: Install jq (optional but recommended)
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

**Note**: System works without jq, but some features disabled.

### Issue 4: "Prompt is too long" still appears

**Symptoms**: Error after long conversation

**Solution**:
1. Check if cleanup notification appeared
2. Run `/memory-cleanup`
3. Verify activeContext.md reduced from 200+ → ~80 lines

### Issue 5: "Context not loading"

**Symptoms**: Claude doesn't have project context

**Solution**:
1. Verify `CLAUDE.md` exists in project root
2. Check `.claude/memory/` files exist
3. Restart Claude Code
4. Look for boot status message

---

## 🔄 Upgrading from v1.0

### Backup First
```bash
# Backup existing .claude folder
cp -r .claude .claude.v1.backup
```

### Install v2.2
```bash
# Run new installer (will backup automatically)
cd mini-coder-brain
./install.sh /path/to/your/project
```

### Key Changes in v2.2
- ✨ 3-Layer Footer Enforcement (85-92% compliance)
- ✨ Zero-Tolerance Co-Author Policy
- ✨ Docker Container Safety Guidelines
- ✨ 100% Production Verification (36/36 checks passed)
- ✨ Enhanced Test Coverage (58% pass rate)
- ✨ Maintains all v2.0/v2.1 features (79.8% token efficiency)

### Migration Notes
- Memory files compatible (no changes needed)
- Commands compatible (new ones added)
- Hooks incompatible (replaced automatically)

---

## 🗑️ Uninstallation

### Remove Mini-CoderBrain
```bash
cd your-project

# Backup memory files (optional)
cp -r .claude/memory .claude-memory-backup

# Remove system
rm -rf .claude
rm CLAUDE.md
```

### Restore Backup (if needed)
```bash
# If you backed up before installing
mv .claude.backup .claude
mv CLAUDE.md.backup CLAUDE.md
```

---

## 🎯 Post-Installation

### Recommended First Steps (v2.2 Workflow)

1. **Initialize Context (MANDATORY)**
   ```
   /init-memory-bank --docs-path ./docs  # With documentation
   # OR
   /init-memory-bank                     # Auto-detect
   ```

2. **Validate Quality**
   ```
   /validate-context                     # Check score (aim for 80%+)
   ```

3. **Import Additional Docs (If Needed)**
   ```
   /import-docs ./additional-docs        # Add more documentation
   ```

4. **Enable Codebase Mapping**
   ```
   /map-codebase --rebuild              # One-time setup
   /map-codebase                        # Instant loading
   ```

5. **Work on Your Project**
   - Claude now has full context
   - Perfect continuity across sessions
   - Auto-cleanup prevents bloat
   - Context quality monitored automatically

6. **Update Memory After Major Work**
   ```
   /update-memory-bank "Completed feature X"  # After milestones
   ```

---

## 📚 Next Steps

- **📖 Setup Guide**: [SETUP.md](SETUP.md) - Comprehensive setup guide for all scenarios
- **📋 README**: [README.md](README.md) - Feature overview and quick start
- **🔧 Commands**: Available commands and usage
- **📘 Examples**: [examples/](examples/) - Reference projects (empty/existing/complex)

---

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/kunwar-shah/mini-coder-brain/issues)
- **Discussions**: [GitHub Discussions](https://github.com/kunwar-shah/mini-coder-brain/discussions)
- **Documentation**: [Full Docs](https://github.com/kunwar-shah/mini-coder-brain)

---

**Installation Complete!** 🎉

Mini-CoderBrain v2.2 is now active in your project.

**⚠️ REMEMBER**: Run `/init-memory-bank` to complete setup!

After initialization, Claude will have:
- ✅ Perfect context awareness
- ✅ Memory continuity across sessions
- ✅ Measurable quality scores (60-95%)
- ✅ Intelligent validation and warnings
