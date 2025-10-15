# Smart Metrics System

**Purpose**: Track behavioral effectiveness and profile performance with zero user overhead

**Token Cost**: 0 (metrics collected in background, not injected into prompts)

---

## 🎯 What We Track

### 1. Behavioral Quality Metrics
**Goal**: Measure how well AI follows behavioral patterns

#### Context Check Compliance
- Did AI check all 5 context files before responding?
- Target: 100% compliance
- Tracks: pre-response-protocol.md adherence

#### Banned Questions Counter
- Did AI ask questions context already answers?
- Target: 0 per session
- Tracks: anti-patterns.md violations

#### Proactive Suggestion Quality
- How many suggestions made?
- Were they helpful or annoying?
- Target: 2-5 per session (balanced), varies by profile

### 2. Profile Performance Metrics
**Goal**: Compare effectiveness of different profiles

#### Token Usage
- Actual tokens used per session
- Compare: focus (150) vs default (200) vs research (300)
- Track: Real vs estimated token costs

#### Response Characteristics
- Average response length (words)
- Explanation depth
- Number of tool uses per response

#### Session Outcomes
- Tasks completed
- Errors encountered
- User corrections needed

### 3. Tool Usage Metrics
**Goal**: Validate tool selection patterns

#### Tool Frequency
- Which tools used most often?
- Are we using right tool for right job?
- Tracks: tool-selection-rules.md adherence

#### Tool Success Rate
- How often do tool calls succeed?
- Which tools cause most errors?
- Optimization opportunities

### 4. User Satisfaction Indicators
**Goal**: Indirect measures of user happiness

#### Session Continuity
- How long do sessions last?
- Do users return for next session?
- Profile switching frequency

#### Interaction Patterns
- User correction frequency
- Repeated questions (context misses)
- Positive acknowledgments

---

## 📊 Metrics Storage

### File Structure
```
.claude/metrics/
├── README.md                           # This file
├── sessions/                           # Per-session metrics
│   └── YYYY-MM-DD-HHMMSS.json         # Session metrics file
├── aggregated/                         # Aggregated data
│   └── weekly-summary.json            # Weekly rollup
└── archive/                            # Old metrics (auto-cleanup)
    └── 2025-01/                       # Archived by month
```

### Session Metrics File Format
```json
{
  "session_id": "sessionstart-1728912345",
  "timestamp": "2025-10-15T14:30:00Z",
  "profile": "default",
  "metrics": {
    "behavioral": {
      "context_checks": {
        "total_responses": 25,
        "checks_performed": 25,
        "compliance_rate": 1.0
      },
      "banned_questions": {
        "count": 0,
        "examples": []
      },
      "proactive_suggestions": {
        "count": 4,
        "accepted": 3,
        "ignored": 1
      }
    },
    "profile_performance": {
      "token_estimate": 200,
      "token_actual": 195,
      "response_avg_length": 145,
      "tool_uses": 47
    },
    "tool_usage": {
      "Read": 12,
      "Edit": 8,
      "Grep": 5,
      "Glob": 3,
      "Bash": 4,
      "Write": 2,
      "Task": 1
    },
    "session_outcome": {
      "duration_minutes": 45,
      "tasks_completed": 3,
      "errors": 1,
      "user_corrections": 2
    }
  }
}
```

---

## 🔧 How Metrics Work

### 1. Collection (Automatic)
Metrics collected by hooks during session:
- **user-prompt-submit hook**: Tracks context checks, tool usage
- **stop hook**: Records session summary, outcomes
- No user action required

### 2. Storage (Lightweight)
- JSON files in `.claude/metrics/sessions/`
- One file per session (~1-2 KB)
- Auto-cleanup after 30 days (archive old metrics)

### 3. Aggregation (On-Demand)
- Weekly summaries generated automatically
- Compare profiles, track trends
- Identify optimization opportunities

### 4. Reporting (Slash Command)
```bash
/metrics              # Show current session metrics
/metrics --session    # Current session detail
/metrics --weekly     # Last 7 days summary
/metrics --profile    # Compare profile performance
/metrics --all        # Full report
```

---

## 📈 Metrics Dashboard

### Command Output Format

#### Session Summary
```
📊 METRICS - Current Session (45 mins, default profile)

Behavioral Quality:
✅ Context Checks: 25/25 (100%)
✅ Banned Questions: 0
✅ Proactive Suggestions: 4 (3 accepted, 1 ignored)

Tool Usage:
Read: 12 | Edit: 8 | Grep: 5 | Glob: 3 | Bash: 4 | Write: 2

Session Outcome:
✅ Tasks Completed: 3
⚠️  Errors: 1
📝 User Corrections: 2
```

