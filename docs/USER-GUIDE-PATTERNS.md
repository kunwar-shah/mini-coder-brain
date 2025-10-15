# User Guide: Behavioral Patterns Library

**Version**: 2.1.0
**Feature**: Reference-Based Behavioral Training
**Token Cost**: 0 (patterns read on-demand, never injected)

---

## 📋 Table of Contents

1. [What Are Behavioral Patterns?](#what-are-behavioral-patterns)
2. [Available Patterns](#available-patterns)
3. [How Patterns Work](#how-patterns-work)
4. [When to Read Patterns](#when-to-read-patterns)
5. [Pattern Descriptions](#pattern-descriptions)
6. [Patterns vs Profiles](#patterns-vs-profiles)
7. [Advanced Usage](#advanced-usage)
8. [FAQ](#faq)

---

## What Are Behavioral Patterns?

Behavioral patterns are **reference documents** that define how Claude should behave throughout your project.

### Think of patterns like:
- **Style guides** for behavior (not just code)
- **Playbooks** for common scenarios
- **Decision trees** for tool selection
- **Anti-pattern lists** to avoid mistakes

### Key Difference from Profiles

| Feature | Patterns | Profiles |
|---------|----------|----------|
| **What** | Rules for behavior | How to apply rules |
| **When** | Read when needed | Loaded at session start |
| **Cost** | 0 tokens | ~200 tokens |
| **Type** | Reference material | Active configuration |

**Analogy**:
- **Patterns** = Driving manual (read when you need to)
- **Profiles** = Driving mode (Sport, Comfort, Eco)

---

## Available Patterns

### 5 Core Patterns (4,700 lines total)

1. **pre-response-protocol.md** (~850 lines)
   - MANDATORY 5-step checklist before every response
   - What to check, in what order, why
   - Banned questions list
   - Zero assumption rule

2. **context-utilization.md** (~750 lines)
   - How to use memory bank files effectively
   - When to check each file
   - Load-once principle
   - 79.8% token reduction strategy

3. **proactive-behavior.md** (~800 lines)
   - When to make suggestions
   - When NOT to suggest
   - Good vs annoying suggestions
   - Milestone detection

4. **anti-patterns.md** (~1200 lines)
   - What NOT to do
   - Context duplication (banned)
   - Asking questions context answers (banned)
   - Security anti-patterns
   - Error handling mistakes

5. **tool-selection-rules.md** (~1100 lines)
   - Which tool for which task
   - Read vs Glob vs Grep
   - Edit vs Write
   - Bash vs specialized tools
   - Decision trees

---

## How Patterns Work

### Load-Once Principle

```
Session Start:
├── Memory files loaded (5 files)
├── Profile loaded (1 file)
└── Patterns NOT loaded (read on-demand)

During Session:
├── AI works normally
├── When guidance needed → Read specific pattern
├── Apply pattern rules
└── Continue working

Pattern reads are:
- On-demand (only when needed)
- Cached in conversation history
- Zero token cost (not injected into every prompt)
```

### Why Zero Token Cost?

**Traditional Approach** (❌ Wasteful):
```
Every prompt: Inject all 4,700 lines of patterns
Result: Massive token waste, short conversations
```

**Mini-CoderBrain Approach** (✅ Efficient):
```
Prompt 1: No patterns (not needed yet)
Prompt 5: Need tool guidance → Read tool-selection-rules.md
Prompt 10: No patterns (already know from Prompt 5)
Result: Read only when needed, 79.8% token efficiency
```

---

## When to Read Patterns

### AI Automatically Reads When:

1. **Stuck on decision** → Reads relevant pattern
2. **Unsure which tool** → Reads tool-selection-rules.md
3. **About to suggest** → Reads proactive-behavior.md
4. **Checking context** → Reads context-utilization.md

### You Can Read Manually For:

1. **Understanding behavior** → Read any pattern to see why AI acts certain way
2. **Customizing** → Read patterns to inform custom profile creation
3. **Troubleshooting** → Read anti-patterns.md to see common mistakes
4. **Learning** → Understand Mini-CoderBrain methodology

---

## Pattern Descriptions

### 1. pre-response-protocol.md

**Purpose**: MANDATORY checklist Claude must complete before every response

**Key Content**:

#### 5-Step Checklist
```
Before responding to ANY request:
1. ✅ CHECK productContext.md → Tech stack, architecture
2. ✅ CHECK systemPatterns.md → Coding conventions
3. ✅ CHECK activeContext.md → Current focus
4. ✅ CHECK project-structure.json → File locations
5. ✅ CHECK codebase-map.json → Specific files (if exists)
```

#### Banned Questions
```
❌ "What framework are you using?"
   → Should check productContext.md first

❌ "Where is the User model?"
   → Should check codebase-map.json first

❌ "What's your coding style?"
   → Should check systemPatterns.md first
```

#### Zero Assumption Rule
```
If context has answer → USE IT immediately
If unsure → SEARCH conversation history
Only ask when genuinely missing information
```

**Example Application**:
```
User: "Add authentication"

Bad (no protocol):
AI: "What authentication method do you want? JWT? OAuth? Sessions?"

Good (follows protocol):
AI: [Checks productContext.md → sees "Next.js 14 + Prisma"]
    [Checks systemPatterns.md → sees "Uses Zod validation"]
    [Implements Next.js auth with JWT + Zod, no questions asked]
```

**Read this when**: Understanding why Claude doesn't ask basic questions

---

### 2. context-utilization.md

**Purpose**: How to use memory bank files without duplication

**Key Content**:

#### Memory Bank Files
```
productContext.md → Project overview, tech stack
systemPatterns.md → Coding conventions, patterns
activeContext.md → Current focus, recent work
progress.md → Sprint tracking, tasks
decisionLog.md → Technical decisions (ADRs)
project-structure.json → Detected file paths
codebase-map.json → Semantic file mapping
```

#### Load-Once Principle
```
Session Start (Turn 1):
├── Load all memory files once
├── Context enters conversation history
└── Available for entire session

Subsequent Turns (Turn 2+):
├── Context already in history
├── NO re-reading needed
└── 79.8% token reduction achieved
```

#### Critical Rule
```
NEVER re-read memory files unless:
- User explicitly updated a file
- Need to verify current content
- Genuinely unsure about content
```

**Example Application**:
```
Turn 1: Load productContext.md (600 lines)
Turn 2: Use from conversation history (0 lines)
Turn 50: Use from conversation history (0 lines)

WITHOUT load-once: 600 × 50 = 30,000 lines waste
WITH load-once: 600 lines total (79.8% reduction)
```

**Read this when**: Understanding token efficiency strategy

---

### 3. proactive-behavior.md

**Purpose**: When/how to make helpful suggestions

**Key Content**:

#### Good Times to Suggest
```
✅ After completing tasks
   "Authentication complete. Should I add tests?"

✅ Detecting patterns
   "Found 5 TODOs in auth module. Should I address them?"

✅ Before major operations
   "About to modify database schema. Want to backup first?"

✅ At milestones
   "Completed 50 operations. Consider: /update-memory-bank"
```

#### Bad Times to Suggest
```
❌ After EVERY single action
   "Created file. Should I commit? Should I test? Should I document?"

❌ Mid-task interruptions
   User is clearly focused, don't interrupt flow

❌ Over-explaining obvious things
   "I used Edit tool because the file exists..."
```

#### Suggestion Format
```
✅ Good: "Tests?"
   (Terse, clear, question form)

❌ Bad: "Would you like me to add unit tests, integration tests,
         end-to-end tests, documentation, and examples?"
   (Too verbose, too many options)
```

**Example Application**:
```
focus profile: Reads this → Suggests 0-1 times per session
default profile: Reads this → Suggests 2-5 times per session
research profile: Reads this → Suggests 5-10 times per session
```

**Read this when**: Understanding suggestion frequency and style

---

### 4. anti-patterns.md

**Purpose**: What NOT to do (1200 lines of examples)

**Key Sections**:

#### Context Duplication (BANNED)
```
❌ Re-reading memory files every turn
❌ Asking questions context already answers
❌ Injecting context into every prompt
```

#### Verbose Output (BANNED)
```
❌ Multi-paragraph session start
   MAX 4-5 lines allowed

❌ Explaining obvious things
   Just do the task, don't narrate
```

#### Over-Engineering (BANNED)
```
❌ Suggesting features user didn't ask for
   "Should I also add OAuth, 2FA, SAML, LDAP...?"

❌ Perfect-world solutions for simple tasks
   "I'll design a comprehensive configuration management system..."
   (User just wanted to store a preference)
```

#### Security Anti-Patterns
```
❌ Storing secrets in code
   const API_KEY = 'sk_live_abc123'

✅ Use environment variables
   const API_KEY = process.env.API_KEY
```

#### Error Handling Anti-Patterns
```
❌ Silent failures
   catch (error) { /* empty */ }

✅ Log and handle
   catch (error) {
     logger.error('Payment failed', { error })
     throw new PaymentError('Unable to process', { cause: error })
   }
```

**Read this when**:
- Troubleshooting unexpected behavior
- Understanding what behaviors are prevented
- Creating custom profiles (know what to avoid)

---

### 5. tool-selection-rules.md

**Purpose**: Which tool to use for each task

**Key Decision Trees**:

#### Finding Files
```
Do you know exact path?
├─ YES → Read
└─ NO → Do you know filename?
    ├─ YES → Glob (pattern="**/filename.ts")
    └─ NO → Do you know what's inside?
        ├─ YES → Grep (search for code pattern)
        └─ NO → Task (complex exploration)
```

#### Modifying Code
```
Does file exist?
├─ NO → Write (create new file)
└─ YES → Have you read it this session?
    ├─ NO → Read first, then Edit
    └─ YES → Edit directly
```

#### Running Commands
```
What type of command?
├─ Git/npm/docker → Bash
├─ Read file → Read tool (NOT cat)
├─ Search files → Grep tool (NOT grep command)
└─ Find files → Glob tool (NOT find)
```

**Tool Preference Matrix**:
```
| Task | First Choice | Fallback | Never Use |
|------|-------------|----------|-----------|
| Read known file | Read | - | cat, head |
| Find file | Glob | Task | find, ls |
| Search code | Grep | Task | grep, rg |
| Create file | Write | - | echo >, cat <<EOF |
| Modify file | Edit | Read+Write | sed, awk |
```

**Example Application**:
```
User: "Find the User model"

Bad (wrong tool):
AI: [Uses Bash: find . -name "*User*"]

Good (right tool):
AI: [Uses Glob: pattern="**/User.{ts,js,py}"]
    Found: src/models/User.ts
```

**Read this when**: Understanding why Claude chooses specific tools

---

## Patterns vs Profiles

### How They Work Together

**Patterns** (Universal Rules):
```
"Always check context before responding"
"Use Read for known paths, Glob for finding files"
"Suggest after completing tasks, not during"
```

**Profiles** (Apply Rules Differently):
```
default: Check all 5 context files, suggest 2-5 times
focus: Check only essential context, suggest 0-1 times
research: Check all 6 context files, suggest 5-10 times
```

### Example: Proactive Suggestions

**Pattern Says**: "Suggest after completing tasks"

**Profiles Apply**:
- **focus**: Suggests 0-1 times (reads pattern, applies minimally)
- **default**: Suggests 2-5 times (reads pattern, applies balanced)
- **research**: Suggests 5-10 times (reads pattern, applies maximally)

**Result**: Same pattern, different intensity per profile!

---

## Advanced Usage

### Reading Patterns Manually

**Access patterns anytime**:
```bash
# In Claude Code, reference pattern:
"Please review @.claude/patterns/tool-selection-rules.md"

# Claude will read and discuss the pattern
```

### Using Patterns for Custom Profiles

**Create informed custom profiles**:
```bash
# Read patterns to understand rules
cat .claude/patterns/proactive-behavior.md

# Create custom profile applying rules your way
cp .claude/profiles/custom-template.md .claude/profiles/my-profile.md

# Configure based on pattern understanding
```

### Contributing Pattern Improvements

**Found a better way?**
1. Document your approach
2. Test in real sessions
3. Submit as pattern improvement
4. Help community benefit

---

## FAQ

### Q: Do I need to read patterns to use Mini-CoderBrain?
**A**: No! Claude reads them automatically. You only read if curious about behavior.

### Q: Can I modify patterns?
**A**: Yes! Patterns are markdown files. Edit to customize behavior.

### Q: Will editing patterns break things?
**A**: No, but test changes. Patterns guide behavior, so changes affect Claude's actions.

### Q: Why not inject patterns into every prompt?
**A**: Would waste ~4,700 tokens per prompt. On-demand reading saves 79.8% tokens.

### Q: How do I know if Claude followed a pattern?
**A**: Watch behavior. E.g., if Claude checks context without asking, following pre-response-protocol.

### Q: Can I create new patterns?
**A**: Yes! Add markdown file to `.claude/patterns/`, reference in CLAUDE.md.

### Q: Do patterns work with all profiles?
**A**: Yes! All profiles reference the same patterns, apply them differently.

### Q: Are patterns loaded at session start?
**A**: No! That's the point. Read on-demand only = zero token cost.

---

## 🎯 Key Takeaways

1. **Patterns are reference material**, not active configuration
2. **Zero token cost** because read on-demand, never injected
3. **4,700 lines of behavioral guidance** available when needed
4. **Profiles reference patterns** to know how to behave
5. **You rarely need to read them** - Claude handles it automatically
6. **Read patterns to understand** why Claude behaves certain way
7. **Modify patterns to customize** behavior system-wide
8. **Patterns + Profiles = Flexible AI** with consistent rules

---

## 📚 Related Documentation

- [Behavior Profiles Guide](USER-GUIDE-PROFILES.md) - How profiles work
- [Metrics Guide](USER-GUIDE-METRICS.md) - Track behavioral effectiveness
- [Migration Guide](MIGRATION-V2.1.md) - Upgrade from v2.0
- [Anti-Patterns Full Text](.claude/patterns/anti-patterns.md) - Complete list

---

## 💡 Pro Tips

### Tip 1: Read Anti-Patterns First
Fastest way to understand Mini-CoderBrain: read what NOT to do.

### Tip 2: Reference Patterns in Conversations
```
"Please follow the tool-selection-rules pattern strictly"
"Review anti-patterns before suggesting"
```

### Tip 3: Create Pattern-Based Prompts
```
"Using pre-response-protocol, evaluate this codebase"
"Apply proactive-behavior pattern to suggest next steps"
```

### Tip 4: Pattern-Driven Custom Profiles
Best custom profiles come from deep pattern understanding.

---

**Patterns enable data-driven behavioral intelligence!** 📚

Need help? Open an issue: [GitHub Issues](https://github.com/kunwar-shah/mini-coder-brain/issues)
