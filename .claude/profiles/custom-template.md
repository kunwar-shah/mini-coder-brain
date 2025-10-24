# Custom Profile Template

**Name**: [Your Profile Name]
**Best For**: [When to use this profile]
**Token Cost**: ~[Estimate: 150-300] tokens

---

## Core Settings

```yaml
output_style: [verbose|balanced|terse]       # How detailed should responses be?
proactivity: [low|medium|high]               # How often to suggest things?
explanation_depth: [minimal|standard|detailed] # How much to explain WHY?
communication: [efficient|friendly|educational] # What tone to use?
```

**Settings Guide**:
- **output_style**:
  - `verbose`: Detailed explanations (research mode)
  - `balanced`: Standard detail (default mode)
  - `terse`: Minimal output (focus mode)

- **proactivity**:
  - `low`: Only suggest when critical
  - `medium`: Suggest at milestones
  - `high`: Frequently suggest improvements

- **explanation_depth**:
  - `minimal`: Just tell me what you did
  - `standard`: Brief explanation of decisions
  - `detailed`: Explain WHY and alternatives

- **communication**:
  - `efficient`: Direct, no fluff
  - `friendly`: Conversational, approachable
  - `educational`: Teaching-oriented

---

## Focus Areas

### Primary
- [Main area of focus - what this profile optimizes for]
- [Second priority]
- [Third priority]

### Secondary
- [Nice to have - will do if time/context allows]
- [Lower priority concerns]

**Examples**:
- Primary: Backend API development, Database optimization
- Secondary: Frontend integration, Documentation

---

## Context Priority

**Check order** (pre-response protocol):
1. **[first file]** → [Why check this first?]
2. **[second file]** → [Why check this second?]
3. **[third file]** → [Why check this third?]
4. **[fourth file]** → [Why check this fourth?]
5. **[fifth file]** → [Why check this last / or SKIP if not needed]

**Why this order**: [Explain your reasoning for this priority]

**Available Memory Files**:
- activeContext.md → Current focus, recent work, blockers
- productContext.md → Project overview, tech stack, architecture
- systemPatterns.md → Coding conventions, patterns, standards
- project-structure.json → File locations and structure
- progress.md → Sprint tracking, completed/in-progress tasks
- decisionLog.md → Technical decisions and rationale
- codebase-map.json → Semantic file mapping (if exists)

---

## Tool Preferences

### Prefer
- **[Tool 1]** ([Why prefer this?])
- **[Tool 2]** ([Why prefer this?])
- **[Tool 3]** ([Why prefer this?])

### Use Sparingly
- **[Tool 4]** ([Why avoid or use rarely?])
- **[Tool 5]** ([Why avoid or use rarely?])

### Never Use (In This Profile)
- **[Tool 6]** ([Why never use in this context?])

**Available Tools**:
- Read → Read files (use when you know exact path)
- Edit → Modify existing files (prefer over Write)
- Write → Create new files
- Glob → Find files by pattern
- Grep → Search code patterns
- Task → Complex multi-step research
- Bash → Git, npm, docker, system commands
- WebSearch → Find information online
- WebFetch → Read documentation from URL
- TodoWrite → Track multi-step tasks

---

## Behavioral Adjustments

### Pre-Response Protocol
✅ [DESCRIBE YOUR CHECKLIST APPROACH]:
1. [What to check first and why]
2. [What to check second and why]
3. [What to skip or check last]

**Your customizations**:
- [How does this profile modify the standard 5-step checklist?]
- [What can you skip for speed?]
- [What do you need to emphasize?]

### Communication Style

**[DESCRIBE PREFERRED STYLE]**:
```
Session Start:
[Your preferred session start format - keep it short!]
```

**During Work**:
```
User: "[Example request]"
AI: [Your preferred response style - show with example]
```

**Status Footer**:
```
[Your preferred status footer format]
```

### Proactive Behavior

**[WHEN TO SUGGEST]**:
- [Circumstance 1]: [Suggestion example]
- [Circumstance 2]: [Suggestion example]
- [Circumstance 3]: [Suggestion example]

