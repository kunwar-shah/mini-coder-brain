---
description: Validate memory bank context quality and completeness
argument-hint: "[--fix]"
allowed-tools: Read(*), Write(*), Edit(*), Bash(wc:*)
---

# Validate Context — Quality Check & Validation

Check the quality and completeness of your mini-coder-brain memory bank. Ensures you have minimum required context for 100% effectiveness.

## Purpose

Validates that `.claude/memory/` files contain sufficient, high-quality context:
- **productContext.md** - Project overview, tech stack, features
- **systemPatterns.md** - Coding conventions, patterns
- **activeContext.md** - Current focus, recent work
- **progress.md** - Development progress tracking
- **decisionLog.md** - Technical decisions
- **project-structure.json** - Auto-detected structure

## Usage

```bash
# Check context quality
/validate-context

# Check and offer to fix issues
/validate-context --fix
```

## Execution Steps

### STEP 1: Read All Memory Files

Read and analyze:
- `.claude/memory/productContext.md`
- `.claude/memory/systemPatterns.md`
- `.claude/memory/activeContext.md`
- `.claude/memory/progress.md`
- `.claude/memory/decisionLog.md`
- `.claude/memory/project-structure.json` (if exists)

### STEP 2: Validate Each File

#### productContext.md Validation

**Critical Requirements** (must have):
- ✅ Project name is NOT `[PROJECT_NAME]` or empty
- ✅ Project type is defined (not `[AUTO_DETECTED]`)
- ✅ At least 2 core features listed
- ✅ Technology stack has 3+ items
- ✅ Project overview has actual content (>20 words)

**Recommended** (should have):
- ✅ Architecture description
- ✅ Development goals
- ✅ Success metrics

**Scoring**:
```
Project name: 10 points
Description (>20 words): 10 points
Tech stack (3+ items): 15 points
Core features (2+ items): 15 points
Architecture: 10 points
Development goals: 5 points
Success metrics: 5 points
```

#### systemPatterns.md Validation

**Critical Requirements**:
- ✅ At least 1 architectural principle
- ✅ File organization pattern defined
- ✅ Technology stack mentioned

**Recommended**:
- ✅ Testing patterns
- ✅ Error handling approach
- ✅ Code style guidelines

**Scoring**:
```
Architectural principles: 10 points
File organization: 5 points
Tech stack: 5 points
Testing patterns: 5 points
Error handling: 5 points
```

#### activeContext.md Validation

**Critical Requirements**:
- ✅ Current focus is defined (not placeholder)
- ✅ Has actual content (>10 words)

**Recommended**:
- ✅ Recent achievements listed
- ✅ Next priorities defined
- ✅ Blockers identified (even if "none")

**Scoring**:
```
Current focus: 10 points
Recent achievements: 5 points
Next priorities: 5 points
Blockers section: 5 points
```

#### progress.md Validation

**Critical Requirements**:
- ✅ Has sections for COMPLETED/IN PROGRESS/PENDING
- ✅ Current phase defined (not placeholder)

**Recommended**:
- ✅ At least 1 completed task
- ✅ Current sprint info
- ✅ Velocity tracking

**Scoring**:
```
Has sections: 10 points
Current phase: 5 points
Completed tasks: 5 points
Sprint info: 5 points
```

#### decisionLog.md Validation

**Optional** (new projects may be empty):
- No strict requirements
- Bonus points if has >1 decision entry

**Scoring**:
```
Has 1+ decision: 5 points (bonus)
```

#### project-structure.json Validation

**Recommended**:
- ✅ File exists and is valid JSON
- ✅ Has detected structure paths

**Scoring**:
```
File exists: 5 points
Valid JSON: 5 points
```

### STEP 3: Calculate Overall Quality Score

**Total Possible**: 150 points

**Quality Levels**:
- 🔴 **Below Minimum** (< 60 points / 40%): Critical issues, won't work effectively
- 🟡 **Minimum** (60-90 points / 40-60%): Works but limited effectiveness
- 🟢 **Recommended** (90-120 points / 60-80%): Good effectiveness
- 🌟 **Optimal** (120-150 points / 80-100%): Excellent effectiveness

### STEP 4: Display Results

