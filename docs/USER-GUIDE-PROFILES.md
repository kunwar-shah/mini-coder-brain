# User Guide: Behavior Profiles

**Version**: 2.1.0
**Feature**: Customizable AI Modes
**Token Cost**: +150-300 tokens per session (profile-dependent)

---

## 📋 Table of Contents

1. [What Are Behavior Profiles?](#what-are-behavior-profiles)
2. [Available Profiles](#available-profiles)
3. [How to Use Profiles](#how-to-use-profiles)
4. [Profile Comparison](#profile-comparison)
5. [Creating Custom Profiles](#creating-custom-profiles)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)
8. [FAQ](#faq)

---

## What Are Behavior Profiles?

Behavior profiles control **how Claude behaves** during your development session.

### Think of profiles like:
- **Text editor modes** (Vi: insert mode, command mode)
- **IDE perspectives** (Debug, Development, Testing)
- **Driving modes** (Sport, Comfort, Eco)

Each profile adjusts:
- **Output verbosity** (terse, balanced, verbose)
- **Proactivity level** (suggest rarely, sometimes, frequently)
- **Explanation depth** (minimal, standard, detailed)
- **Communication style** (efficient, friendly, educational)

### Why Use Profiles?

**Different tasks need different approaches**:
- 🐛 **Bug fixing**: Focus mode (minimal distractions)
- 📚 **Learning**: Research mode (detailed explanations)
- 🚀 **Building**: Implementation mode (rapid execution)
- ⚖️ **General work**: Default mode (balanced)

**One AI, multiple personalities**, each optimized for specific workflows!

---

## Available Profiles

### 1. default Profile

**Token Cost**: ~200 tokens
**Best For**: General full-stack development

```yaml
behavior_profile: "default"
```

**Characteristics**:
- **Output**: Balanced detail (~150 words/response)
- **Proactivity**: Medium (2-5 suggestions/session)
- **Explanations**: Standard depth
- **Tone**: Friendly and professional

**Personality**: A knowledgeable teammate who:
- Remembers your project context
- Suggests helpful next steps
- Explains decisions briefly
- Gets work done efficiently

**When to Use**:
- ✅ General development work
- ✅ Full-stack projects
- ✅ Learning new codebases
- ✅ When unsure which profile fits

**Example Session**:
```
User: "Add user authentication"

AI (default): "I'll implement JWT-based authentication. Let me start with:

1. Auth middleware for route protection
2. Login/register endpoints
3. Token generation and validation
4. Password hashing with bcrypt

[Creates files step by step]

Authentication complete. Should I add refresh token functionality?"
```

---

### 2. focus Profile

**Token Cost**: ~150 tokens (25% lighter)
**Best For**: Deep concentration, time-sensitive work

```yaml
behavior_profile: "focus"
```

**Characteristics**:
- **Output**: Terse (~50 words/response)
- **Proactivity**: Low (0-1 suggestions/session)
- **Explanations**: Minimal
- **Tone**: Direct, no-nonsense

**Personality**: A developer in deep flow state with headphones on:
- Executes immediately
- Minimal words, maximum action
- No interruptions
- Fast tool selection

**When to Use**:
- ✅ Complex bug fixes
- ✅ Production issues
- ✅ Time-sensitive delivery
- ✅ Need maximum concentration
- ✅ Want minimal distractions

**Example Session**:
```
User: "Add user authentication"

AI (focus): [Creates auth files]
              "Auth done. JWT + bcrypt. /api/auth routes."
```

**Token Savings**: Lighter responses mean longer conversations before hitting context limits.

---

### 3. research Profile

**Token Cost**: ~300 tokens (50% heavier)
**Best For**: Understanding codebases, learning, documentation

```yaml
behavior_profile: "research"
```

**Characteristics**:
- **Output**: Verbose (~300 words/response)
- **Proactivity**: High (5-10 suggestions/session)
- **Explanations**: Detailed (explains WHY)
- **Tone**: Educational, thorough

**Personality**: A senior architect doing knowledge transfer:
- Explores thoroughly before acting
- Explains WHY, not just WHAT
- Identifies patterns and relationships
- Creates comprehensive documentation

**When to Use**:
- ✅ Joining new project
- ✅ Understanding architecture
- ✅ Learning new patterns
- ✅ Creating documentation
- ✅ Code review and analysis
- ✅ Technical debt assessment

**Example Session**:
```
User: "How does authentication work?"

AI (research): "Let me explore the authentication system comprehensively.

[Searches for auth files]
[Reads key implementations]
[Analyzes patterns]

I've found your authentication follows this architecture:

1. **Entry Point**: /api/auth/[...nextauth]
   - Uses NextAuth.js for OAuth + credentials
   - Config: src/lib/auth/config.ts
   - Providers: Google, GitHub, credentials

2. **JWT Strategy**:
   - Tokens signed with HS256
   - 7-day expiration, auto-refresh
   - httpOnly cookies (XSS protection)
   - Server-side session in Redis

3. **Middleware Protection**:
   - middleware.ts intercepts all requests
   - Validates JWT before route access
   - Redirects to /login if expired

4. **Key Design Decisions** (from decisionLog.md):
   - Chose NextAuth over custom: Maintainability
   - JWT over sessions: Horizontal scalability
   - Redis for sessions: Performance + TTL

**Patterns Identified**:
- Consistent error handling across auth flows
- Centralized auth config (single source of truth)
- Test coverage: 87% (good!)

**Potential Improvements**:
- Missing rate limiting on login attempts
- No 2FA support yet
- Password reset flow could use email templates

Should I:
1. Document this architecture in systemPatterns.md?
2. Create an architecture diagram?
3. Explore security best practices further?
4. Suggest implementing 2FA?"
```

**Token Cost**: Heavier, but one good research session saves hours of confusion!

---

### 4. implementation Profile

**Token Cost**: ~200 tokens
**Best For**: Rapid feature building, prototyping, sprints

```yaml
behavior_profile: "implementation"
```

**Characteristics**:
- **Output**: Action-oriented (~150 words)
- **Proactivity**: Medium-High (3-6 suggestions/session)
- **Explanations**: Brief, focused on execution
- **Tone**: Directive, step-by-step

**Personality**: Fast-moving startup developer:
- Builds features rapidly
- Tests as you go
- Ships working code
- Action over analysis

**When to Use**:
- ✅ Building new features
- ✅ Rapid prototyping
- ✅ MVP development
- ✅ Sprint work
- ✅ Time-boxed delivery
- ✅ Clear specifications

**Example Session**:
```
User: "Add user profile editing"

AI (implementation): "Building user profile edit feature.

Step 1: Form component
[Creates ProfileEditForm.tsx]
✅ src/components/profile/ProfileEditForm.tsx

Step 2: Validation
[Creates Zod schema]
✅ src/lib/validations/profile.ts

Step 3: API endpoint
[Creates PATCH /api/user/profile]
✅ src/app/api/user/profile/route.ts

Step 4: Tests
[Creates test suite]
✅ All tests passing

Feature complete.

Next: Integrate into settings page?"
```

---

## How to Use Profiles

### Method 1: Persistent (Project-Level)

Set in `CLAUDE.md` for all sessions:

```yaml
# CLAUDE.md (around line 41)
behavior_profile: "focus"  # Will apply to every session
```

**Save file and restart Claude Code** to activate.

---

### Method 2: Temporary (Session-Level)

*(v2.2 feature - coming soon)*

Override for single session:
```bash
MCB_PROFILE=research  # Environment variable
```

---

### Switching Profiles

1. **Edit** `CLAUDE.md`
2. **Change** `behavior_profile:` value
3. **Save** file
4. **Restart** Claude Code

**Verification**:
Session status will show active profile:
```
🎭 Profile: focus
```

---

## Profile Comparison

### Quick Reference Table

| Feature | default | focus | research | implementation |
|---------|---------|-------|----------|----------------|
| **Token Cost** | 200 | 150 | 300 | 200 |
| **Response Length** | ~150 words | ~50 words | ~300 words | ~150 words |
| **Suggestions** | 2-5/session | 0-1/session | 5-10/session | 3-6/session |
| **Explanations** | Standard | Minimal | Detailed | Brief |
| **Best For** | General dev | Deep focus | Learning | Feature building |
| **Speed** | Balanced | Fastest | Slowest | Fast |
| **Learning** | Medium | Low | High | Medium |

---

### Decision Matrix

**Choose default when**:
- ✅ Not sure which profile to use
- ✅ Switching between different task types
- ✅ General full-stack development
- ✅ Want balanced behavior

**Choose focus when**:
- ✅ Need deep concentration
- ✅ Time-sensitive deadline
- ✅ Complex debugging session
- ✅ Want minimal output

**Choose research when**:
- ✅ Understanding new codebase
- ✅ Learning new patterns
- ✅ Creating documentation
- ✅ Need detailed explanations

**Choose implementation when**:
- ✅ Building features fast
- ✅ Sprint/MVP development
- ✅ Have clear specifications
- ✅ Want step-by-step execution

---

## Creating Custom Profiles

### Step 1: Copy Template

```bash
cp .claude/profiles/custom-template.md .claude/profiles/my-profile.md
```

### Step 2: Configure Settings

Edit `my-profile.md`:

```yaml
## Core Settings
output_style: terse              # terse, balanced, verbose
proactivity: low                 # low, medium, high
explanation_depth: minimal       # minimal, standard, detailed
communication: efficient         # efficient, friendly, educational
```

### Step 3: Customize Behaviors

```markdown
## Focus Areas
### Primary
- Backend API development
- Database optimization

## Tool Preferences
### Prefer
- Grep (find code patterns fast)
- Edit (surgical changes)

### Avoid
- Task (stay focused, no exploration)
```

### Step 4: Activate

```yaml
# In CLAUDE.md:
behavior_profile: "my-profile"
```

### Example Custom Profile

**backend-focused.md**:
```yaml
output_style: terse
proactivity: low
explanation_depth: minimal

## Focus Areas
Primary: API development, database queries, performance
Secondary: Testing, error handling

## Tool Preferences
Prefer: Read (check schemas), Edit (update code), Bash (run tests)

## Context Priority
1. systemPatterns.md → Backend patterns
2. productContext.md → Database schema
3. activeContext.md → Current API work
```

---

## Best Practices

### 1. Start with default
Learn the system with balanced behavior before customizing.

### 2. Match profile to task
Switch profiles as your work context changes:
- Morning: research (learn codebase)
- Afternoon: implementation (build features)
- Evening: focus (fix bugs)

### 3. One profile per project
Set in `CLAUDE.md` for consistency across sessions.

### 4. Experiment
Try each profile for a full session to understand differences.

### 5. Create task-specific profiles
Build custom profiles for recurring workflows.

### 6. Monitor with /metrics
Use `/metrics --profile` to see which profiles work best for you.

---

## Troubleshooting

### Profile Not Showing in Session Status

**Problem**: No `🎭 Profile: ...` line in session start

**Causes**:
1. Profile setting missing from `CLAUDE.md`
2. Typo in profile name
3. Profile file doesn't exist

**Solution**:
```bash
# Check CLAUDE.md has this line (around line 41):
behavior_profile: "default"

# Verify profile file exists:
ls .claude/profiles/default.md

# Restart Claude Code
```

---

### Profile Behaving Same as Default

**Problem**: Changed profile but behavior seems identical

**Causes**:
1. Didn't restart Claude Code after change
2. Profile name typo (falls back to default)
3. Cache from previous session

**Solution**:
1. Save `CLAUDE.md`
2. **Close** Claude Code completely
3. **Reopen** in your project
4. Check session status shows correct profile

---

### Custom Profile Not Loading

**Problem**: Created custom profile but shows "default"

**Causes**:
1. File not in `.claude/profiles/` folder
2. Filename doesn't match `behavior_profile:` setting
3. File has `.md` in the setting (shouldn't)

**Solution**:
```yaml
# Wrong:
behavior_profile: "my-profile.md"  # Remove .md

# Correct:
behavior_profile: "my-profile"

# File should be:
.claude/profiles/my-profile.md
```

---

## FAQ

### Q: Can I switch profiles mid-session?
**A**: Not yet. You must restart Claude Code. Session-level override coming in v2.2.

### Q: Does changing profiles lose context?
**A**: No! Context persists. Only behavior changes.

### Q: Which profile uses least tokens?
**A**: `focus` profile (~150 tokens), 25% lighter than default.

### Q: Can I have different profiles per team member?
**A**: Yes! Each person can set their preferred profile in local `CLAUDE.md` (don't commit).

### Q: Do profiles affect code quality?
**A**: No! Profiles change communication style, not coding standards or patterns.

### Q: How do I know which profile I'm using?
**A**: Check session status line: `🎭 Profile: [name]`

### Q: Can I mix behaviors from different profiles?
**A**: Yes! Create a custom profile with mixed settings.

### Q: Are profiles permanent?
**A**: They persist until you change `CLAUDE.md` or override with environment variable.

---

## 📚 Related Documentation

- [Pattern Library Guide](USER-GUIDE-PATTERNS.md) - Behavioral training reference
- [Metrics Guide](USER-GUIDE-METRICS.md) - Track profile effectiveness
- [Custom Profile Template](.claude/profiles/custom-template.md) - Create your own
- [Migration Guide](MIGRATION-V2.1.md) - Upgrade from v2.0

---

## 💡 Tips & Tricks

### Tip 1: Profile Rotation
Use different profiles throughout the day:
```
Morning (9am-12pm):   research  - Understand new features
Afternoon (1pm-5pm):  implementation - Build features
Evening (5pm-7pm):    focus - Fix bugs
```

### Tip 2: Task-Based Switching
Match profile to task type:
- Bug triage: `focus`
- Architecture review: `research`
- Sprint work: `implementation`
- General work: `default`

### Tip 3: Team Profiles
Create team-wide profiles for consistency:
- `backend-team.md`
- `frontend-team.md`
- `devops-team.md`

Share via git, team members activate locally.

### Tip 4: Metrics-Driven Selection
After a few weeks, run:
```
/metrics --profile
```

See which profiles lead to best outcomes for you!

---

**Enjoy customizable AI behavior!** 🎭

Need help? Open an issue: [GitHub Issues](https://github.com/kunwar-shah/mini-coder-brain/issues)
