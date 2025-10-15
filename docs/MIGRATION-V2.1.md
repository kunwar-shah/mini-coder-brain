# Migration Guide: v2.0 → v2.1

**Version**: 2.0.0 → 2.1.0
**Release Date**: October 2025
**Migration Time**: 5 minutes
**Breaking Changes**: None (100% backward compatible)

---

## 🎯 TL;DR - Quick Migration

**Good News**: v2.1 is 100% backward compatible! Your v2.0 project works unchanged.

**To upgrade**:
1. Pull latest changes from `v2.1-development` branch
2. Restart Claude Code
3. **(Optional)** Try new profiles: edit `CLAUDE.md` line ~41

**That's it!** v2.1 features are automatically available.

---

## ✨ What's New in v2.1

### 1. Behavior Profiles (NEW)
Customizable AI modes for different development contexts.

**4 Core Profiles**:
- `default` (200 tokens) - Balanced mode (same as v2.0 behavior)
- `focus` (150 tokens) - Deep concentration, minimal output
- `research` (300 tokens) - Detailed exploration and learning
- `implementation` (200 tokens) - Rapid feature building

**Plus**: Custom profile template for creating your own

---

### 2. Behavioral Patterns Library (NEW)
4,700 lines of behavioral training, accessible on-demand.

**5 Core Patterns**:
- pre-response-protocol.md - MANDATORY 5-step checklist
- context-utilization.md - Memory bank usage without duplication
- proactive-behavior.md - When/how to suggest things
- anti-patterns.md - What NOT to do (1200 lines of examples)
- tool-selection-rules.md - Which tool for each task

**Token Cost**: +0 (patterns read on-demand, not injected)

---

### 3. Smart Metrics System (NEW)
Automatic tracking of behavioral effectiveness.

**Features**:
- Background metrics collection (zero user action)
- `/metrics` command for insights
- Tool usage tracking
- Profile performance comparison
- Privacy-first (no sensitive data stored)

**Token Cost**: +0 (background collection only)

---

## 📊 Impact Comparison

| Feature | v2.0 | v2.1 | Change |
|---------|------|------|--------|
| Token Efficiency | 79.9% reduction | 79.8% reduction | -0.1% (minimal) |
| Conversation Length | 100+ turns | 100+ turns | Same |
| Behavioral Modes | 1 (fixed) | 4+ (customizable) | **NEW** |
| Patterns Library | Inline | Modular (4,700 lines) | **NEW** |
| Metrics Tracking | None | Automatic | **NEW** |
| Profiles | None | 4 + custom | **NEW** |

**Net Token Impact**: +200 tokens per session (~0.1% of context window)

---

## 🔄 Migration Steps

### Step 1: Update Your Code

#### Option A: Git Pull (Recommended)
```bash
cd /path/to/your/project
git fetch origin
git checkout v2.1-development
git pull origin v2.1-development
```

#### Option B: Manual Update
```bash
# Backup your current .claude/ folder
cp -r .claude .claude-backup

# Download v2.1
git clone -b v2.1-development https://github.com/kunwar-shah/mini-coder-brain.git mini-coder-brain-v2.1
cd mini-coder-brain-v2.1

# Copy new files to your project
cp -r .claude/patterns /path/to/your/project/.claude/
cp -r .claude/profiles /path/to/your/project/.claude/
cp -r .claude/metrics /path/to/your/project/.claude/
cp .claude/hooks/metrics-collector.sh /path/to/your/project/.claude/hooks/
cp .claude/hooks/metrics-report.sh /path/to/your/project/.claude/hooks/
cp .claude/commands/metrics.md /path/to/your/project/.claude/commands/

# Update modified files
cp .claude/hooks/session-start.sh /path/to/your/project/.claude/hooks/
cp .claude/hooks/session-end.sh /path/to/your/project/.claude/hooks/
cp CLAUDE.md /path/to/your/project/

# Make scripts executable
chmod +x /path/to/your/project/.claude/hooks/*.sh
```

---

### Step 2: Restart Claude Code

Close and reopen Claude Code in your project.

**Verify v2.1 is active**:
```
🧠 [MINI-CODERBRAIN: ACTIVE] - YourProject
🎯 Focus: General Development
📂 Context: .claude/memory/ (loaded)
🎭 Profile: default                    ← NEW LINE
⚡ Ready for development
```

If you see `🎭 Profile: default`, v2.1 is working!

---

### Step 3: Optional - Try Behavior Profiles

Edit `CLAUDE.md` (around line 41):

```yaml
# Behavior Profile (v2.1+)
behavior_profile: "focus"  # Try: default, focus, research, implementation
```

**Save** and restart Claude Code to see the new profile in action.

---

## 🎭 Understanding Profiles

### default (200 tokens)
**Same as v2.0 behavior** - Balanced, context-aware, proactive.

**Use when**:
- General full-stack development
- Learning new project
- Unsure which profile to use

**Output**: Standard explanations, 2-5 suggestions per session

---

