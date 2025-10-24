---
description: Initialize memory bank with auto-populated project context (MANDATORY on first install)
argument-hint: "[--dry-run] [--docs-path <path>]"
---

# Init Memory Bank — Smart Context Initialization

**CRITICAL INSTRUCTION**: YOU MUST complete ALL initialization steps IN EXACT ORDER. DO NOT skip steps. DO NOT improvise. ONLY use Read, Write, Edit, Glob, Grep, Bash tools as specified.

---

## Purpose

Initializes `.claude/memory/` files with auto-detected project context:
- **productContext.md** - Project name, description, tech stack, features, architecture
- **activeContext.md** - Initial focus and setup status
- **progress.md** - Empty structure ready for tracking
- **decisionLog.md** - Empty log ready for ADRs
- **systemPatterns.md** - Initial patterns from codebase analysis

---

## Usage

Check for --dry-run or --docs-path arguments in user message.

---

## STEP 1: Detect Project Type - MANDATORY

**YOU MUST USE Bash TOOL** to check for package managers:

Count these files: package.json, requirements.txt, Cargo.toml, go.mod, Gemfile

**CLASSIFY PROJECT**:
- Has package manager = Existing project
- Has docs/ folder = Complex project
- Few files = Empty project
- Default = Generic project

---

## STEP 2: Extract Project Name - MANDATORY

**YOU MUST TRY** in this order (stop at first success):

1. Read package.json and extract "name" field
2. Read Cargo.toml and extract name field
3. Use basename of current directory

Store result as PROJECT_NAME variable

---

## STEP 3: Extract Description - MANDATORY

**YOU MUST TRY** in this order:

1. Read README.md first paragraph
2. Read package.json "description" field
3. Use fallback: "A software development project"

Store result as DESCRIPTION variable

---

## STEP 4: Detect Tech Stack - MANDATORY

**YOU MUST USE Glob/Read TOOLS** to detect:

- If package.json exists: Node.js/JavaScript
- If requirements.txt exists: Python
- If Cargo.toml exists: Rust
- If go.mod exists: Go

List all detected technologies

---

## STEP 5: Detect Features - MANDATORY

**YOU MUST USE Read TOOL** on README.md if it exists

Look for sections with headers containing "Features" or "What it does"

Extract feature list (first 5 features maximum)

---

## STEP 6: Read Documentation (if --docs-path provided) - MANDATORY

**IF** user message contains --docs-path:

Extract the path value

**YOU MUST USE Glob TOOL** to find all .md files in that path

**YOU MUST USE Read TOOL** on key docs: SRS.md, ARCHITECTURE.md, API.md

Extract additional features and architecture details

**ELSE**:

Skip this step

---

## STEP 7: Write Memory Bank Files - MANDATORY

**YOU MUST USE Write TOOL** to create these files:

`.claude/memory/productContext.md` with structure:
- Project name
- Description
- Technology Stack
- Core Features
- Architecture Overview

`.claude/memory/activeContext.md` with:
- Current Focus: "Project initialization complete"
- Recent Achievements: "Memory bank initialized"

`.claude/memory/progress.md` with empty task structure

`.claude/memory/decisionLog.md` with empty ADR structure

`.claude/memory/systemPatterns.md` with detected patterns

---

## STEP 8: Calculate Quality Score - MANDATORY

**YOU MUST CALCULATE** based on:

- Project name found: +20 points
- Description found: +20 points
- Tech stack detected (>= 1): +20 points
- Features detected (>= 3): +20 points
- Architecture info found: +20 points

Maximum 100 points

---

## Final Output - MANDATORY

**YOU MUST DISPLAY**:

Success message with:
- Project name
- Quality score percentage
- Number of features detected
- Tech stack items
- Next recommended action

**IF** quality < 60%:

Suggest running /validate-context --fix

---
