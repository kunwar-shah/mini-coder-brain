# /map-codebase - Revolutionary Codebase Mapping

## Purpose
Load intelligent codebase mappings into session context for instant file access and surgical code edits. Eliminates file searching and enables AI with developer-level codebase intuition.

## Usage
- `/map-codebase` - Load smart mapping (15 most important files)
- `/map-codebase --recent` - Load recently modified files only  
- `/map-codebase --full` - Load comprehensive mapping (25+ files)
- `/map-codebase --rebuild` - Rebuild mappings from scratch

## Examples

### Example 1: Smart Loading (Recommended Daily Workflow)
```bash
/map-codebase
```
**Generated Output**: Loads 15 most critical files with architecture overview
**Use Case**: Starting development session, need broad codebase awareness without overwhelming context
**Expected Result**: 25-40 lines of intelligent file mappings showing controllers, services, key components with purposes and functions

### Example 2: Recent Changes Focus (Debug/Continue Work)
```bash
/map-codebase --recent  
```
**Generated Output**: Files modified in last 7 days with change summary
**Use Case**: Debugging recent changes, continuing yesterday's work, understanding what's been modified
**Expected Result**: 10-20 lines focusing on recently changed files with modification context

### Example 3: Comprehensive System Understanding (Architecture Work)
```bash
/map-codebase --full
```
**Generated Output**: Extended mapping up to 25 key files across all areas
**Use Case**: Complex refactoring, architecture changes, comprehensive system understanding
**Expected Result**: 40-60 lines covering broader system architecture when context window allows

## Revolutionary Benefits
- **🎯 Instant File Location**: Know exactly where every piece of logic lives
- **⚡ Surgical Edits**: Direct file access based on intent (no more searching)
- **🧠 Architecture Awareness**: Understand project structure immediately  
- **🚀 10x Development Speed**: Transform "10 search operations → 1 edit" to "1 direct edit"
- **🔄 Smart Caching**: Rebuild only when needed, instant loading when cached

## Implementation

```bash
# Execute the map-codebase command implementation
bash "$CLAUDE_PROJECT_DIR/.claude/hooks/map-codebase-command.sh" "$@"
```