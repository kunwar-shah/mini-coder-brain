# Behavior Profiles System

**Purpose**: Customizable AI behavior modes for different development contexts

**Token Cost**: +~200 tokens (single profile loaded at session start)

---

## 🎯 What Are Behavior Profiles?

Behavior profiles define **how the AI should act** in different contexts:

- **Focus areas** (frontend, backend, devops, research)
- **Communication style** (terse, detailed, explanatory)
- **Proactivity level** (hands-off, balanced, assertive)
- **Tool preferences** (which tools to prioritize)
- **Context emphasis** (which memory files to prioritize)

---

## 📁 Available Profiles

### default.md (Default)
Standard Mini-CoderBrain behavior - balanced, context-aware, proactive

**Best for**: General development, full-stack work, learning projects

### focus.md
Deep focus mode - minimal output, maximum efficiency

**Best for**: Implementing features, fixing bugs, production work

### research.md
Exploration mode - detailed explanations, proactive learning

**Best for**: Understanding codebase, learning patterns, documentation

### implementation.md
Build mode - action-oriented, fast execution, minimal questions

**Best for**: Rapid feature development, prototyping, iteration

---

## 🔧 How Profiles Work

### 1. Profile Selection
Profiles are specified in `CLAUDE.md` or via environment variable:

```yaml
# In CLAUDE.md Project Setup Metadata
behavior_profile: "default"  # or "focus", "research", "implementation"
```

Or via temporary override:
```bash
# In .claude/.env (session-specific)
MCB_PROFILE=focus
```

### 2. Profile Loading
Profile is loaded ONCE at session start by session-start hook:

```
Session Start:
├── Load memory files (productContext, activeContext, etc.)
├── Detect active profile (from CLAUDE.md or .env)
├── Load profile configuration (single file, ~200 tokens)
└── Apply profile behaviors throughout session
```

### 3. Profile Behaviors
Profile modifies these aspects:

**Output Style**:
- `verbose`: Detailed explanations
- `balanced`: Standard output (default)
- `terse`: Minimal output, action-focused

**Proactivity Level**:
- `low`: Only suggest when asked
- `medium`: Suggest at milestones (default)
- `high`: Proactive suggestions and improvements

**Context Priority**:
- Which memory files to check first
- Which patterns to emphasize
- Tool selection preferences

**Communication**:
- Status updates frequency
- Explanation depth
- Question threshold

---

## 🎨 Profile Format

Each profile is a markdown file with structured sections:

```markdown
# Profile Name

## Core Settings
- output_style: verbose|balanced|terse
- proactivity: low|medium|high
- explanation_depth: minimal|standard|detailed

## Focus Areas
- Primary: [main focus]
- Secondary: [supporting areas]

## Context Priority
1. [First memory file to check]
2. [Second memory file to check]
...

## Tool Preferences
- Prefer: [tools to prioritize]
- Avoid: [tools to use sparingly]

## Behavioral Adjustments
- [Specific behavior modifications]
```

---

## 🚀 Using Profiles

### Default Behavior (No Profile Set)
If no profile specified, `default.md` is used automatically.

### Setting a Profile
In `CLAUDE.md`:
```yaml
# Project Setup Metadata
behavior_profile: "focus"  # Change to desired profile
```

### Temporary Override
For single session:
```bash
echo "MCB_PROFILE=research" > .claude/.env
# Profile applied for this session only
```

### Custom Profiles
Create your own in `.claude/profiles/custom-name.md`:
```markdown
# Custom Profile

## Core Settings
- output_style: terse
- proactivity: low
- explanation_depth: minimal

## Focus Areas
- Primary: Backend API development
- Secondary: Database optimization

... [continue with format]
```

Then reference in CLAUDE.md:
```yaml
behavior_profile: "custom-name"
```

---

## 📊 Token Impact

**Profile Loading** (~200 tokens):
- Profile file read at session start: ~200 tokens
- No re-loading during session
- Replaces previous inline behavior rules

**Net Impact**: +200 tokens (once per session, minimal impact)

**Compared to Context Injection**: 79.9% more efficient than re-loading context

---

## 🎯 Profile Selection Guide

### Choose "default" when:
- General full-stack development
- Learning new project
- Balanced work (features + bugs + docs)
- Unsure which profile to use

### Choose "focus" when:
- Need to concentrate deeply
- Working on complex implementation
- Time-sensitive delivery
- Want minimal distractions

### Choose "research" when:
- Understanding new codebase
- Learning project patterns
- Reading documentation
- Exploring architecture

### Choose "implementation" when:
- Rapid feature development
- Prototyping new ideas
- Iterating quickly
- Implementing well-defined specs

---

## 🔄 Profile Development

### Creating a New Profile

1. Copy `custom-template.md` to `.claude/profiles/my-profile.md`
2. Edit sections to match desired behavior
3. Test in development session
4. Refine based on experience
5. Share with community (optional)

### Contributing Profiles

New profiles welcomed! Create PR with:
- Profile file (`.claude/profiles/name.md`)
- Use case description
- Example scenarios
- Testing notes

---

## 📚 Examples

### Example 1: Backend Developer
```yaml
behavior_profile: "backend-developer"
```

Profile emphasizes:
- Database patterns
- API design
- Performance optimization
- Backend-specific tools

### Example 2: DevOps Engineer
```yaml
behavior_profile: "devops-engineer"
```

Profile emphasizes:
- Infrastructure patterns
- Deployment automation
- Monitoring and logging
- Docker/K8s operations

---

## 🎓 Best Practices

1. **Start with default**: Learn the system before customizing
2. **One profile per project**: Set in CLAUDE.md for consistency
3. **Temporary overrides**: Use .env for experimentation
4. **Custom profiles**: Create when defaults don't fit
5. **Share learnings**: Contribute successful profiles back

---

**Profiles Available**: 4 built-in + unlimited custom
**Token Cost**: +200 tokens per session (minimal)
**Customization**: Full control via markdown files
**Compatibility**: Works with all Mini-CoderBrain features