**[WHEN NOT TO SUGGEST]**:
- [Avoid suggesting during X]
- [Don't suggest Y type of things]

**Suggestion Format** ([terse/balanced/detailed]):
```
✅ Good: [Example of good suggestion in your style]
❌ Bad: [Example of bad suggestion to avoid]
```

### Context Utilization

**[YOUR CONTEXT STRATEGY]**:
- [How aggressively to use context memory?]
- [Which files to prioritize?]
- [When to re-read vs trust conversation history?]

**[YOUR QUESTION PHILOSOPHY]**:
- [What questions are OK in this profile?]
- [What questions should be banned?]
- [When to infer vs ask?]

### Error Handling
- [How to handle errors in this profile?]
- [Verbose or terse error messages?]
- [Fix immediately or report first?]

### Testing Standards
- [When to write tests?]
- [How much test coverage?]
- [Unit vs integration focus?]

### Git Practices
- [Commit frequency?]
- [Commit message style?]
- [When to push?]

---

## Pattern References

**[HOW TO USE PATTERNS IN THIS PROFILE]**:
- [Which patterns to read frequently?]
- [Which patterns to skip?]
- [Read proactively or only when stuck?]

Available patterns:
- @.claude/patterns/pre-response-protocol.md → Mandatory checklist
- @.claude/patterns/context-utilization.md → Memory bank usage
- @.claude/patterns/proactive-behavior.md → When to suggest
- @.claude/patterns/anti-patterns.md → What NOT to do
- @.claude/patterns/tool-selection-rules.md → Which tool when

---

## [Your Profile Name] Rules

### DO
✅ [Rule 1 - What to do in this profile]
✅ [Rule 2]
✅ [Rule 3]
✅ [Rule 4]
✅ [Rule 5]

### DON'T
❌ [Anti-pattern 1 - What NOT to do]
❌ [Anti-pattern 2]
❌ [Anti-pattern 3]
❌ [Anti-pattern 4]
❌ [Anti-pattern 5]

---

## Example Session Flow

### Session Start ([X] lines)
```
[Show exactly what session start should look like]
```

### During Work ([Your style])
```
User: "[Example request]"
AI: [Show your preferred response format]
```

### Proactive Suggestion ([When appropriate])
```
[After X circumstance]
AI: "[Example suggestion in your style]"
```

### Session End
```
[What should happen at session end?]
```

---

## Profile Personality

**Tone**: [Describe overall tone]
**Style**: [Describe communication style]
**Approach**: [Describe working approach]
**Focus**: [Describe primary focus]

**Think of [Your Profile Name] as**:
[Metaphor or analogy - e.g., "A developer in flow state", "An architect reviewing blueprints", etc.]

---

## When to Use [Your Profile Name]

### Use when:
- [Scenario 1 when this profile is perfect]
- [Scenario 2]
- [Scenario 3]
- [Scenario 4]

### Don't use when:
- [Scenario 1 when different profile is better]
- [Scenario 2]
- [Scenario 3]
- [Use X profile instead for Y scenarios]

---

## Token Impact

**[Your profile name] is ~[X]% [lighter/heavier]** than default:
- [Reason 1 for token impact]
- [Reason 2 for token impact]
- [Overall explanation]

**Result**: [What this means for conversation length]

---

## Special Features

### [Unique Feature 1]
[Describe something special this profile does]

### [Unique Feature 2]
[Another unique aspect of this profile]

---

## Tips for Using This Profile

1. **[Tip 1]**: [Advice for using this profile effectively]
2. **[Tip 2]**: [More advice]
3. **[Tip 3]**: [More advice]

---

## Customization Notes

**Created by**: [Your name/handle]
**Date**: [YYYY-MM-DD]
**Version**: 1.0
**Tested with**: [Project types you've tested this profile with]

**Changelog**:
- [YYYY-MM-DD] v1.0 - Initial creation

---

## How to Use This Template

1. Copy this file to `.claude/profiles/your-profile-name.md`
2. Fill in all `[bracketed sections]` with your preferences
3. Delete these instructions section
4. Test your profile in a real session
5. Refine based on experience
6. Share with community if useful!

**Profile Naming**:
- Use kebab-case: `backend-focused.md`, `frontend-specialist.md`
- Be descriptive: `rapid-prototype.md` not `fast.md`
- Avoid conflicts: Check existing profiles first

**Configuration**:
In `CLAUDE.md`, set:
```yaml
behavior_profile: "your-profile-name"  # Without .md extension
```

---

**Need inspiration?** Check out existing profiles:
- `default.md` - Balanced general development
- `focus.md` - Deep focus, minimal output
- `research.md` - Exploration and learning
- `implementation.md` - Rapid feature building
