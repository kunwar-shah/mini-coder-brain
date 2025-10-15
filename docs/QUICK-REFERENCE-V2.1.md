# Mini-CoderBrain v2.1 - Quick Reference

**One-Page Cheat Sheet** | Print this for quick reference!

---

## 🎭 Behavior Profiles

### Profile Selection
```yaml
# CLAUDE.md (line ~41):
behavior_profile: "default"  # default | focus | research | implementation
```

### Profile Comparison

| Profile | Tokens | Best For | Output | Suggestions |
|---------|--------|----------|--------|-------------|
| **default** | 200 | General dev | ~150 words | 2-5/session |
| **focus** | 150 | Bug fixes | ~50 words | 0-1/session |
| **research** | 300 | Learning | ~300 words | 5-10/session |
| **implementation** | 200 | Features | ~150 words | 3-6/session |

**Apply changes**: Save `CLAUDE.md` + Restart Claude Code

---

## 📚 Patterns Library

### 5 Core Patterns (4,700 lines, zero token cost)

| Pattern | Purpose | Lines |
|---------|---------|-------|
| **pre-response-protocol** | Mandatory checklist | ~850 |
| **context-utilization** | Memory bank usage | ~750 |
| **proactive-behavior** | When to suggest | ~800 |
| **anti-patterns** | What NOT to do | ~1200 |
| **tool-selection-rules** | Which tool when | ~1100 |

**Location**: `.claude/patterns/*.md`
**Read**: On-demand (automatic)
**Cost**: 0 tokens (never injected)

---

## 📊 Metrics Commands

```bash
/metrics              # Current session
/metrics --weekly     # Last 7 days
/metrics --profile    # Profile comparison
/metrics --all        # Full report
```

**What's tracked**: Tool usage, duration, profile, operations
**What's NOT**: Code content, file names, personal data
**Storage**: `.claude/metrics/sessions/*.json`
**Retention**: 30 days (auto-archived)

---

## 🚀 Quick Start (v2.1)

### 1. Verify v2.1
```
🧠 [MINI-CODERBRAIN: ACTIVE] - ProjectName
🎯 Focus: General Development
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default                    ← v2.1 feature
⚡ Ready for development
```

### 2. Try Different Profiles
```yaml
behavior_profile: "focus"     # Deep concentration
behavior_profile: "research"  # Detailed learning
behavior_profile: "implementation" # Rapid building
```

### 3. Check Metrics
```bash
/metrics --weekly    # Review your patterns
```

---

## 🔧 Custom Profile Template

```yaml
# .claude/profiles/my-profile.md

## Core Settings
output_style: terse              # terse | balanced | verbose
proactivity: low                 # low | medium | high
explanation_depth: minimal       # minimal | standard | detailed
communication: efficient         # efficient | friendly | educational

## Focus Areas
### Primary
- [Your main focus area]

## Tool Preferences
### Prefer
- Read, Edit, Grep

### Avoid
- Task (keep focused)

# Activate in CLAUDE.md:
behavior_profile: "my-profile"
```

---

## 📁 Key Files & Locations

### Memory Bank (Context)
```
.claude/memory/
├── productContext.md        # Project overview
├── systemPatterns.md        # Coding standards
├── activeContext.md         # Current focus
├── progress.md              # Task tracking
└── decisionLog.md           # Technical decisions
```

### Behavioral System (v2.1)
```
.claude/patterns/            # Behavioral rules (4,700 lines)
.claude/profiles/            # AI modes (4 core + custom)
.claude/metrics/             # Effectiveness tracking
```

### Configuration
```
CLAUDE.md                    # Main controller
  └── Line ~41: behavior_profile
```

---

## ⚡ Common Tasks

### Switch Profile
```yaml
# 1. Edit CLAUDE.md
behavior_profile: "focus"

# 2. Restart Claude Code

# 3. Verify
# Should show: 🎭 Profile: focus
```

### View Metrics
```bash
/metrics                # Quick session view
/metrics --weekly       # Weekly patterns
```

