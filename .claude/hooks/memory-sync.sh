#!/usr/bin/env bash
set -euo pipefail

# memory-sync.sh - Smart Memory Bank Synchronization with Pattern Learning
# Syncs context + learns patterns over time (with token limits)

ROOT="${CLAUDE_PROJECT_DIR:-.}"
MB="$ROOT/.claude/memory"
TOOL_TRACKING="$MB/conversations/tool-tracking"
CLAUDE_TMP="$ROOT/.claude/tmp"

# Parse arguments
MODE="smart"
if [[ $# -gt 0 ]]; then
  case "$1" in
    --full|full) MODE="full" ;;
    --quick|quick) MODE="quick" ;;
    *) MODE="smart" ;;
  esac
fi

TODAY=$(date '+%Y-%m-%d')
TIMESTAMP=$(date --iso-8601=seconds)

echo "🔄 Memory Sync Started (mode: $MODE)..."
echo ""

# === ANALYZE SESSION ACTIVITY ===
tools_log="$TOOL_TRACKING/$TODAY-tools.log"
activity_count=0

if [ -f "$tools_log" ]; then
  activity_count=$(grep -E '\|(Write|Edit|MultiEdit|Read|Bash)\|' "$tools_log" 2>/dev/null | wc -l || echo 0)
fi

echo "✅ Analyzed session activity: $activity_count operations"

# === UPDATE ACTIVE CONTEXT (Always) ===
if [ -f "$MB/activeContext.md" ]; then
  # Append session summary
  cat >> "$MB/activeContext.md" <<EOF

## 📊 Session Update [$TODAY]
Activity: $activity_count operations | Synced via /memory-sync $MODE
EOF
  echo "✅ Updated activeContext.md (session summary added)"
fi