#### Weekly Summary
```
📊 METRICS - Last 7 Days (8 sessions)

Profile Usage:
default: 5 sessions (62.5%)
focus: 2 sessions (25%)
research: 1 session (12.5%)

Behavioral Quality (Avg):
✅ Context Checks: 97.8%
✅ Banned Questions: 0.4/session
✅ Proactive Suggestions: 3.2/session

Top Tools:
1. Read (98 uses)
2. Edit (67 uses)
3. Bash (45 uses)
4. Grep (34 uses)
5. Glob (23 uses)

Session Outcomes (Avg):
Duration: 38 mins
Tasks: 2.4/session
Errors: 0.6/session
```

#### Profile Comparison
```
📊 METRICS - Profile Comparison (Last 30 days)

                | Focus | Default | Research |
----------------|-------|---------|----------|
Sessions        | 8     | 15      | 4        |
Avg Duration    | 32m   | 45m     | 62m      |
Tasks/Session   | 2.1   | 2.6     | 1.8      |
Token Usage     | 148   | 203     | 287      |
Context Checks  | 94%   | 99%     | 100%     |
Banned Qs       | 0.2   | 0.1     | 0        |
Suggestions     | 1.2   | 3.1     | 5.7      |
User Satisfaction| 4.2/5 | 4.6/5   | 4.8/5    |
```

---

## 🎯 Target Metrics by Profile

### default Profile Targets
- Context Checks: 100%
- Banned Questions: 0
- Proactive Suggestions: 2-5 per session
- Token Usage: 190-210
- Tasks/Session: 2-3

### focus Profile Targets
- Context Checks: 90%+ (skip unnecessary checks)
- Banned Questions: 0
- Proactive Suggestions: 0-1 per session
- Token Usage: 140-160
- Tasks/Session: 2-4 (faster execution)

### research Profile Targets
- Context Checks: 100%
- Banned Questions: 0
- Proactive Suggestions: 5-10 per session
- Token Usage: 280-320
- Tasks/Session: 1-2 (depth over speed)

### implementation Profile Targets
- Context Checks: 95%+
- Banned Questions: 0
- Proactive Suggestions: 3-6 per session
- Token Usage: 190-210
- Tasks/Session: 3-5 (feature velocity)

---

## 🔍 What Metrics Tell Us

### Good Signs
✅ **High context check compliance** (95%+)
   → AI using context effectively

✅ **Zero banned questions**
   → AI checking context before asking

✅ **Profile-appropriate suggestion count**
   → Not too pushy, not too passive

✅ **High task completion rate**
   → Getting work done efficiently

✅ **Low user correction rate**
   → Understanding requirements correctly

### Warning Signs
⚠️ **Low context check compliance** (<90%)
   → AI not following pre-response protocol

⚠️ **Banned questions increasing**
   → Context not being checked properly

⚠️ **Too many/few suggestions**
   → Proactivity level wrong for profile

⚠️ **High error rate**
   → Tool selection or execution issues

⚠️ **Frequent user corrections**
   → Misunderstanding requirements

---

## 🛠 Implementation Strategy

### Phase 1: Basic Tracking (Week 3 Day 1)
- Session duration, profile, operation count
- Basic tool usage counts
- Store in simple JSON format

### Phase 2: Behavioral Metrics (Week 3 Day 2)
- Context check detection
- Banned question detection
- Proactive suggestion tracking

### Phase 3: Aggregation (Week 3 Day 3)
- Weekly summaries
- Profile comparisons
- Trend analysis

### Phase 4: Reporting (Week 3 Day 4)
- `/metrics` slash command
- Dashboard output
- Insights and recommendations

---

## 🔐 Privacy & Storage

### What We DON'T Track
❌ User's actual code or content
❌ File contents or names
❌ Personal information
❌ Git commit messages
❌ Sensitive project data

### What We DO Track
✅ Tool usage patterns
✅ Response characteristics
✅ Behavioral compliance
✅ Session metadata only

### Storage & Cleanup
- Metrics stored locally in `.claude/metrics/`
- Auto-cleanup after 30 days
- Never sent to external services
- User can delete anytime

---

## 📊 Success Metrics for Metrics System

### System Goals
1. **Zero overhead**: No user action required
2. **Lightweight**: <10 KB per session
3. **Useful insights**: Actionable data
4. **Privacy-first**: No sensitive data collected

### Validation
- Does data help improve behavioral patterns?
- Can we identify which profiles work best?
- Are there optimization opportunities?
- Is the overhead acceptable?

---

## 🚀 Future Enhancements

### v2.2+
- Visual dashboard (HTML report)
- Profile recommendations based on task type
- Automatic pattern refinement suggestions
- Export metrics for analysis

### v2.5+
- Machine learning on usage patterns
- Predictive profile suggestions
- Community-aggregated insights (opt-in)
- A/B testing framework

---

**Metrics system enables data-driven behavioral improvements while respecting privacy and maintaining zero token overhead.** 📊
