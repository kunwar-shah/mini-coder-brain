---
description: Validate memory bank context quality and completeness
argument-hint: "[--fix]"
allowed-tools: Read(*), Write(*), Edit(*), Bash(wc:*)
---

# Validate Context — Quality Check & Validation

**CRITICAL INSTRUCTION**: YOU MUST complete ALL validation steps IN EXACT ORDER. DO NOT skip steps. DO NOT improvise scoring logic. ONLY use Read, Write, Edit, Bash tools as specified.

---

## Purpose

Validates that `.claude/memory/` files contain sufficient, high-quality context:
- **productContext.md** - Project overview, tech stack, features
- **systemPatterns.md** - Coding conventions, patterns
- **activeContext.md** - Current focus, recent work
- **progress.md** - Development progress tracking
- **decisionLog.md** - Technical decisions
- **project-structure.json** - Auto-detected structure

---

## Usage

```bash
# Check context quality
/validate-context

# Check and offer to fix issues
/validate-context --fix
```

---

## STEP 1: Read All Memory Files - MANDATORY

**YOU MUST USE Read TOOL** on these files:
- `.claude/memory/productContext.md`
- `.claude/memory/systemPatterns.md`
- `.claude/memory/activeContext.md`
- `.claude/memory/progress.md`
- `.claude/memory/decisionLog.md`
- `.claude/memory/project-structure.json` (if exists)

**CRITICAL**: Read ALL files first before any validation logic

---

## STEP 2: Validate productContext.md - MANDATORY

**YOU MUST CHECK** the following (use exact pattern matching):

### Check 1: Project Name (10 points)
**CONDITION**: Find line matching `# Product Context — (.+)`
**SCORING LOGIC**:
- IF line contains `[PROJECT_NAME]` → 0 points (❌ Template placeholder)
- IF project name is `.` or empty → 0 points (❌ Invalid)
- IF project name exists and is real → 10 points (✅ Valid)

### Check 2: Project Description (10 points)
**CONDITION**: Count words in "Project Overview" section (first 100 words after header)
**SCORING LOGIC**:
- IF description < 20 words → 0 points (❌ Too short)
- IF description contains `[PROJECT_DESCRIPTION]` or `[AUTO_DETECTED]` → 0 points (❌ Template)
- IF description >= 20 words and is real → 10 points (✅ Valid)

### Check 3: Technology Stack (15 points)
**CONDITION**: Find "Technology Stack" or "Tech Stack" section, count items
**SCORING LOGIC**:
- IF contains `[AUTO_DETECTED]` → 0 points (❌ Template)
- IF has 3+ technology items (bullets/list) → 15 points (✅ Complete)
- IF has 1-2 items → 8 points (⚠️ Minimal)
- IF has 0 items or missing → 0 points (❌ Missing)

### Check 4: Core Features (15 points)
**CONDITION**: Find "Core Features" or "Features" section, count items
**SCORING LOGIC**:
- IF contains `[FEATURE_1]` or similar placeholders → 0 points (❌ Template)
- IF has 5+ features → 15 points (✅ Excellent)
- IF has 2-4 features → 10 points (✅ Good)
- IF has 1 feature → 5 points (⚠️ Minimal)
- IF has 0 features → 0 points (❌ Missing)

### Check 5: Architecture (10 points)
**CONDITION**: Find "Architecture" section or mention
**SCORING LOGIC**:
- IF contains `[ARCHITECTURE]` placeholder → 0 points (❌ Template)
- IF has architecture description (>30 words) → 10 points (✅ Detailed)
- IF mentions architecture briefly (<30 words) → 5 points (⚠️ Basic)
- IF missing → 0 points (❌ Missing)

### Check 6: Development Goals (5 points)
**CONDITION**: Find "Development Goals" or "Goals" section
**SCORING LOGIC**:
- IF section exists with content → 5 points (✅ Defined)
- IF missing or empty → 0 points (❌ Missing)

### Check 7: Success Metrics (5 points)
**CONDITION**: Find "Success Metrics" or "Metrics" section
**SCORING LOGIC**:
- IF section exists with content → 5 points (✅ Defined)
- IF missing or empty → 0 points (❌ Missing)

**productContext.md MAX SCORE**: 70 points

---

## STEP 3: Validate systemPatterns.md - MANDATORY

**YOU MUST CHECK** the following:

### Check 1: Architectural Principles (10 points)
**CONDITION**: Find "Architectural Principles" section, check content
**SCORING LOGIC**:
- IF has 3+ principles listed → 10 points (✅ Complete)
- IF has 1-2 principles → 5 points (⚠️ Basic)
- IF missing or placeholder `[PRINCIPLES]` → 0 points (❌ Missing)

### Check 2: File Organization (5 points)
**CONDITION**: Find "File Organization" or "Project Structure" section
**SCORING LOGIC**:
- IF section exists with content → 5 points (✅ Defined)
- IF missing → 0 points (❌ Missing)

