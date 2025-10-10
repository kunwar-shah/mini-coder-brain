# Installation Guide - Mini-CoderBrain v1.0

Complete installation guide for Universal AI Context Awareness System.

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
- ✅ **Copies templates to actual memory files** (productContext.md, etc.)
- ✅ Customizes with your project name
- ✅ Verifies installation

---

### Method 2: Manual Installation

**Step 1: Copy System Files**
```bash
# Navigate to Mini-CoderBrain directory
cd mini-coder-brain

# Copy .claude folder
cp -r .claude /path/to/your/project/

# Copy CLAUDE.md controller
cp docs/CLAUDE.md /path/to/your/project/
```

**Step 2: Create Required Directories**
```bash
cd /path/to/your/project
mkdir -p .claude/tmp .claude/cache .claude/archive
```

**Step 3: Make Hooks Executable**
```bash
chmod +x .claude/hooks/*.sh
```

**Step 4: Customize Templates**
```bash
# Edit productContext.md with your project details
nano .claude/memory/productContext.md

# Replace [PROJECT_NAME] with your project name
# Replace [TECH_STACK] with your technology stack
```

---

### Method 3: One-Liner (Advanced)

```bash
curl -sL https://raw.githubusercontent.com/yourusername/mini-coder-brain/main/install.sh | bash -s /path/to/your/project
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

### Step 3: Test Commands

Try these commands:
```
/memory-sync
/context-update
/memory-cleanup --dry-run
```

If commands work, installation is successful! ✅

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

### Install v2.0
```bash
# Run new installer (will backup automatically)
cd mini-coder-brain
./install.sh /path/to/your/project
```

### Key Changes in v2.0
- ✨ Hooks completely rewritten (zero duplication)
- ✨ Memory cleanup system added
- ✨ Context loading strategy changed
- ✨ 79.9% token reduction achieved

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

### Recommended First Steps

1. **Customize Templates**
   ```bash
   nano .claude/memory/productContext.md  # Add project details
   nano .claude/memory/activeContext.md   # Set current focus
   ```

2. **Test Memory Commands**
   ```
   /memory-sync              # Test sync
   /context-update           # Test updates
   /memory-cleanup --dry-run # Test cleanup
   ```

3. **Enable Codebase Mapping**
   ```
   /map-codebase --rebuild   # One-time setup
   /map-codebase             # Instant loading
   ```

4. **Work on Your Project**
   - Claude now has full context
   - Perfect continuity across sessions
   - Auto-cleanup prevents bloat

---

## 📚 Next Steps

- **Read**: [README.md](README.md) for feature overview
- **Review**: [CLAUDE.md](docs/CLAUDE.md) for controller details
- **Study**: [SRS](docs/SRS-MINI-CODERBRAIN.md) for complete specification
- **Explore**: Available commands and features

---

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/mini-coder-brain/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/mini-coder-brain/discussions)
- **Documentation**: [Full Docs](docs/)

---

**Installation Complete!** 🎉

Mini-CoderBrain v2.0 is now active in your project. Claude has perfect context awareness and memory continuity!