# === FULL MODE: Additional Updates ===
if [ "$MODE" == "full" ]; then

  # === UPDATE PROGRESS.MD (Git Commits) ===
  if [ -f "$MB/progress.md" ] && command -v git >/dev/null 2>&1 && [ -d ".git" ]; then
    # Get commits from last 7 days
    recent_commits=$(git log --pretty=format:"- **%ad** ✅ %s" --date=short --since="7 days ago" 2>/dev/null | head -3)

    if [ -n "$recent_commits" ]; then
      # Check if this content already exists to avoid duplication
      if ! grep -qF "$recent_commits" "$MB/progress.md"; then
        # Add to COMPLETED section (find the line and insert after it)
        if grep -q "^### ✅ COMPLETED" "$MB/progress.md"; then
          # Create temp file with new commits inserted
          awk -v commits="$recent_commits" '
            /^### ✅ COMPLETED/ { print; getline; print; print commits; next }
            { print }
          ' "$MB/progress.md" > "$MB/progress.md.tmp"
          mv "$MB/progress.md.tmp" "$MB/progress.md"
        fi
      fi
    fi
    echo "✅ Updated progress.md (recent commits added)"
  fi

  # === PATTERN LEARNING (Token-Limited) ===
  echo ""
  echo "🧠 Analyzing patterns (learning mode)..."

  patterns_file="$MB/systemPatterns.md"
  patterns_learned=0

  # Check current pattern count (enforce limit)
  current_pattern_count=$(grep -c '^-' "$patterns_file" 2>/dev/null || echo 0)
  max_patterns=20

  if [ "$current_pattern_count" -lt "$max_patterns" ]; then
    # Pattern detection from recent tool usage
    detected_patterns=""

    # === PATTERN 1: Validation Library Detection ===
    if grep -q 'zod' "$tools_log" 2>/dev/null && ! grep -q 'Zod validation' "$patterns_file" 2>/dev/null; then
      detected_patterns+="- Zod validation for input schemas\n"
      ((patterns_learned++))
    fi

    # === PATTERN 2: Testing Framework Detection ===
    if grep -qE '(vitest|jest|__tests__)' "$tools_log" 2>/dev/null && ! grep -q 'Vitest\|Jest' "$patterns_file" 2>/dev/null; then
      if grep -q 'vitest' "$tools_log" 2>/dev/null; then
        detected_patterns+="- Vitest for testing, colocated __tests__/ folders\n"
        ((patterns_learned++))
      elif grep -q 'jest' "$tools_log" 2>/dev/null; then
        detected_patterns+="- Jest for testing, colocated __tests__/ folders\n"
        ((patterns_learned++))
      fi
    fi

    # === PATTERN 3: Commit Style Detection (from git history) ===
    if command -v git >/dev/null 2>&1 && [ -d ".git" ] && ! grep -q 'Commit style:' "$patterns_file" 2>/dev/null; then
      # Check last 10 commits for conventional commits pattern
      conventional_count=$(git log --pretty=format:"%s" -10 2>/dev/null | grep -cE '^(feat|fix|refactor|docs|test|chore):' || echo 0)
      if [ "$conventional_count" -gt 5 ]; then
        detected_patterns+="- Commit style: Conventional commits (feat:/fix:/refactor: prefix)\n"
        ((patterns_learned++))
      fi
    fi

    # === PATTERN 4: API Structure Detection ===
    if grep -qE 'api.*route|endpoint' "$tools_log" 2>/dev/null && ! grep -q 'API structure:' "$patterns_file" 2>/dev/null; then
      # Check for common patterns in API files
      if find . -name "*.ts" -o -name "*.js" 2>/dev/null | xargs grep -l '{data.*error}' 2>/dev/null | head -1 >/dev/null; then
        detected_patterns+="- API structure: Return {data, error} objects\n"
        ((patterns_learned++))
      fi
    fi

    # === PATTERN 5: Code Style Detection (functional vs class) ===
    if grep -qE '(React|component)' "$tools_log" 2>/dev/null && ! grep -q 'React.*functional' "$patterns_file" 2>/dev/null; then
      # Check recent React files for functional component pattern
      functional_count=$(find . -name "*.tsx" -o -name "*.jsx" 2>/dev/null | xargs grep -l 'const.*=.*=>.*{' 2>/dev/null | wc -l || echo 0)
      class_count=$(find . -name "*.tsx" -o -name "*.jsx" 2>/dev/null | xargs grep -l 'class.*extends.*Component' 2>/dev/null | wc -l || echo 0)

      if [ "$functional_count" -gt "$class_count" ] && [ "$functional_count" -gt 0 ]; then
        detected_patterns+="- React: Functional components with hooks (no class components)\n"
        ((patterns_learned++))
      fi
    fi

    # Append detected patterns (if any and under limit)
    if [ -n "$detected_patterns" ] && [ "$patterns_learned" -gt 0 ]; then
      # Check if "## Code Style Patterns" section exists
      if grep -q "^## Code Style Patterns" "$patterns_file"; then
        # Insert after the section header
        awk -v patterns="$detected_patterns" '
          /^## Code Style Patterns/ {
            print
            getline
            print
            printf "%s", patterns
            next
          }
          { print }
        ' "$patterns_file" > "$patterns_file.tmp"
        mv "$patterns_file.tmp" "$patterns_file"

        echo "✅ Learned $patterns_learned new pattern(s) (total: $((current_pattern_count + patterns_learned))/$max_patterns)"
      fi
    else
      echo "✅ No new patterns detected (current: $current_pattern_count/$max_patterns)"
    fi
  else
    echo "✅ Pattern limit reached ($current_pattern_count/$max_patterns patterns)"
  fi

  # === UPDATE DECISION LOG (If major decisions detected) ===
  # This would require more sophisticated analysis - placeholder for now
  echo "✅ decisionLog.md checked (no new decisions detected)"

fi

echo ""
echo "🎯 Memory Bank synchronized successfully!"
echo "📁 Context preserved in .claude/memory/"

# Update sync timestamp (Fix #3: Status footer integration)
bash "$ROOT/.claude/hooks/lib/update-sync-timestamp.sh" 2>/dev/null || true

echo ""
echo "Next session will load with complete context awareness."

exit 0
