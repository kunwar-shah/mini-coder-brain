# Empty Project Example

**Scenario**: Brand new project, no existing code or documentation

## What This Shows

This example demonstrates mini-coder-brain setup for a **greenfield project** where:
- ✅ User ran `/init-memory-bank` interactively
- ✅ Provided minimum required information
- ✅ No code exists yet, pure planning phase
- ✅ Context quality: ~60% (Minimum but functional)

## Memory Bank Files

### `.claude/memory/productContext.md`
- Basic project info from user prompts
- Tech stack choices
- Initial feature ideas
- Development goals

### `.claude/memory/activeContext.md`
- Current focus: "Project planning and setup"
- No achievements yet (just starting)
- Priorities: Set up infrastructure

### `.claude/memory/progress.md`
- Empty structure ready for tracking
- Planning phase noted
- No completed tasks yet

## Usage

This setup is enough for Claude to:
- ✅ Help you build features from scratch
- ✅ Know your tech stack preferences
- ✅ Suggest architecture patterns
- ✅ Generate code matching your choices

## How to Improve

To reach 80%+ context quality:
1. Add more detailed feature descriptions
2. Document architectural decisions as you make them
3. Run `/update-memory-bank` after major progress
4. Create SRS.md and import with `/import-docs`

## Commands to Try

```bash
# Check current quality
/validate-context

# After adding features
/update-memory-bank "Completed initial project setup"

# Generate codebase map
/map-codebase
```
