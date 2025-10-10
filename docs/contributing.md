---
layout: page
title: Contributing
subtitle: Help make Mini-CoderBrain better
---

# Contributing to Mini-CoderBrain

Thank you for your interest in contributing to Mini-CoderBrain! 🎉

This document provides guidelines for contributing to the project.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Submitting Changes](#submitting-changes)
- [Testing Guidelines](#testing-guidelines)

---

## 🤝 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Our Standards

- ✅ Be respectful and constructive
- ✅ Focus on what's best for the community
- ✅ Show empathy towards others
- ✅ Accept constructive criticism gracefully

### Unacceptable Behavior

- ❌ Harassment or discriminatory language
- ❌ Trolling or insulting comments
- ❌ Publishing others' private information
- ❌ Unprofessional conduct

---

## 🚀 How Can I Contribute?

### Reporting Bugs

**Before submitting a bug report**:
1. Check existing [Issues](https://github.com/yourusername/mini-coder-brain/issues)
2. Try the latest version
3. Test with a fresh installation

**Bug Report Template**:
```markdown
**Environment**:
- OS: [e.g., Ubuntu 22.04, macOS 14.0, Windows WSL2]
- Claude Code Version: [e.g., 2.0.5]
- Mini-CoderBrain Version: [e.g., 2.0.0]
- Project Type: [e.g., React, Python, Rust]

**Steps to Reproduce**:
1. Install Mini-CoderBrain
2. Open Claude Code
3. ...

**Expected Behavior**:
[What you expected to happen]

**Actual Behavior**:
[What actually happened]

**Error Messages**:
```
[Paste any error messages here]
```

**Screenshots** (if applicable):
[Add screenshots]
```

### Suggesting Enhancements

**Enhancement Suggestion Template**:
```markdown
**Feature Description**:
[Clear description of the feature]

**Use Case**:
[Why is this feature needed?]

**Proposed Solution**:
[How would this work?]

**Alternatives Considered**:
[Other approaches you've thought about]

**Additional Context**:
[Any other relevant information]
```

### Contributing Code

We welcome:
- 🐛 Bug fixes
- ✨ New features
- 📝 Documentation improvements
- 🎨 UI/UX enhancements
- ⚡ Performance optimizations
- 🧪 Test coverage improvements

---

## 🛠️ Development Setup

### Prerequisites

- Bash shell (macOS/Linux/WSL)
- Git
- Claude Code v2.0+
- jq (optional but recommended)

### Fork and Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/YOUR_USERNAME/mini-coder-brain.git
cd mini-coder-brain

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/mini-coder-brain.git
```

### Development Environment

```bash
# Test installation locally
./install.sh /tmp/test-project

# Or create a dedicated test project
mkdir -p ~/test-mini-coderbrain
./install.sh ~/test-mini-coderbrain
```

### Project Structure

```
mini-coder-brain/
├── .claude/                 # Core system
│   ├── hooks/              # Hook scripts
│   ├── commands/           # Slash commands
│   ├── memory/             # Memory templates
│   └── rules/              # Reference guidelines
├── docs/                    # Public documentation
├── .development/            # Internal docs (not in git)
├── install.sh              # Installer script
└── README.md               # Main documentation
```

---

## 📏 Coding Standards

### Bash Scripts (Hooks)

**Style**:
```bash
#!/usr/bin/env bash
set -euo pipefail  # Strict mode

# Clear comments
# Use meaningful variable names
ROOT="${CLAUDE_PROJECT_DIR:-.}"
MB="$ROOT/.claude/memory"

# Function naming: lowercase_with_underscores
detect_project_type() {
    local project_path="$1"
    # ...
}

# Error handling
if [ ! -f "$file" ]; then
    echo "Error: File not found" >&2
    exit 1
fi
```

**Token Efficiency Rules** (Critical):
```bash
# ✅ DO: Keep output minimal
echo "🧠 [CODERBRAIN: ACTIVE]"

# ❌ DON'T: Verbose output (causes token bloat)
echo "Mini-CoderBrain is now active and ready for development..."

# ✅ DO: Use context-loaded flag to prevent duplication
if [ -f "$CLAUDE_TMP/context-loaded.flag" ]; then
    echo '{"decision": "approve"}'
    exit 0
fi

# ❌ DON'T: Re-inject context via additionalContext
```

### Markdown Documentation

**Style**:
- Use clear headings (H1 for title, H2 for sections)
- Include code examples with syntax highlighting
- Add emoji for visual clarity (but don't overuse)
- Keep paragraphs short and scannable

**Example**:
```markdown
## 🚀 Feature Name

Brief description of the feature.

### Usage

​```bash
command --option value
​```

### Benefits

- ✅ Benefit 1
- ✅ Benefit 2
```

### JSON Configuration

**Style**:
```json
{
  "setting_name": "value",
  "nested_setting": {
    "option": true
  }
}
```

- Use 2-space indentation
- Include descriptive comments in documentation
- Validate JSON before committing

---

## 📤 Submitting Changes

### Branch Naming

```bash
# Feature branches
git checkout -b feature/add-new-command

# Bug fix branches
git checkout -b fix/context-loading-error

# Documentation branches
git checkout -b docs/improve-installation-guide
```

### Commit Messages

**Format**:
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples**:
```bash
# Good commit messages
git commit -m "feat(hooks): add zero-duplication context loading"
git commit -m "fix(cleanup): correct session update threshold detection"
git commit -m "docs(readme): update installation instructions for v2.0"

# Bad commit messages (avoid)
git commit -m "fix stuff"
git commit -m "updates"
```

### Pull Request Process

1. **Update your fork**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Make your changes**
   - Follow coding standards
   - Add tests if applicable
   - Update documentation

3. **Test your changes**
   ```bash
   # Test installation
   ./install.sh /tmp/test-project

   # Verify hooks work
   cd /tmp/test-project
   # Test in Claude Code
   ```

4. **Create Pull Request**
   - Use the PR template (auto-loaded on GitHub)
   - Link related issues
   - Describe changes clearly
   - Include screenshots if UI-related

**Pull Request Template**:
```markdown
## Description
[Clear description of changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Tested on macOS
- [ ] Tested on Linux
- [ ] Tested on Windows WSL
- [ ] Tested with different project types

## Checklist
- [ ] Code follows project style guidelines
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] Tests added/updated
```

---

## 🧪 Testing Guidelines

### Manual Testing

**Basic Test**:
```bash
# 1. Fresh installation
./install.sh /tmp/test-project

# 2. Start Claude Code in test project
cd /tmp/test-project

# 3. Verify boot status appears
# Expected: "🧠 [CODERBRAIN: ACTIVE]"

# 4. Test commands
/memory-sync
/context-update
/memory-cleanup --dry-run
```

**Multi-Turn Test**:
```bash
# 1. Have 10+ turn conversation
# 2. Verify no "Prompt is too long" error
# 3. Check context persists across turns
# 4. Verify AI quality stays consistent
```

### Automated Testing

**Hook Validation**:
```bash
# Test user-prompt hook
echo '{"session_id":"test"}' | .claude/hooks/conversation-capture-user-prompt.sh

# Verify: Returns JSON with "decision": "approve"
# Verify: No "additionalContext" field (zero duplication)
```

**Installation Test**:
```bash
# Test installer
./install.sh /tmp/test-install

# Verify files copied
test -d /tmp/test-install/.claude
test -f /tmp/test-install/CLAUDE.md

# Verify hooks executable
test -x /tmp/test-install/.claude/hooks/session-start.sh
```

---

## 🏆 Recognition

Contributors will be recognized in:
- README.md (Contributors section)
- Release notes
- CHANGELOG.md

Significant contributions may earn you:
- Maintainer status
- Contributor badge
- Mention in project announcements

---

## 📚 Resources

### Documentation
- [README.md](README.md) - Project overview
- [INSTALLATION.md](INSTALLATION.md) - Installation guide
- [CLAUDE.md](docs/CLAUDE.md) - System controller
- [SRS](docs/SRS-MINI-CODERBRAIN.md) - System specification

### Community
- [GitHub Issues](https://github.com/yourusername/mini-coder-brain/issues)
- [GitHub Discussions](https://github.com/yourusername/mini-coder-brain/discussions)

### Development
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [DISTRIBUTION-READY.md](DISTRIBUTION-READY.md) - Release checklist

---

## ❓ Questions?

- **General Questions**: [GitHub Discussions](https://github.com/yourusername/mini-coder-brain/discussions)
- **Bug Reports**: [GitHub Issues](https://github.com/yourusername/mini-coder-brain/issues)
- **Feature Requests**: [GitHub Issues](https://github.com/yourusername/mini-coder-brain/issues)

---

## 📜 License

By contributing to Mini-CoderBrain, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Mini-CoderBrain!** 🚀

Together, we're building the best context awareness system for Claude Code.
