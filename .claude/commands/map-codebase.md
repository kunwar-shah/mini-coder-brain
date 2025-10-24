---
description: Map codebase structure for instant file access
argument-hint: "[--rebuild] [--recent] [--full]"
---

# Map Codebase — Intelligent Structure Mapping

**CRITICAL INSTRUCTION**: YOU MUST complete ALL mapping steps IN EXACT ORDER. DO NOT skip steps. DO NOT improvise. ONLY use Read, Write, Glob, Grep, Bash tools as specified.

---

## Purpose

Creates `.claude/cache/codebase-map.json` with intelligent file mappings:
- Key source files organized by type
- Important configuration files
- Entry points and main modules
- Test files
- Documentation files

Enables instant file access without searching.

---

## Usage

Check for mode arguments in user message:
- `--rebuild` = Full rebuild from scratch
- `--recent` = Map only recently changed files
- `--full` = Comprehensive mapping (all files)
- No argument = Smart mode (15-20 key files)

---

## STEP 1: Detect Project Structure - MANDATORY

**YOU MUST USE Glob/Bash TOOLS** to detect project type:

Check for these patterns:
- `src/` or `lib/` directory = Source code project
- `package.json` = Node.js project
- `requirements.txt` or `setup.py` = Python project
- `Cargo.toml` = Rust project
- `go.mod` = Go project

Store detected type for filtering

---

## STEP 2: Find Key Files - MANDATORY

**YOU MUST USE Glob TOOL** to find files by category:

**Entry Points** (high priority):
- `index.js`, `main.js`, `app.js`, `server.js`
- `main.py`, `__main__.py`, `app.py`
- `main.rs`, `lib.rs`
- `main.go`

**Source Files**:
- `src/**/*.{js,jsx,ts,tsx}` (JavaScript/TypeScript)
- `src/**/*.py` (Python)
- `src/**/*.rs` (Rust)
- `**/*.go` (Go)

**Configuration**:
- `package.json`, `tsconfig.json`, `webpack.config.js`
- `Cargo.toml`, `go.mod`, `setup.py`

**Tests**:
- `**/*.test.{js,ts,py,rs}`
- `**/*.spec.{js,ts}`
- `tests/**/*`

**Documentation**:
- `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`
- `docs/**/*.md`

Limit to 50 files maximum for smart mode

---

## STEP 3: Get File Metadata - MANDATORY

**FOR EACH** file found:

**YOU MUST USE Bash TOOL** to get:
- File size: `wc -c < filepath`
- Line count: `wc -l < filepath`
- Last modified: `stat -c %Y filepath` (Linux) or `stat -f %m filepath` (Mac)

Store metadata with file path

---

## STEP 4: Rank Files by Importance - MANDATORY

**YOU MUST CALCULATE** importance score:

Priority scoring:
- Entry point files: +50 points
- Recently modified (< 7 days): +30 points
- In `src/` directory: +20 points
- Configuration files: +15 points
- Large files (>500 lines): +10 points
- Test files: +5 points

Sort files by score descending

---

## STEP 5: Create Codebase Map - MANDATORY

**YOU MUST USE Write TOOL** to create `.claude/cache/codebase-map.json`:

JSON structure:
```
{
  "generated": "YYYY-MM-DD HH:MM:SS",
  "project_type": "detected type",
  "total_files": count,
  "entry_points": [file paths],
  "source_files": [file paths with metadata],
  "config_files": [file paths],
  "test_files": [file paths],
  "docs_files": [file paths]
}
```

Include top 15-50 files depending on mode

---

## STEP 6: Display Summary - MANDATORY

**YOU MUST DISPLAY**:

Success message with:
- Number of files mapped
- Project type detected
- Entry points found
- Cache file location
- Next steps

Example output:
```
✅ Codebase mapped successfully!

📊 Summary:
- Project type: Node.js (TypeScript)
- Files mapped: 23 files
- Entry points: 2 (src/index.ts, src/server.ts)
- Source files: 15
- Config files: 4
- Test files: 2

💾 Map saved to: .claude/cache/codebase-map.json

You can now reference files instantly by name without searching!
```

---

## Mode Variations - MANDATORY

**IF --rebuild**: Delete existing cache first, map all files

**IF --recent**: Only map files modified in last 7 days using `find . -mtime -7`

**IF --full**: Map up to 200 files (comprehensive)

**IF smart (default)**: Map 15-20 most important files

---
