# /map-codebase - Revolutionary Codebase Mapping

**CRITICAL INSTRUCTION**: This command delegates to `.claude/hooks/map-codebase-command.sh` which performs ALL codebase analysis. YOU MUST invoke the hook and display its output. DO NOT attempt to map codebase manually.

## Purpose
Load intelligent codebase mappings into session context for instant file access and surgical code edits. Eliminates file searching and enables AI with developer-level codebase intuition.

---

## EXECUTION STEPS - MANDATORY

## STEP 1: Parse Arguments - MANDATORY

**ACTION**: Detect mapping mode

**DETECT** (YOU MUST check for these EXACT strings):
- IF message contains `--rebuild` → Set MODE="rebuild"
- IF message contains `--recent` → Set MODE="recent"
- IF message contains `--full` → Set MODE="full"
- IF no arguments → Set MODE="smart"

**OUTPUT**: Tell user which mode:
- "Rebuilding codebase map from scratch..."
- "Loading recent changes mapping..."
- "Loading comprehensive mapping..."
- "Loading smart mapping (15 key files)..."

---

## STEP 2: Invoke Hook - MANDATORY

**YOU MUST USE Bash TOOL** to execute mapping hook

**EXACT COMMAND** (based on MODE):
```bash
bash .claude/hooks/map-codebase-command.sh [MODE]
```

**WHERE MODE IS**:
- `--rebuild` if MODE="rebuild"
- `--recent` if MODE="recent"
- `--full` if MODE="full"
- (no argument) if MODE="smart"

**VALIDATION**:
- ✅ Used Bash tool
- ✅ Hook executed successfully
- ✅ Hook returned codebase mapping output

**ABSOLUTELY FORBIDDEN**:
- ❌ DO NOT attempt to map codebase manually
- ❌ DO NOT use Glob/Grep to build map
- ❌ DO NOT skip hook invocation
- ❌ DO NOT improvise mapping logic

---

## STEP 3: Display Hook Output - MANDATORY

**YOU MUST DISPLAY** the complete output from the hook

**OUTPUT**: Show user the codebase mapping returned by hook

**VALIDATION**:
- ✅ Displayed hook output completely
- ✅ Did not modify or filter hook output
- ✅ User sees full codebase mapping

---

## ABSOLUTELY FORBIDDEN

- ❌ DO NOT manually map codebase with Glob/Grep
- ❌ DO NOT skip hook execution
- ❌ DO NOT filter or modify hook output
- ❌ DO NOT improvise different mapping logic
- ❌ DO NOT use Read/Glob tools to build map

**REMEMBER**: Hook does ALL the work. You just invoke it and display results.

---

## Usage
- `/map-codebase` - Load smart mapping (15 most important files)
- `/map-codebase --recent` - Load recently modified files only
- `/map-codebase --full` - Load comprehensive mapping (25+ files)
- `/map-codebase --rebuild` - Rebuild mappings from scratch

## Revolutionary Benefits
- **🎯 Instant File Location**: Know exactly where every piece of logic lives
- **⚡ Surgical Edits**: Direct file access based on intent (no more searching)
- **🧠 Architecture Awareness**: Understand project structure immediately
- **🚀 10x Development Speed**: Transform "10 search operations → 1 edit" to "1 direct edit"
- **🔄 Smart Caching**: Rebuild only when needed, instant loading when cached