### Check 3: Tech Stack Mentioned (5 points)
**CONDITION**: Check if technology stack is referenced
**SCORING LOGIC**:
- IF tech stack mentioned → 5 points (✅ Referenced)
- IF missing → 0 points (❌ Missing)

### Check 4: Testing Patterns (5 points)
**CONDITION**: Find "Testing" section with patterns
**SCORING LOGIC**:
- IF testing framework and patterns defined → 5 points (✅ Defined)
- IF missing or generic → 0 points (❌ Missing)

### Check 5: Error Handling (5 points)
**CONDITION**: Find "Error Handling" section
**SCORING LOGIC**:
- IF error handling approach defined → 5 points (✅ Defined)
- IF missing → 0 points (❌ Missing)

**systemPatterns.md MAX SCORE**: 30 points

---

## STEP 4: Validate activeContext.md - MANDATORY

**YOU MUST CHECK** the following:

### Check 1: Current Focus (10 points)
**CONDITION**: Find "Current Focus" section
**SCORING LOGIC**:
- IF contains `[CURRENT_FOCUS]` or similar placeholder → 0 points (❌ Template)
- IF has real focus description (>10 words) → 10 points (✅ Defined)
- IF has brief focus (<10 words) → 5 points (⚠️ Minimal)
- IF missing → 0 points (❌ Missing)

### Check 2: Recent Achievements (5 points)
**CONDITION**: Find "Recent Achievements" section
**SCORING LOGIC**:
- IF has 1+ achievements listed → 5 points (✅ Tracked)
- IF section empty or missing → 0 points (❌ Missing)

### Check 3: Next Priorities (5 points)
**CONDITION**: Find "Next Priorities" section
**SCORING LOGIC**:
- IF has 1+ priorities listed → 5 points (✅ Defined)
- IF section empty or missing → 0 points (❌ Missing)

### Check 4: Blockers Section (5 points)
**CONDITION**: Find "Blockers" or "Current Blockers" section
**SCORING LOGIC**:
- IF section exists (even if "None") → 5 points (✅ Tracked)
- IF missing → 0 points (❌ Missing)

**activeContext.md MAX SCORE**: 25 points

---

## STEP 5: Validate progress.md - MANDATORY

**YOU MUST CHECK** the following:

### Check 1: Has Required Sections (10 points)
**CONDITION**: Find "COMPLETED", "IN PROGRESS", "PENDING" sections
**SCORING LOGIC**:
- IF all 3 sections exist → 10 points (✅ Complete structure)
- IF 1-2 sections exist → 5 points (⚠️ Partial)
- IF no sections → 0 points (❌ Missing)

### Check 2: Current Phase Defined (5 points)
**CONDITION**: Find "Current Phase" or "Current Sprint"
**SCORING LOGIC**:
- IF contains `[CURRENT_PHASE]` placeholder → 0 points (❌ Template)
- IF phase is defined → 5 points (✅ Defined)
- IF missing → 0 points (❌ Missing)

### Check 3: Has Completed Tasks (5 points)
**CONDITION**: Check COMPLETED section has items
**SCORING LOGIC**:
- IF has 1+ completed tasks → 5 points (✅ Tracked)
- IF empty → 0 points (❌ Empty)

### Check 4: Sprint Info (5 points)
**CONDITION**: Find sprint deadline, goals, or status
**SCORING LOGIC**:
- IF sprint info present → 5 points (✅ Defined)
- IF missing → 0 points (❌ Missing)

**progress.md MAX SCORE**: 25 points

---

## STEP 6: Validate decisionLog.md - MANDATORY

**BONUS SCORING** (Optional - new projects may be empty):

### Check 1: Has Decision Entries (5 points BONUS)
**CONDITION**: Count ADR entries (lines with `## [DATE]`)
**SCORING LOGIC**:
- IF has 3+ decisions → 5 points (✅ Excellent)
- IF has 1-2 decisions → 3 points (✅ Good)
- IF has 0 decisions → 0 points (⚠️ Empty - acceptable for new projects)

**decisionLog.md MAX SCORE**: 5 points (BONUS)

---

## STEP 7: Validate project-structure.json - MANDATORY

**YOU MUST CHECK** if file exists:

### Check 1: File Exists (5 points)
**CONDITION**: Check if `.claude/memory/project-structure.json` exists
**SCORING LOGIC**:
- IF file exists → 5 points (✅ Present)
- IF missing → 0 points (❌ Missing - suggest running /init-memory-bank)

### Check 2: Valid JSON (5 points)
**CONDITION**: Verify file is valid JSON (can be parsed)
**SCORING LOGIC**:
- IF valid JSON → 5 points (✅ Valid)
- IF invalid or corrupted → 0 points (❌ Invalid)

**project-structure.json MAX SCORE**: 10 points

---

## STEP 8: Calculate Overall Quality Score - MANDATORY

**YOU MUST CALCULATE** total score from all files:

**TOTAL POSSIBLE**: 165 points (160 + 5 bonus)
**SCORING SYSTEM**:
```
productContext.md:       70 points (43%)
systemPatterns.md:       30 points (18%)
activeContext.md:        25 points (15%)
progress.md:             25 points (15%)
project-structure.json:  10 points (6%)
decisionLog.md:          5 points (3% BONUS)
```

