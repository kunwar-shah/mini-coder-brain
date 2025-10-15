# User Guide: Smart Metrics System

**Version**: 2.1.0
**Feature**: Automatic Behavioral Effectiveness Tracking
**Token Cost**: 0 (background collection, never injected)

---

## 📋 Table of Contents

1. [What Are Smart Metrics?](#what-are-smart-metrics)
2. [What We Track](#what-we-track)
3. [Using the /metrics Command](#using-the-metrics-command)
4. [Understanding Metrics Data](#understanding-metrics-data)
5. [Privacy & Data Storage](#privacy--data-storage)
6. [Optimization Based on Metrics](#optimization-based-on-metrics)
7. [Troubleshooting](#troubleshooting)
8. [FAQ](#faq)

---

## What Are Smart Metrics?

Smart metrics **automatically track** how effectively Mini-CoderBrain works for you.

### Think of metrics like:
- **Fitness tracker** for your development workflow
- **Performance dashboard** for AI behavior
- **Analytics** for productivity
- **A/B testing** for profile effectiveness

### Key Features

✅ **Zero Overhead**: Collected in background, no user action required
✅ **Privacy-First**: No sensitive content stored (only metadata)
✅ **Actionable**: Use data to optimize your workflow
✅ **Profile Comparison**: See which profiles work best
✅ **Tool Insights**: Understand your tool usage patterns

---

## What We Track

### 1. Tool Usage Metrics

**What**: Which tools used, how often

**Examples**:
```
Read: 15 uses
Edit: 10 uses
Bash: 8 uses
Grep: 6 uses
Glob: 4 uses
```

**Why Useful**:
- Identify most-used tools
- Spot inefficiencies (too many Bash commands?)
- Validate tool selection patterns

---

### 2. Session Metrics

**What**: Session characteristics and outcomes

**Tracked**:
- Duration (minutes)
- Operation count
- Active profile
- Tasks completed
- Errors encountered

**Example**:
```json
{
  "duration_minutes": 45,
  "tool_uses": 47,
  "profile": "default",
  "tasks_completed": 3,
  "errors": 1
}
```

**Why Useful**:
- Measure productivity
- Compare session effectiveness
- Track progress over time

---

### 3. Profile Performance

**What**: How profiles perform for you

**Tracked**:
- Token usage (actual vs estimated)
- Response characteristics
- Suggestion frequency
- User satisfaction indicators

**Example**:
```
focus profile:
- Avg duration: 32 mins
- Avg operations: 38/session
- Token usage: 148 (vs 150 estimated)
- User corrections: 0.2/session
```

**Why Useful**:
- Choose optimal profile for tasks
- Validate profile effectiveness
- Customize profiles based on data

---

### 4. Behavioral Quality (Future)

**Planned for v2.2**:
- Context check compliance
- Banned questions counter
- Proactive suggestion quality

---

## What We DON'T Track

❌ **Code content** (no file contents stored)
❌ **File names** (only tool usage counts)
❌ **Commit messages** (no git data)
❌ **Personal information** (no user data)
❌ **Conversation content** (only metadata)

**Privacy-First Design**: Only behavioral metadata collected

---

## Using the /metrics Command

### Basic Usage

#### View Current Session
```
/metrics
```

**Output**:
```
📊 METRICS - Current Session (45 mins, default profile)

Tool Usage:
  Read: 12 | Edit: 8 | Bash: 4
  Grep: 5 | Glob: 3 | Write: 2

Behavioral Quality:
  ✅ Metrics collection active
  📊 Full metrics available at session end

---
Metrics file: sessionstart-1697123456.json
```

**When to Use**: Check progress during long session

---

#### View Weekly Summary
```
/metrics --weekly
```

**Output**:
```
📊 METRICS - Last 7 Days (8 sessions)

Profile Usage:
  default: 5 sessions (62.5%)
  focus: 2 sessions (25%)
  research: 1 session (12.5%)

Top Tools:
  1. Read: 98 uses
  2. Edit: 67 uses
  3. Bash: 45 uses
  4. Grep: 34 uses
  5. Glob: 23 uses

Session Outcomes (Avg):
  Duration: 38 mins
  Tasks: 2.4/session
  Errors: 0.6/session

---
Data from 8 sessions
```

**When to Use**: Weekly workflow review

---

#### Compare Profiles
```
/metrics --profile
```

**Output**:
```
📊 METRICS - Profile Comparison (Last 30 days)

Profile: default (15 sessions)
  Avg Operations: 47/session
  Avg Duration: 45 mins

Profile: focus (8 sessions)
  Avg Operations: 38/session
  Avg Duration: 32 mins

Profile: research (4 sessions)
  Avg Operations: 52/session
  Avg Duration: 62 mins

---
Compare profiles to optimize workflow
```

**When to Use**: Deciding which profile to use

---

#### Full Report
```
/metrics --all
```

**Output**: Combined view of session + weekly + profile data

**When to Use**: Comprehensive analysis

---

## Understanding Metrics Data

### Tool Usage Insights

#### High Read Count
```
Read: 50 | Edit: 10
```

**Interpretation**: Good balance, reading before editing
**Action**: None needed, healthy pattern

---

#### High Write Count
```
Write: 20 | Edit: 5
```

**Interpretation**: Creating many new files
**Potential Issue**: Should some be edits instead?
**Action**: Review if refactoring existing code vs writing new

---

#### High Bash Count
```
Bash: 30 | Read: 10
```

**Interpretation**: Many terminal commands
**Potential Issue**: Using Bash instead of specialized tools?
**Action**: Review tool-selection-rules pattern

---

### Session Duration Patterns

#### Short Sessions (< 20 mins)
**Possible Reasons**:
- Quick bug fixes
- Focused tasks (good!)
- Context issues (investigate)

---

#### Long Sessions (> 90 mins)
**Possible Reasons**:
- Complex features (normal)
- Flow state (great!)
- Potential: Consider breaks

---

### Profile Effectiveness

#### Metric: Operations Per Session

```
focus: 38 ops/session
default: 47 ops/session
research: 52 ops/session
```

**Interpretation**:
- Focus: Terse output = fewer operations needed
- Default: Balanced
- Research: Verbose = more operations (but deeper work)

**Not a competition**: Different profiles for different goals!

---

#### Metric: Session Duration

```
focus: 32 mins avg
default: 45 mins avg
research: 62 mins avg
```

**Interpretation**:
- Focus: Faster execution (goal achieved!)
- Research: Longer exploration (by design)
- Default: Balanced middle ground

**Match to task**: Choose profile based on time available

---

## Privacy & Data Storage

### What's Stored

**Location**: `.claude/metrics/sessions/*.json`

**Format**: JSON files, one per session

**Size**: ~1-2 KB per session

**Retention**: 30 days (auto-archived)

**Example Structure**:
```json
{
  "session_id": "sessionstart-1697123456",
  "timestamp": "2025-10-15T14:30:00Z",
  "profile": "default",
  "metrics": {
    "tool_usage": {
      "Read": 12,
      "Edit": 8
    },
    "session_outcome": {
      "duration_minutes": 45,
      "tool_uses": 47
    }
  }
}
```

**No Sensitive Data**: Only tool names and counts, no file paths or content

---

### Data Management

#### View Stored Metrics
```bash
ls .claude/metrics/sessions/
```

#### Delete Metrics Manually
```bash
rm .claude/metrics/sessions/*.json
```

#### Auto-Cleanup
- Runs at session end
- Archives files > 30 days old
- Moved to `.claude/metrics/archive/YYYY-MM/`
- Never deletes (archives for history)

---

### Privacy Guarantees

✅ **Local Only**: Never sent to external services
✅ **No Code**: File contents never stored
✅ **No Paths**: File names not tracked
✅ **Metadata Only**: Tool usage counts only
✅ **User Control**: Delete anytime

---

## Optimization Based on Metrics

### Scenario 1: Too Many Bash Commands

**Metrics Show**:
```
Bash: 40 | Read: 10 | Edit: 8
```

**Analysis**: Using Bash excessively

**Optimization**:
1. Review last session: What Bash commands?
2. Check tool-selection-rules pattern
3. Use specialized tools:
   - `cat file.txt` → Use Read tool
   - `grep "pattern"` → Use Grep tool
   - `find . -name` → Use Glob tool

**Expected Result**: Bash count drops, Read/Grep/Glob increase

---

### Scenario 2: Profile Mismatch

**Metrics Show**:
```
default profile:
- Duration: 65 mins (long!)
- Operations: 85 (high!)
- Task completed: 1 (low!)
```

**Analysis**: Default might be too verbose for this work

**Optimization**:
1. Try focus profile for this task type
2. Compare metrics after switch
3. Stick with faster profile if better

**Expected Result**: Shorter duration, fewer ops, more tasks

---

### Scenario 3: Low Productivity

**Metrics Show**:
```
Weekly:
- 10 sessions
- Avg tasks: 0.8/session (low!)
- Avg errors: 2.3/session (high!)
```

**Analysis**: Something's not working well

**Optimization**:
1. Check error patterns (Git issues? Build failures?)
2. Review context quality: `/validate-context`
3. Consider profile change
4. Check if project structure detection worked

**Expected Result**: Task completion improves, errors decrease

---

## Troubleshooting

### Problem: No Metrics Data

**Symptom**: `/metrics` shows "No session data available"

**Causes**:
1. First session (no data yet)
2. Metrics collection not started
3. jq not installed

**Solutions**:
```bash
# Check metrics folder exists
ls .claude/metrics/sessions/

# Check if jq installed
which jq

# Install jq if missing
# Ubuntu/Debian:
sudo apt-get install jq

# macOS:
brew install jq

# Restart Claude Code
```

---

### Problem: Metrics File Not Created

**Symptom**: Session completed but no metrics file

**Causes**:
1. Session too short (< 1 min)
2. Metrics collector script not executable
3. Session ended abnormally

**Solutions**:
```bash
# Make metrics collector executable
chmod +x .claude/hooks/metrics-collector.sh
chmod +x .claude/hooks/metrics-report.sh

# Test manually
.claude/hooks/metrics-collector.sh init

# Check if file created
ls .claude/metrics/sessions/
```

---

### Problem: Inaccurate Metrics

**Symptom**: Numbers don't match expectations

**Causes**:
1. Metrics collected at session end (incomplete mid-session)
2. Multiple sessions overlapping
3. Manual file operations not tracked

**Solutions**:
- Wait for session end for accurate totals
- Avoid running multiple Claude instances
- Metrics track AI operations, not manual edits

---

## FAQ

### Q: Do metrics slow down Claude?
**A**: No! Collection happens in background, zero performance impact.

### Q: Can I disable metrics?
**A**: Yes! Remove or comment out metrics calls in hooks. But why? Zero overhead!

### Q: Are metrics sent to external servers?
**A**: No! Everything stored locally in `.claude/metrics/`.

### Q: Can I export metrics?
**A**: Yes! Files are JSON, easy to parse and analyze externally.

### Q: Do metrics affect token usage?
**A**: No! Collection is background only, zero token cost.

### Q: How long are metrics kept?
**A**: 30 days active, then archived. Never deleted, always accessible.

### Q: Can I see metrics for other team members?
**A**: No, metrics are per-machine. Each developer has their own.

### Q: What if I delete metrics folder?
**A**: Metrics restart fresh. No impact on Mini-CoderBrain functionality.

---

## 🎯 Key Takeaways

1. **Automatic Collection**: Zero user action required
2. **Privacy-First**: No sensitive data, only metadata
3. **Tool Insights**: Understand your workflow patterns
4. **Profile Comparison**: Data-driven profile selection
5. **Optimization**: Use metrics to improve productivity
6. **Local Storage**: Everything stays on your machine
7. **Zero Cost**: No token impact, no performance impact

---

## 📚 Related Documentation

- [Behavior Profiles Guide](USER-GUIDE-PROFILES.md) - Compare profile performance with metrics
- [Patterns Guide](USER-GUIDE-PATTERNS.md) - Patterns define what metrics track
- [Migration Guide](MIGRATION-V2.1.md) - Metrics are new in v2.1
- [Metrics System](.claude/metrics/README.md) - Technical details

---

## 💡 Pro Tips

### Tip 1: Weekly Review Habit
```bash
# Every Monday morning:
/metrics --weekly

# Review patterns, adjust workflow
```

### Tip 2: Profile Experimentation
```bash
# Try new profile for a week
behavior_profile: "focus"

# After week, compare:
/metrics --profile

# Data-driven decision!
```

### Tip 3: Export for Analysis
```bash
# Export metrics to CSV
jq -r '.metrics.tool_usage | to_entries | .[] | [.key, .value] | @csv' \
  .claude/metrics/sessions/*.json > tool_usage.csv

# Analyze in spreadsheet
```

### Tip 4: Team Insights
Share aggregated (anonymized) metrics with team to identify best practices!

---

**Data-driven development with zero overhead!** 📊

Need help? Open an issue: [GitHub Issues](https://github.com/kunwar-shah/mini-coder-brain/issues)