```
🔍 Context Quality Validation Report

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Overall Score: 105/150 (70%) - RECOMMENDED ✅

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 productContext.md: 55/70 points (79%)
   ✅ Project name: my-awesome-app
   ✅ Tech stack: 5 technologies detected
   ✅ Core features: 4 features listed
   ✅ Project overview: Complete
   ⚠️  Architecture: Missing or placeholder
   ⚠️  Development goals: Not defined

📄 systemPatterns.md: 25/30 points (83%)
   ✅ Architectural principles: Defined
   ✅ File organization: Clear
   ✅ Testing patterns: Present
   ⚠️  Error handling: Generic

📄 activeContext.md: 20/25 points (80%)
   ✅ Current focus: Defined
   ✅ Recent achievements: Listed
   ✅ Next priorities: Clear
   ✅ Blockers: None currently

📄 progress.md: 20/25 points (80%)
   ✅ Has proper sections
   ✅ Current phase defined
   ✅ Completed tasks tracked
   ⚠️  Velocity tracking: Missing

📄 decisionLog.md: 5/5 points (BONUS)
   ✅ Has 3 technical decisions recorded

📄 project-structure.json: 0/10 points
   ❌ File not found
   → Run /init-memory-bank to auto-generate

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 Recommendations:

HIGH PRIORITY:
  • Add project architecture description to productContext.md
  • Define development goals in productContext.md
  • Generate project-structure.json (run /init-memory-bank)

MEDIUM PRIORITY:
  • Enhance error handling patterns in systemPatterns.md
  • Add velocity tracking to progress.md

OPTIONAL:
  • Add more technical decisions as you make them

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 Next Steps:
   1. Address HIGH PRIORITY items first
   2. Run /validate-context again after fixes
   3. Aim for 80%+ score for optimal effectiveness

✅ Your context is good enough to work with, but improvements
   will enhance Mini-CoderBrain's effectiveness!
```

### STEP 5: --fix Mode (Optional)

If `--fix` flag provided:

For each identified issue, offer to fix:

```
Would you like me to help fix these issues? (yes/no)
→ [wait for user response]

If yes:

1. Missing architecture:
   "What is your project's architecture? (e.g., 'Monolithic REST API', 'Microservices with event bus')"
   → [collect user input and update productContext.md]

2. Missing development goals:
   "What are your development goals? (e.g., 'MVP in 2 months', 'Production-ready by Q2')"
   → [collect user input and update productContext.md]

3. Missing project-structure.json:
   "Should I auto-generate project structure? (yes/no)"
   → [if yes, scan and create project-structure.json]

After fixes:
"✅ Context updated! Run /validate-context again to verify improvements."
```

## Validation Logic (Internal Reference)

```typescript
// Pseudo-code for validation logic

function validateProductContext(content: string): ValidationResult {
  const score = 0;
  const issues = [];

  // Check project name
  if (!content.includes('[PROJECT_NAME]') && content.match(/# Product Context — (.+)/)) {
    score += 10;
  } else {
    issues.push('Project name is placeholder or missing');
  }

  // Check description
  const descriptionWords = extractSection(content, 'Project Overview').split(' ').length;
  if (descriptionWords > 20) {
    score += 10;
  } else {
    issues.push('Project description too short or missing');
  }

  // Check tech stack
  const techStackItems = extractList(content, 'Technology Stack').length;
  if (techStackItems >= 3) {
    score += 15;
  } else {
    issues.push(`Tech stack incomplete (${techStackItems}/3 items)`);
  }

  // Check core features
  const features = extractList(content, 'Core Features').length;
  if (features >= 2) {
    score += 15;
  } else {
    issues.push(`Core features incomplete (${features}/2 required)`);
  }

  // Check architecture
  if (content.includes('Architecture') && !content.includes('[ARCHITECTURE]')) {
    score += 10;
  } else {
    issues.push('Architecture description missing');
  }

  return { score, maxScore: 70, issues };
}
```

## Output Modes

### Mode 1: Pass (80%+ score)
```
✅ Context Quality: OPTIMAL (85%)
   Your mini-coder-brain is ready for 100% effectiveness!
```

### Mode 2: Warning (60-80% score)
```
⚠️  Context Quality: RECOMMENDED (70%)
   Mini-CoderBrain will work, but consider improvements for better results.
```

### Mode 3: Fail (< 60% score)
```
🔴 Context Quality: BELOW MINIMUM (45%)
   CRITICAL: Mini-CoderBrain won't work effectively.
   Run: /init-memory-bank or /validate-context --fix
```

## Use Cases

### Use Case 1: After Installation
```
User: /validate-context

[Shows validation report]

If score < 60%:
  → "Run /init-memory-bank to properly initialize your context"
```

### Use Case 2: Debugging "Claude Doesn't Know My Stack"
```
User: "Why does Claude keep asking what framework I'm using?"