---
description: Import external documentation into memory bank (SRS, architecture, API docs)
argument-hint: "<path-to-docs> [--type <srs|architecture|api|general>]"
allowed-tools: Read(*), Edit(*), Glob(*)
---

# Import Docs — Documentation Integration

**CRITICAL INSTRUCTION**: YOU MUST complete ALL steps below IN EXACT ORDER. DO NOT SKIP any step. ONLY use Read, Edit, and Glob tools as specified.

Import external documentation (SRS, technical specs, architecture docs) into your memory bank after initial setup. Use this when you have documentation that wasn't imported during `/init-memory-bank`.

## Purpose

**THIS COMMAND INTEGRATES** external documentation into appropriate memory bank files:
- **SRS/Requirements** → YOU MUST update `productContext.md` (features, requirements)
- **Architecture Docs** → YOU MUST update `systemPatterns.md` (patterns, architecture)
- **API Documentation** → YOU MUST update `systemPatterns.md` (API patterns)
- **Technical Decisions** → YOU MUST update `decisionLog.md` (ADRs)

## Usage

```bash
# Import entire docs folder
/import-docs ./docs

# Import specific file
/import-docs ./documentation/SRS.md

# Import with type hint
/import-docs ./specs/ARCHITECTURE.md --type architecture

# Import multiple files
/import-docs ./docs --type general
```

## Supported Document Types

### Auto-Detected (by filename)
- `SRS.md`, `REQUIREMENTS.md` → Product Context
- `ARCHITECTURE.md`, `DESIGN.md` → System Patterns
- `API.md`, `API_SPEC.md` → System Patterns (API section)
- `DECISIONS.md`, `ADR.md` → Decision Log
- `TECHNICAL_SPEC.md` → System Patterns

### Manual Type Specification
- `--type srs` → Requirements document
- `--type architecture` → Architecture/design document
- `--type api` → API specification
- `--type decisions` → Technical decision records
- `--type general` → General documentation (analyze and categorize)

---

## EXECUTION STEPS - MANDATORY

## STEP 1: Parse Arguments - MANDATORY

**ACTION**: Extract path and type from command

**DETECT** (YOU MUST check):
- Path argument: First argument after `/import-docs`
- Type argument: IF contains `--type <value>` → Set TYPE=<value>
- IF no type → Set TYPE="auto-detect"

**OUTPUT**:
```
📚 Import Docs Command
   - Path: [path]
   - Type: [type | auto-detect]
```

**VALIDATION**:
- ✅ Path provided (required)
- ✅ Type detected or set to auto-detect
- ✅ Path format validated

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT proceed without path
- ❌ DO NOT assume document type without checking

### STEP 2: Discover Documentation Files

If path is a folder:
```bash
# Find all markdown and text files
find "$path" -type f \( -name "*.md" -o -name "*.txt" \) 2>/dev/null

# Common patterns to look for:
- SRS.md, Requirements.md
- ARCHITECTURE.md, Design.md
- API.md, API_SPEC.md
- DECISIONS.md, ADR*.md
- TECHNICAL_SPEC.md
```

If path is a file:
- Detect type from filename or use --type flag
- Read single file

### STEP 3: Read and Analyze Each Document

For each document:

1. **Read File Content**
   ```
   Use Read tool to load file content
   ```

2. **Detect Document Type** (if not specified):
   ```
   Filename patterns:
   - /srs|requirements/i → SRS
   - /architecture|design/i → Architecture
   - /api|endpoint/i → API
   - /decision|adr/i → Decisions
   - Otherwise → General (analyze content)
   ```

3. **Extract Relevant Information**:

   **For SRS/Requirements**:
   - Core features list
   - Functional requirements
   - Non-functional requirements
   - User stories / use cases
   - Success criteria

   **For Architecture**:
   - System architecture description
   - Component interactions
   - Design patterns used
   - Technology choices
   - Architectural principles

   **For API Docs**:
   - API endpoints structure
   - Authentication patterns
   - Error handling approach
   - Response formats
   - Rate limiting

   **For Decisions**:
   - Technical decisions made
   - Rationale for each decision
   - Alternatives considered
   - Impact assessment

### STEP 4: Integrate into Memory Bank

#### Integration Rules:

1. **productContext.md** (from SRS):
   - Append/update "Core Features" section
   - Update "Project Overview" if better description found
   - Add to "Success Metrics" if metrics defined
   - Preserve existing content, enhance don't replace

