---
layout: page
title: Commands Reference
subtitle: Complete guide to all Mini-CoderBrain commands
---

# Commands Reference

Complete reference for all Mini-CoderBrain slash commands.

---

## 🗺️ Codebase Mapping

### `/map-codebase`

Revolutionary instant file access system.

**Usage**:
```bash
/map-codebase              # Load existing map (instant)
/map-codebase --rebuild    # Rebuild from scratch (~30 seconds)
/map-codebase --recent     # Focus on recent changes only
```

**What it does**:
- Scans entire codebase structure
- Creates semantic file mapping
- Enables instant file location
- Provides surgical precision for development

**When to use**:
- **First time**: Run `--rebuild` once to create the map
- **Future sessions**: Just `/map-codebase` for instant loading
- **After major changes**: Run `--rebuild` to update
- **Quick updates**: Use `--recent` for incremental updates

**Output**:
```
🗺️ Codebase Mapping Complete
📁 Files indexed: 347
📊 Directories: 52
⚡ Load time: 0.3s (instant!)
```

**Benefits**:
- ✅ Claude knows exact file locations
- ✅ No more "Where is X file?" questions
- ✅ Instant file access
- ✅ Perfect for large codebases

---

## 💾 Memory Management

### `/memory-sync`

Full memory bank synchronization.

**Usage**:
```bash
/memory-sync              # Smart sync based on session activity
/memory-sync --full       # Full synchronization (all memory files)
/memory-sync --quick      # Quick sync (activeContext.md only)
```

**What it does**:
- Analyzes session activity and changes
- Updates all relevant memory files
- Appends timestamped entries
- Preserves full history

**When to use**:
- After completing major features
- After making technical decisions
- At major milestones
- End of productive sessions

**Updates**:
- ✅ activeContext.md → Session summary, achievements, blockers
- ✅ progress.md → Sprint status, completed tasks
- ✅ decisionLog.md → Technical decisions made
- ✅ systemPatterns.md → New patterns discovered

**Example**:
```
User: /memory-sync

Claude: Synchronizing memory bank...

✅ activeContext.md updated
   - Added: "Completed authentication feature"
   - Updated focus: "Building user profile page"

✅ progress.md updated
   - Moved "JWT auth" to completed
   - Added "Profile UI" to in-progress

✅ decisionLog.md updated
   - ADR-20251010-01: Use bcrypt for password hashing

Memory sync complete! Context preserved for next session.
```

---

### `/context-update`

Real-time context updates without full sync.

**Usage**:
```bash
/context-update                              # Interactive mode
/context-update focus "what you're doing"    # Update current focus
/context-update blocker "issue description"  # Add blocker
/context-update priority "next task"         # Add priority
/context-update achievement "what completed" # Record achievement
```

**What it does**:
- Quick targeted updates to activeContext.md
- No full memory analysis needed
- Instant context reflection
- Real-time tracking

**When to use**:
- Starting new work
- Hitting blockers
- Completing tasks
- Changing focus

**Examples**:
```bash
# Starting new feature
/context-update focus "Building user authentication with JWT"

# Hit a blocker
/context-update blocker "API rate limiting on login endpoint"

# Completed something
/context-update achievement "User registration endpoint complete"

# Next priority
/context-update priority "Add email verification flow"
```

---

### `/umb`

Quick manual sync with note.

**Usage**:
```bash
/umb "Your note here"
```

**What it does**:
- Fast memory bank update
- Appends note to activeContext.md
- Timestamps the entry
- No analysis required

**When to use**:
- Need quick sync without waiting
- Want to leave a note for next session
- Simple status update

**Example**:
```bash
/umb "Completed authentication feature, starting profile page next"
```

**Output**:
```
✅ Memory bank updated
📝 Note added to activeContext.md
🕐 Timestamp: 2025-10-10 14:30:00 UTC
```

---

### `/memory-cleanup`

Archive old data to prevent memory bloat.

**Usage**:
```bash
/memory-cleanup              # Normal cleanup (keep last 5 updates)
/memory-cleanup --dry-run    # Preview what would be cleaned
/memory-cleanup --full       # Aggressive cleanup (keep last 3)
```

**What it does**:
- Archives old session updates
- Keeps recent history (last 5 or 3 updates)
- Moves old data to `.claude/archive/`
- Reduces activeContext.md size
- Prevents "Prompt is too long" errors

**When to use**:
- When notified by intelligent notification system
- After high-activity sessions (50+ ops)
- When activeContext.md > 200 lines
- Preventively every few weeks

**Impact**:
- **~60% token reduction** in context files
- **No data loss** - everything archived
- **Perfect continuity** - recent work preserved