### Create Custom Profile
```bash
# 1. Copy template
cp .claude/profiles/custom-template.md .claude/profiles/mine.md

# 2. Edit settings
nano .claude/profiles/mine.md

# 3. Activate
# In CLAUDE.md: behavior_profile: "mine"
```

### Check Context Quality
```bash
/validate-context
```

---

## 🎯 Decision Matrix

### When to Use Each Profile

```
Need deep focus?              → focus
Learning new codebase?        → research
Building features fast?       → implementation
General development?          → default
Production hotfix?            → focus
Architecture review?          → research
Sprint work?                  → implementation
Not sure?                     → default
```

---

## 📊 Token Impact

| Component | Token Cost | Impact |
|-----------|-----------|--------|
| Patterns Library | 0 | Read on-demand |
| Profile (focus) | ~150 | 25% lighter |
| Profile (default) | ~200 | Baseline |
| Profile (research) | ~300 | 50% heavier |
| Metrics System | 0 | Background |
| **Total v2.1** | **+200 avg** | **~0.1% increase** |

**v2.0**: 79.9% reduction
**v2.1**: 79.8% reduction
**Result**: Virtually unchanged efficiency!

---

## 🐛 Quick Troubleshooting

### Profile Not Showing?
```bash
# Check setting
grep "behavior_profile" CLAUDE.md

# Verify file exists
ls .claude/profiles/default.md

# Restart Claude Code
```

### Metrics No Data?
```bash
# Install jq
sudo apt-get install jq  # Ubuntu
brew install jq          # macOS

# Wait for session end
# Then try: /metrics
```

### Different Behavior?
```bash
# Reset to v2.0 behavior
behavior_profile: "default"

# Restart Claude Code
```

---

## 📚 Documentation Links

**Getting Started**:
- [README](../README.md) - Project overview
- [Migration v2.0→v2.1](MIGRATION-V2.1.md) - Upgrade guide

**User Guides**:
- [Profiles Guide](USER-GUIDE-PROFILES.md) - Complete profiles documentation
- [Patterns Guide](USER-GUIDE-PATTERNS.md) - Behavioral patterns reference
- [Metrics Guide](USER-GUIDE-METRICS.md) - Metrics system guide

**Reference**:
- [FAQ](V2.1-FAQ.md) - Common questions
- [Release Notes](v2-planning/V2.1-RELEASE-NOTES.md) - What's new

---

## 💡 Pro Tips

### 1. Profile Rotation
```
Morning:   research   (learn)
Afternoon: implementation (build)
Evening:   focus   (fix bugs)
```

### 2. Metrics-Driven Selection
```bash
# After 2 weeks:
/metrics --profile

# See which profile works best for you
# Adjust accordingly
```

### 3. Custom Task Profiles
```
Create:
- backend-focused.md
- frontend-focused.md
- devops-focused.md

Match profile to recurring workflows
```

### 4. Weekly Review
```bash
# Every Monday:
/metrics --weekly

# Identify patterns
# Optimize workflow
```

---

## ⚡ Quick Command Reference

```bash
# Core Commands
/init-memory-bank        # Initialize (mandatory first run)
/update-memory-bank      # Update context
/validate-context        # Check quality
/map-codebase           # Index files

# v2.1 Commands
/metrics                 # Current session
/metrics --weekly        # Last 7 days
/metrics --profile       # Compare profiles
/metrics --all           # Full report

# Memory Management
/memory-sync            # Sync memory bank
/memory-cleanup         # Archive old data
/context-update         # Quick context update
```

---

## 🔄 Backward Compatibility

**v2.1 is 100% backward compatible with v2.0**

- Default profile = v2.0 behavior
- No breaking changes
- All v2.0 features work
- Optional feature activation

**Upgrade risk**: None
**Migration time**: 5 minutes

---

## 📞 Get Help

**Issues**: [GitHub Issues](https://github.com/kunwar-shah/mini-coder-brain/issues)
**Docs**: [GitHub Pages](https://kunwar-shah.github.io/mini-coder-brain)
**Version**: 2.1.0
**Status**: Production-ready

---

**Print this page for quick reference!** 📄

---

*Mini-CoderBrain v2.1 - Data-driven behavioral intelligence*