### focus (150 tokens)
**Deep concentration mode** - Terse, minimal output, low proactivity.

**Use when**:
- Complex bug fixes
- Time-sensitive delivery
- Need maximum concentration

**Output**: ~50 word responses, 0-1 suggestions per session
**Token Savings**: 25% lighter than default

---

### research (300 tokens)
**Exploration mode** - Verbose, detailed explanations, high proactivity.

**Use when**:
- Understanding new codebase
- Learning patterns
- Creating documentation

**Output**: ~300 word responses, 5-10 suggestions per session
**Token Cost**: 50% heavier than default (worth it for learning)

---

### implementation (200 tokens)
**Rapid build mode** - Action-oriented, step-by-step execution.

**Use when**:
- Building new features
- Prototyping MVP
- Sprint work

**Output**: Step-by-step progress, 3-6 suggestions per session

---

## 📊 Using Metrics

### View Current Session
```
/metrics
```

**Output**:
```
📊 METRICS - Current Session (45 mins, default profile)

Tool Usage:
Read: 12 | Edit: 8 | Bash: 4 | Grep: 5

Session Outcome:
✅ Tasks Completed: 3
⚠️  Errors: 1
```

### View Weekly Summary
```
/metrics --weekly
```

### Compare Profiles
```
/metrics --profile
```

**Insights**:
- Which tools you use most
- Which profiles are most effective
- Session duration patterns
- Task completion rates

---

## 🔧 Advanced: Custom Profiles

### Create Your Own Profile

1. **Copy template**:
   ```bash
   cp .claude/profiles/custom-template.md .claude/profiles/my-workflow.md
   ```

2. **Edit settings**:
   ```markdown
   ## Core Settings
   output_style: terse           # terse, balanced, verbose
   proactivity: low              # low, medium, high
   explanation_depth: minimal    # minimal, standard, detailed
   ```

3. **Activate**:
   ```yaml
   # In CLAUDE.md:
   behavior_profile: "my-workflow"
   ```

See [.claude/profiles/custom-template.md](.claude/profiles/custom-template.md) for full template.

---

## 🐛 Troubleshooting

### Profile Not Showing
**Problem**: Session status doesn't show `🎭 Profile: ...`

**Solution**:
1. Check `CLAUDE.md` line ~41 has `behavior_profile:` setting
2. Restart Claude Code
3. If still missing, profile detection may have failed - defaults to "default" profile

---

### Metrics Not Working
**Problem**: `/metrics` command shows "No session data"

**Solution**:
1. Metrics collected at session end - work for a bit first
2. Check `.claude/metrics/sessions/` folder exists
3. Ensure `jq` is installed: `apt-get install jq` (or `brew install jq` on macOS)

---

### Different Behavior Than v2.0
**Problem**: Claude seems to behave differently

**Reason**: You may have accidentally changed profile

**Solution**:
1. Check `CLAUDE.md` line ~41
2. Set to `behavior_profile: "default"` for v2.0 behavior
3. Restart Claude Code

---

## ↩️ Rolling Back to v2.0

If you encounter issues, easily rollback:

### Option 1: Git Tag
```bash
git checkout v2.0-stable
```

### Option 2: Restore Backup
```bash
cp -r .claude-backup .claude
```

### Option 3: Reinstall v2.0
```bash
git clone -b main https://github.com/kunwar-shah/mini-coder-brain.git
# Follow v2.0 installation steps
```

---

## 📚 Additional Resources

### Documentation
- [Behavior Profiles Guide](.claude/profiles/README.md)
- [Patterns Library](.claude/patterns/README.md)
- [Metrics System](.claude/metrics/README.md)
- [V2.1 Release Notes](docs/v2-planning/V2.1-RELEASE-NOTES.md)

### Customization
- [Custom Profile Template](.claude/profiles/custom-template.md)
- [Pattern Reference](.claude/patterns/)

### Support
- [GitHub Issues](https://github.com/kunwar-shah/mini-coder-brain/issues)
- [v2.1 Development Branch](https://github.com/kunwar-shah/mini-coder-brain/tree/v2.1-development)

---

## ✅ Migration Checklist

Before considering migration complete:

- [ ] Pulled v2.1 code or manually updated files
- [ ] Restarted Claude Code
- [ ] Verified `🎭 Profile: default` appears in session status
- [ ] **(Optional)** Tried different profiles
- [ ] **(Optional)** Ran `/metrics` command
- [ ] Confirmed project works as expected
- [ ] **(Optional)** Created custom profile for your workflow

---

## 🎉 Welcome to v2.1!

You now have:
- ✅ **Customizable AI behavior** via profiles
- ✅ **4,700 lines of training** accessible on-demand
- ✅ **Automatic metrics tracking** for data-driven insights
- ✅ **100% backward compatibility** with v2.0
- ✅ **Same token efficiency** (79.8% reduction maintained)

**Enjoy your enhanced Mini-CoderBrain experience!** 🚀

---

**Questions?** Open an issue on [GitHub](https://github.com/kunwar-shah/mini-coder-brain/issues)
