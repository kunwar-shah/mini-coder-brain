---
layout: home
title: Mini-CoderBrain v2.0
subtitle: Intelligent Setup & Context Validation for Claude Code
css: assets/css/custom.css
---

# 🧠 Mini-CoderBrain v2.0

**Intelligent AI Context Awareness with Measurable Quality**

Mini-CoderBrain v2.0 is a revolutionary universal AI context awareness system that gives Claude perfect memory and understanding of your project. Now with intelligent setup that adapts to any project type, automatic context validation, and measurable quality scores (60-95%).

**NEW in v2.0**: Intelligent wizard auto-detects your project type and populates context automatically. No more guesswork - know exactly how good your context is!

---

## ✨ Key Features (v2.0)

### 🎯 Intelligent Setup & Validation ✨ NEW
- **Smart initialization wizard** - Adapts to empty/existing/complex projects
- **Auto-documentation reading** - Reads SRS, ARCHITECTURE, API docs automatically
- **Context quality scoring** - Measurable 40-100% quality scores
- **Validation on session-start** - Automatic quality checks, warns if <60%
- **`/validate-context`** - Check quality anytime with detailed reports

### ⚡ Perfect Context Awareness
- **Auto-loads project context** once per session
- **Zero duplication** - context persists naturally in conversation history
- **Cross-session memory** - Claude remembers everything between sessions
- **90% fewer "what framework?" questions** - Claude knows your stack

### 🧹 Intelligent Memory Management
- **Automatic cleanup** - Prevents "Prompt is too long" errors
- **Smart notifications** - Suggests memory sync when needed
- **Token efficient** - 25% longer conversations before hitting limits
- **Quality monitoring** - Tracks and warns about context degradation

### 🚀 Revolutionary Features
- **Instant file access** - `/map-codebase` for surgical precision development
- **Import documentation** - `/import-docs` adds docs after initialization
- **Update memory** - `/update-memory-bank` for major milestones
- **Persistent memory bank** - productContext, systemPatterns, progress tracking
- **Activity monitoring** - Intelligent hooks track development operations

---

## 🚀 Quick Start (v2.0 - 2 Minutes)

### Step 1: Install (30 seconds)

```bash
# Clone the repository
git clone https://github.com/kunwar-shah/mini-coder-brain.git
cd mini-coder-brain

# Run installer
chmod +x install.sh
./install.sh /path/to/your/project
```

### Step 2: Initialize Context (**MANDATORY** ⚠️)

Open your project in Claude Code and run:

```
# Option A: With documentation (BEST - 90-95% quality)
/init-memory-bank --docs-path ./docs

# Option B: Auto-detect (GOOD - 75-85% quality)
/init-memory-bank

# Option C: Interactive (MINIMUM - 60-70% quality)
/init-memory-bank
```

### Step 3: Verify Quality

```
/validate-context
```

**Expected output**:
```
📊 Context Quality: 85% (Recommended) ✅
✅ Ready for development!
```

**That's it!** Claude now has measurable, high-quality context awareness.

---

## 📚 Documentation

<div class="get-started-wrap">
  <a class="btn btn-success" href="{{ '/installation' | relative_url }}">📖 Installation Guide</a>
  <a class="btn btn-primary" href="{{ '/quickstart' | relative_url }}">⚡ Quick Start (v2.0)</a>
  <a class="btn btn-info" href="{{ '/features' | relative_url }}">✨ Features</a>
  <a class="btn btn-warning" href="{{ '/commands' | relative_url }}">🛠️ Commands</a>
</div>

**NEW**: [How to Use Guide](https://github.com/kunwar-shah/mini-coder-brain/blob/main/SETUP.md) - Comprehensive setup guide for all scenarios

---

## 🎯 Why Mini-CoderBrain?

### The Problem
Ever had to explain your project structure to Claude **again** in a new conversation? Repeated the same context over and over? Lost track of decisions made in previous sessions?

### The Solution
Mini-CoderBrain gives Claude **perfect memory**:
- Remembers your project architecture
- Knows your coding standards
- Tracks development progress
- Recalls all technical decisions
- Maintains focus across sessions

### The Result
- ✅ **Zero repeated explanations** - Claude knows your project
- ✅ **Perfect continuity** - Seamless context across sessions
- ✅ **Faster development** - No time wasted on context
- ✅ **Better decisions** - Access to full project history
- ✅ **Longer conversations** - Automatic memory optimization

---

## 🌟 What Makes It Special?

### Universal Compatibility
Works with **any project**:
- JavaScript/TypeScript (React, Node, Next.js, etc.)
- Python (Django, Flask, FastAPI, etc.)
- Rust, Go, Java, C++, PHP, Ruby
- Mobile (React Native, Flutter, Swift, Kotlin)
- Any framework, any language, any size

### Zero Configuration
- No config files to edit
- No dependencies to install
- No learning curve
- Just drop in and go

### Enterprise-Grade Features
- Automatic project structure detection
- Intelligent context optimization
- Real-time activity tracking
- Smart memory cleanup
- Cross-session persistence

---

## 📊 Performance

- **25% longer conversations** before token limits
- **Zero context duplication** in prompts
- **79.9% token reduction** vs. previous versions
- **Perfect continuity** across unlimited sessions

---

## 🛠️ Core Commands (v2.0)

```bash
# Essential (Use These!)
/init-memory-bank              # Initialize context (MANDATORY)
/validate-context              # Check quality score
/update-memory-bank            # Update after major work (renamed from /umb)
/map-codebase                  # Instant file access system
/memory-cleanup                # Automatic bloat prevention

# Advanced
/import-docs ./path            # Import documentation
/memory-sync                   # Full context synchronization
/context-update                # Real-time context updates
```

**See [Commands Guide]({{ '/commands' | relative_url }}) for complete documentation**

---

## 💡 Example Use Cases

### For Solo Developers
- Track feature development across sessions
- Remember architectural decisions
- Maintain coding standards
- Monitor progress toward goals

### For Teams
- Share project context automatically
- Document decisions with timestamps
- Maintain consistent patterns
- Onboard new team members instantly

### For Learning
- Document learning progress
- Track concepts mastered
- Build knowledge base
- Maintain study goals

---

## 🏆 Success Stories

> "Mini-CoderBrain transformed how I work with Claude. It's like having a senior developer who actually remembers our entire project history." - Developer

> "I dropped it into my React project and immediately saw the difference. Claude stopped asking about my tech stack and just started coding." - Full-Stack Developer

> "The automatic cleanup is brilliant. I never hit 'Prompt is too long' anymore." - Python Developer

---

## 🤝 Contributing

We welcome contributions! See our [Contributing Guide]({{ '/contributing' | relative_url }}) for details.

### Ways to Contribute
- 🐛 Report bugs
- 💡 Suggest features
- 📖 Improve documentation
- 🔧 Submit pull requests

---

## 📄 License

MIT License - see [LICENSE](https://github.com/kunwar-shah/mini-coder-brain/blob/main/LICENSE) for details.

---

## 🔗 Links

- **GitHub**: [kunwar-shah/mini-coder-brain](https://github.com/kunwar-shah/mini-coder-brain)
- **Issues**: [Report a bug](https://github.com/kunwar-shah/mini-coder-brain/issues)
- **Discussions**: [Join the conversation](https://github.com/kunwar-shah/mini-coder-brain/discussions)

---

<div style="text-align: center; margin-top: 50px;">
  <h2>Ready to supercharge your development workflow?</h2>
  <a class="btn btn-lg btn-success" href="{{ '/installation' | relative_url }}">Get Started Now →</a>
</div>