**Quality Levels**:
- 🌟 **Optimal** (132+ points / 80%+): Excellent effectiveness, production-ready
- 🟢 **Recommended** (99-131 points / 60-79%): Good effectiveness, fully functional
- 🟡 **Minimum** (66-98 points / 40-59%): Works but limited, needs improvement
- 🔴 **Below Minimum** (<66 points / <40%): Critical issues, run /init-memory-bank

---

## STEP 9: Display Validation Report - MANDATORY

**YOU MUST OUTPUT** in this EXACT format:

```
🔍 CONTEXT QUALITY VALIDATION REPORT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Overall Score: [TOTAL]/165 ([PERCENTAGE]%) - [STATUS] [EMOJI]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 productContext.md: [SCORE]/70 points ([PERCENTAGE]%)
   [For each check: ✅ or ❌ with specific details]
   ✅ Project name: [actual project name]
   ✅/❌ Tech stack: [count] technologies
   ✅/❌ Core features: [count] features
   ✅/❌ Architecture: [status]
   ✅/❌ Development goals: [status]
   ✅/❌ Success metrics: [status]

📄 systemPatterns.md: [SCORE]/30 points ([PERCENTAGE]%)
   [For each check: ✅ or ❌ with details]

📄 activeContext.md: [SCORE]/25 points ([PERCENTAGE]%)
   [For each check: ✅ or ❌ with details]

📄 progress.md: [SCORE]/25 points ([PERCENTAGE]%)
   [For each check: ✅ or ❌ with details]

📄 decisionLog.md: [SCORE]/5 points (BONUS)
   ✅/⚠️ Has [count] technical decisions

📄 project-structure.json: [SCORE]/10 points
   ✅/❌ File exists: [yes/no]
   ✅/❌ Valid JSON: [yes/no]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 RECOMMENDATIONS:

[IF ANY SCORES BELOW MAX, LIST IMPROVEMENTS NEEDED]

HIGH PRIORITY (Critical for effectiveness):
  • [List items with 0 points]

MEDIUM PRIORITY (Recommended improvements):
  • [List items with partial points]

OPTIONAL (Nice to have):
  • [List bonus items]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 NEXT STEPS:
   [IF SCORE >= 80%]: ✅ Your context is OPTIMAL! No action needed.
   [IF SCORE 60-79%]: ⚠️  Address HIGH PRIORITY items, then re-run /validate-context
   [IF SCORE < 60%]: 🔴 CRITICAL: Run /init-memory-bank to properly initialize

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Status Emoji Guide**:
- 🌟 for Optimal (80%+)
- 🟢 for Recommended (60-79%)
- 🟡 for Minimum (40-59%)
- 🔴 for Below Minimum (<40%)

---

## STEP 10: --fix Mode (Optional) - ONLY IF USER PROVIDED --fix FLAG

**IF `--fix` FLAG PROVIDED**, ask user for each missing item:

**DO NOT automatically fix without asking first!**

```
Would you like me to help fix the [COUNT] issues found? (yes/no)
```

**IF USER SAYS YES**:

For each HIGH PRIORITY issue:
1. Ask specific question (e.g., "What is your project's architecture?")
2. Wait for user response
3. Update the appropriate memory file using Edit tool
4. Confirm: "✅ Updated [file]"

**AFTER ALL FIXES**:
```
✅ Context updated! Run /validate-context again to verify improvements.
```

**IF USER SAYS NO**:
```
Understood. You can fix these manually or run /validate-context again later.
```

---

## ABSOLUTELY FORBIDDEN

- ❌ DO NOT claim 95% or 100% score if files have template placeholders
- ❌ DO NOT give points for `[PROJECT_NAME]` or `[AUTO_DETECTED]` placeholders
- ❌ DO NOT skip reading all files before validation
- ❌ DO NOT improvise different scoring logic
- ❌ DO NOT modify files without user consent (except with --fix flag)
- ❌ DO NOT use old 150-point scoring system (now 165 points)
- ❌ DO NOT ignore empty sections when calculating scores

**VALIDATION CHECK**: Before displaying report, verify:
- ✅ All 6 files were read using Read tool
- ✅ Each check followed exact scoring logic from STEP 2-7
- ✅ Total score is sum of all file scores (max 165)
- ✅ Percentage calculated correctly: (total / 165) × 100
- ✅ Status matches score range (80%+, 60-79%, 40-59%, <40%)

---

## Summary

**This command validates memory bank context quality with strict, objective scoring.**

**Key Changes from Previous Version**:
- ✅ Now 165 points total (was 150)
- ✅ Template placeholder detection (fails `[PROJECT_NAME]`, etc.)
- ✅ Explicit scoring logic for each check
- ✅ Matches what `/init-memory-bank` actually creates
- ✅ Mental model strengthening (MUST, MANDATORY, FORBIDDEN)

**Remember**: This validation MUST match the output of `/init-memory-bank` command!