**Example Output**:
```
🧹 Memory Cleanup Started

📊 Before:
   activeContext.md: 215 lines
   Session updates: 12 entries

🗑️ Archiving:
   - Session updates 1-7 (archived)
   - Keeping updates 8-12 (last 5)

✅ After:
   activeContext.md: 87 lines
   Archived: .claude/archive/activeContext-2025-10-10.md

Result: 60% reduction, all data preserved!
```

---

## 📚 Other Commands

### `/init-memory-bank`

Initialize memory bank with auto-populated context.

**Usage**:
```bash
/init-memory-bank           # Initialize with detected context
/init-memory-bank --dry-run # Preview without creating files
```

**What it does**:
- Auto-detects project type
- Creates all memory files from templates
- Populates with detected information
- Sets up initial structure

**When to use**:
- First-time setup (if not using installer)
- Resetting memory bank
- Starting fresh

---

## 🎯 Command Workflows

### Starting a New Feature

```bash
# 1. Update your focus
/context-update focus "Building user authentication system"

# 2. Map codebase (if not done)
/map-codebase

# 3. Start coding
"Create JWT authentication for login endpoint"
```

### Hitting a Blocker

```bash
# Record the blocker
/context-update blocker "API rate limiting on external service"

# Continue with workaround or other tasks
```

### Completing a Feature

```bash
# Record achievement
/context-update achievement "Completed user authentication with JWT"

# Full sync to preserve context
/memory-sync

# Update focus
/context-update focus "Starting user profile feature"
```

### End of Session

```bash
# Optional: Manual sync with note
/umb "Good progress on auth, profile page next"

# Close Claude Code
# (Stop hook auto-saves context)
```

### High Activity Session

```bash
# After notification: "📊 Activity: 47 ops. Consider /memory-cleanup"
/memory-cleanup --dry-run  # Preview changes

# If looks good
/memory-cleanup  # Execute cleanup
```

### Weekly Maintenance

```bash
# Full memory sync
/memory-sync --full

# Cleanup old data
/memory-cleanup

# Rebuild codebase map (if many changes)
/map-codebase --rebuild
```

---

## 🔄 Command Comparison

| Command | Speed | Scope | When to Use |
|---------|-------|-------|-------------|
| `/context-update` | ⚡ Instant | Single item | Real-time updates |
| `/umb` | ⚡ Fast | Quick note | End of task |
| `/memory-sync` | 🔄 Medium | Full analysis | After features |
| `/memory-cleanup` | 🧹 Medium | Archive old | When notified |
| `/map-codebase` | 🗺️ Instant* | File access | *After first rebuild |

---

## 💡 Command Tips

### DO ✅

- Use `/context-update` frequently during development
- Run `/memory-cleanup` when notified
- Use `/memory-sync` at major milestones
- Run `/map-codebase --rebuild` once per project
- Trust the automatic hooks

### DON'T ❌

- Don't run `/memory-sync --full` after every change (overkill)
- Don't ignore `/memory-cleanup` notifications (causes bloat)
- Don't rebuild map constantly (once is enough)
- Don't manually edit memory files during active session

---

## 🚨 Troubleshooting Commands

### "Commands not recognized"

**Solution**:
```bash
# Check hooks are executable
chmod +x .claude/hooks/*.sh

# Verify settings.json exists
ls .claude/settings.json
```

### "Memory sync taking too long"

**Solution**:
```bash
# Use quick sync instead
/memory-sync --quick

# Or use targeted update
/context-update focus "current work"
```

### "Codebase map not loading"

**Solution**:
```bash
# Rebuild the map
/map-codebase --rebuild

# Check file exists
ls .claude/memory/codebase-map.json
```

---

## 📊 Command Output Examples

### Successful Command

```
✅ Command executed successfully
📝 Updated: activeContext.md
🕐 Timestamp: 2025-10-10 14:30:00 UTC
```

### With Notification

```
✅ Context updated

💡 High activity session (42 ops). Consider /memory-sync
```

### Error Handling

```
❌ Command failed: File not found
💡 Try running: /init-memory-bank
```

---

## 🎯 Advanced Usage

### Chaining Workflows

```bash
# Complete feature → sync → cleanup → new focus
/context-update achievement "Auth complete"
/memory-sync
/memory-cleanup
/context-update focus "Starting profile feature"
```

### Dry-Run Testing

```bash
# Preview cleanup before executing
/memory-cleanup --dry-run

# Check output, then execute
/memory-cleanup
```

### Strategic Mapping

```bash
# Initial project setup
/map-codebase --rebuild

# Daily work (instant load)
/map-codebase

# After refactoring (update map)
/map-codebase --rebuild

# Quick check recent changes
/map-codebase --recent
```

---

<div style="text-align: center; margin-top: 50px;">
  <h3>Need installation help?</h3>
  <a class="btn btn-success" href="{{ '/installation' | relative_url }}">Installation Guide →</a>
</div>