2. **systemPatterns.md** (from Architecture/API):
   - Append to "Architectural Principles" section
   - Add to "API Patterns" section (create if doesn't exist)
   - Update "Technology Stack Details" with rationale
   - Add discovered patterns to appropriate sections

3. **decisionLog.md** (from Decisions):
   - Append new ADR entries with timestamps
   - Format as standard ADR:
     ```markdown
     ## [DATE] ADR-ID — Decision Title
     **Decision**: What was decided
     **Rationale**: Why this decision
     **Alternatives**: What else was considered
     **Impact**: Expected consequences
     ```

### STEP 5: Show Integration Summary

```
📚 Documentation Import Complete!

Files Analyzed:
  ✅ docs/SRS.md (234 lines) → Requirements
  ✅ docs/ARCHITECTURE.md (156 lines) → Architecture
  ✅ docs/API.md (89 lines) → API Patterns

Extracted Information:
  → 12 core features → productContext.md
  → 5 architectural patterns → systemPatterns.md
  → 8 API endpoints documented → systemPatterns.md
  → 3 technical decisions → decisionLog.md

Memory Bank Updates:
  ✅ productContext.md - Added 12 features, enhanced overview
  ✅ systemPatterns.md - Added architecture section, API patterns
  ✅ decisionLog.md - Added 3 decision entries

📊 Updated Context Quality: 92% (Optimal) ⬆️ +15%

💡 Next: Run /validate-context to verify integration
```

### STEP 6: Validation Check

After integration, validate context quality:
- Run internal quality check (same as `/validate-context`)
- Show before/after score
- Highlight improvements

## Examples

### Example 1: Import SRS Document

```
User: /import-docs ./documentation/SRS.md

🔍 Analyzing documentation...
✅ Detected: Requirements Specification (SRS)

📄 Reading SRS.md (348 lines)...
✅ Extracted:
   - 15 core features
   - 8 user stories
   - 6 non-functional requirements
   - Success criteria defined

📝 Integrating into productContext.md...
✅ Added 15 features to "Core Features" section
✅ Enhanced "Project Overview" with user stories
✅ Updated "Success Metrics" section

📊 Context Quality: 85% → 95% (+10%)

✅ SRS documentation integrated successfully!
```

### Example 2: Import Architecture Docs

```
User: /import-docs ./docs/ARCHITECTURE.md --type architecture

🔍 Analyzing architecture documentation...

📄 Reading ARCHITECTURE.md (267 lines)...
✅ Extracted:
   - System architecture: Microservices with event bus
   - 4 architectural principles
   - Technology choices (Node.js, RabbitMQ, PostgreSQL)
   - 6 design patterns

📝 Integrating into systemPatterns.md...
✅ Added architecture description
✅ Added 4 architectural principles
✅ Documented design patterns
✅ Added technology rationale

📊 Context Quality: 70% → 88% (+18%)

✅ Architecture documentation integrated!
```

### Example 3: Import Entire Docs Folder

```
User: /import-docs ./documentation

🔍 Scanning ./documentation folder...
✅ Found 5 documentation files

📄 Processing files:
  1. SRS.md (requirements)
  2. ARCHITECTURE.md (architecture)
  3. API_SPEC.md (api)
  4. DECISIONS.md (decisions)
  5. SETUP.md (general)

📚 Analyzing all documents...
[Progress indicators for each file]

📝 Integration complete!

Summary:
  → 18 features integrated
  → 7 architectural patterns added
  → 12 API endpoints documented
  → 5 technical decisions recorded

📊 Context Quality: 65% → 95% (+30%)

🎉 All documentation integrated successfully!
💡 Run /validate-context to see detailed improvements
```

## Integration Strategy

### Merge vs Replace

**Always Merge** (never replace):
- Existing manual edits are preserved
- New info is appended or integrated
- Conflicts are highlighted for user review

**Conflict Resolution**:
```
⚠️  Conflict Detected:

productContext.md currently lists 8 features.
SRS.md contains 15 features (7 new, 8 matching).

Action:
  ✅ Preserved existing 8 features
  ✅ Added 7 new features from SRS
  ✅ No duplicates created

Review: .claude/memory/productContext.md (Core Features section)
```

## Use Cases

### Use Case 1: Late Documentation Discovery

```
Scenario: Installed mini-coder-brain without knowing docs existed

Steps:
1. /init-memory-bank (creates basic context)
2. Discover ./docs folder with comprehensive SRS
3. /import-docs ./docs (integrates found documentation)
4. Context quality jumps from 60% to 95%
```

### Use Case 2: Documentation Updates

```
Scenario: SRS updated with new features

Steps:
1. /import-docs ./docs/SRS_v2.md
2. New features automatically added
3. Existing features preserved
4. Context stays current
```

### Use Case 3: Gradual Documentation Build

```
Scenario: Building documentation incrementally

Week 1: /import-docs ./docs/ARCHITECTURE.md
Week 2: /import-docs ./docs/API.md
Week 3: /import-docs ./docs/DECISIONS.md

Each import enhances context progressively
```

## Error Handling

### File Not Found
```
❌ Error: File not found: ./docs/SRS.md
💡 Check path: Use absolute path or relative from project root
```

### Invalid Document Type
```
⚠️  Warning: Could not detect document type for "notes.md"
💡 Use --type flag: /import-docs ./notes.md --type general
```

### Empty or Malformed Document
```
⚠️  Warning: Document appears empty or malformed
📄 File: ./docs/incomplete.md (23 lines, no structure detected)
💡 Skipping: Fix document structure and re-import
```

### Already Imported
```
ℹ️  Note: This document was previously imported
📅 Last import: 2025-10-10 (4 days ago)
💡 Re-importing will merge new content only
```

## Best Practices

1. **Import Early**: Run after `/init-memory-bank` if docs exist
2. **Keep Docs Updated**: Re-import when documentation changes
3. **Use Type Hints**: Specify `--type` for ambiguous filenames
4. **Review After Import**: Check `.claude/memory/` files for accuracy
5. **Validate Quality**: Run `/validate-context` after import

## Related Commands

- `/init-memory-bank` - Initial setup (includes auto-docs import)
- `/validate-context` - Check context quality after import
- `/update-memory-bank` - Manual context updates
- `/memory-sync` - Full memory synchronization

---

**When to Use**: After initial setup, when documentation becomes available, or when docs are updated
**Impact**: High - can significantly improve context quality (20-30% boost typical)
**Frequency**: As needed when documentation changes
