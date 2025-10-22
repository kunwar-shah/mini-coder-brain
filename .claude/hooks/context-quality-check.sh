#!/usr/bin/env bash
set -u

# Philosophy: Graceful degradation - prefer fallback over failure

ROOT="${CLAUDE_PROJECT_DIR:-.}"
LIB="$ROOT/.claude/hooks/lib/hook-patterns.sh"

# Source bulletproof patterns library
source "$LIB"

# Setup safe exit trap (CRITICAL: ensures we always exit 0)
setup_safe_exit_trap

# Context Quality Check Hook v1.0
# Runs on session-start to validate memory bank quality
# Shows warning if context quality is below recommended threshold

ROOT="${CLAUDE_PROJECT_DIR:-.}"
MB="$ROOT/.claude/memory"
CACHE="$ROOT/.claude/cache"

# Quality check cache (skip if recently checked)
QUALITY_CACHE="$CACHE/context-quality.json"
QUALITY_CHECK_INTERVAL=86400  # 24 hours

# Check if we should skip (checked within last 24h)
if [ -f "$QUALITY_CACHE" ]; then
  cache_age=$(( $(date +%s) - $(stat -c %Y "$QUALITY_CACHE" 2>/dev/null || echo 0) ))
  if [ "$cache_age" -lt "$QUALITY_CHECK_INTERVAL" ]; then
    # Recently checked, skip
    exit 0
  fi
fi

# === VALIDATION FUNCTIONS ===

validate_product_context() {
  local file="$MB/productContext.md"
  local score=0
  local max_score=70
  local issues=()

  if [ ! -f "$file" ]; then
    echo "0:70:productContext.md missing"
    return
  fi

  local content=$(cat "$file")

  # Check 1: Project name not placeholder (10 points)
  if echo "$content" | grep -q "^# Product Context — \[PROJECT_NAME\]"; then
    issues+=("Project name is placeholder")
  elif echo "$content" | grep -q "^# Product Context — "; then
    score=$((score + 10))
  else
    issues+=("Project name missing")
  fi

  # Check 2: Description has content (10 points)
  local desc_lines=$(echo "$content" | sed -n '/## Project Overview/,/##/p' | grep -v "^##" | grep -v "^\[" | wc -l)
  if [ "$desc_lines" -gt 2 ]; then
    score=$((score + 10))
  else
    issues+=("Project description too short")
  fi

  # Check 3: Tech stack (15 points)
  local tech_count=$(echo "$content" | sed -n '/## Technology Stack/,/##/p' | grep "^-" | wc -l)
  if [ "$tech_count" -ge 3 ]; then
    score=$((score + 15))
  else
    issues+=("Tech stack incomplete ($tech_count/3 items)")
  fi

  # Check 4: Core features (15 points)
  local feature_count=$(echo "$content" | sed -n '/### Core Features/,/###/p' | grep "^-" | wc -l)
  if [ "$feature_count" -ge 2 ]; then
    score=$((score + 15))
  else
    issues+=("Core features incomplete ($feature_count/2 required)")
  fi

  # Check 5: Architecture mentioned (10 points)
  if echo "$content" | grep -qi "architecture" && ! echo "$content" | grep -q "\[ARCHITECTURE\]"; then
    score=$((score + 10))
  fi

  # Check 6: Development goals (5 points)
  if echo "$content" | grep -q "## Development Goals" || echo "$content" | grep -q "## Goals"; then
    score=$((score + 5))
  fi

  # Check 7: Success metrics (5 points)
  if echo "$content" | grep -q "## Success Metrics" || echo "$content" | grep -q "Success"; then
    score=$((score + 5))
  fi

  # Return: score:maxScore:issue1,issue2,...
  local issues_str=$(IFS=,; echo "${issues[*]}")
  echo "$score:$max_score:$issues_str"
}

validate_system_patterns() {
  local file="$MB/systemPatterns.md"
  local score=0
  local max_score=30

  if [ ! -f "$file" ]; then
    echo "0:30:systemPatterns.md missing"
    return
  fi

  local content=$(cat "$file")
  local lines=$(wc -l < "$file")

  # Has content (not just template)
  if [ "$lines" -gt 30 ]; then
    score=$((score + 10))
  fi

  # Has architectural principles
  if echo "$content" | grep -qi "principle"; then
    score=$((score + 10))
  fi

  # Has testing patterns
  if echo "$content" | grep -qi "test"; then
    score=$((score + 5))
  fi

  # Has error handling
  if echo "$content" | grep -qi "error"; then
    score=$((score + 5))
  fi

  echo "$score:$max_score:"
}

validate_active_context() {
  local file="$MB/activeContext.md"
  local score=0
  local max_score=25

  if [ ! -f "$file" ]; then
    echo "0:25:activeContext.md missing"
    return
  fi

  local content=$(cat "$file")

  # Has current focus
  if echo "$content" | grep -q "## 🎯 Current Focus"; then
    local focus_content=$(echo "$content" | sed -n '/## 🎯 Current Focus/,/##/p' | grep -v "^##" | grep -v "\[" | wc -l)
    if [ "$focus_content" -gt 0 ]; then
      score=$((score + 10))
    fi
  fi

  # Has recent achievements
  if echo "$content" | grep -q "## ✅ Recent Achievements"; then
    score=$((score + 5))
  fi

  # Has next priorities
  if echo "$content" | grep -q "## 🚀 Next Priorities"; then
    score=$((score + 5))
  fi

  # Has blockers section
  if echo "$content" | grep -q "## 🔒 Current Blockers"; then
    score=$((score + 5))
  fi

  echo "$score:$max_score:"
}

validate_progress() {
  local file="$MB/progress.md"
  local score=0
  local max_score=25

  if [ ! -f "$file" ]; then
    echo "0:25:progress.md missing"
    return
  fi

  local content=$(cat "$file")

  # Has required sections
  if echo "$content" | grep -q "COMPLETED"; then
    score=$((score + 5))
  fi
  if echo "$content" | grep -q "IN PROGRESS"; then
    score=$((score + 5))
  fi
  if echo "$content" | grep -q "PENDING"; then
    score=$((score + 5))
  fi

  # Current phase defined
  if echo "$content" | grep -q "Current Phase"; then
    score=$((score + 5))
  fi

  # Has completed tasks
  if echo "$content" | grep -q "✅"; then
    score=$((score + 5))
  fi

  echo "$score:$max_score:"
}

check_project_structure() {
  local file="$MB/project-structure.json"
  local score=0
  local max_score=10

  if [ -f "$file" ]; then
    # Check if valid JSON
    if jq empty "$file" 2>/dev/null; then
      score=10
    else
      score=5  # Exists but invalid
    fi
  fi

  echo "$score:$max_score:"
}

# === RUN VALIDATION ===

# Validate each component
product_result=$(validate_product_context)
patterns_result=$(validate_system_patterns)
active_result=$(validate_active_context)
progress_result=$(validate_progress)
structure_result=$(check_project_structure)

# Parse results
product_score=$(echo "$product_result" | cut -d: -f1)
product_max=$(echo "$product_result" | cut -d: -f2)
product_issues=$(echo "$product_result" | cut -d: -f3)

patterns_score=$(echo "$patterns_result" | cut -d: -f1)
patterns_max=$(echo "$patterns_result" | cut -d: -f2)

active_score=$(echo "$active_result" | cut -d: -f1)
active_max=$(echo "$active_result" | cut -d: -f2)

progress_score=$(echo "$progress_result" | cut -d: -f1)
progress_max=$(echo "$progress_result" | cut -d: -f2)

structure_score=$(echo "$structure_result" | cut -d: -f1)
structure_max=$(echo "$structure_result" | cut -d: -f2)

# Calculate total
total_score=$((product_score + patterns_score + active_score + progress_score + structure_score))
total_max=$((product_max + patterns_max + active_max + progress_max + structure_max))

# Calculate percentage
if [ "$total_max" -gt 0 ]; then
  percentage=$((total_score * 100 / total_max))
else
  percentage=0
fi

# Cache result
ensure_dir "$CACHE"  # SAFE: never crash
cat > "$QUALITY_CACHE" <<EOF
{
  "timestamp": "$(date --iso-8601=seconds)",
  "score": $total_score,
  "max": $total_max,
  "percentage": $percentage,
  "components": {
    "productContext": { "score": $product_score, "max": $product_max },
    "systemPatterns": { "score": $patterns_score, "max": $patterns_max },
    "activeContext": { "score": $active_score, "max": $active_max },
    "progress": { "score": $progress_score, "max": $progress_max },
    "structure": { "score": $structure_score, "max": $structure_max }
  }
}
EOF

# === DETERMINE OUTPUT ===

warning=""

# CRITICAL: Below 40% (60 points)
if [ "$percentage" -lt 40 ]; then
  warning="🔴 Context Quality: $percentage% (BELOW MINIMUM)
CRITICAL: Mini-CoderBrain won't work effectively!

Missing:
$product_issues

Action Required: Run /init-memory-bank to initialize context properly."

# WARNING: 40-60% (60-90 points)
elif [ "$percentage" -lt 60 ]; then
  warning="⚠️  Context Quality: $percentage% (MINIMUM)
Mini-CoderBrain will work but with limited effectiveness.

Consider running /validate-context to see what's missing."

# NOTICE: 60-80% (90-120 points)
elif [ "$percentage" -lt 80 ]; then
  # Silent - good enough, no warning needed
  :

# OPTIMAL: 80%+ (120+ points)
else
  # Silent - excellent, no warning needed
  :
fi

# === OUTPUT (Only if warning exists) ===

if [ -n "$warning" ]; then
  # Output warning to additionalContext (will be shown to user)
  cat <<EOF
{
  "decision": "approve",
  "reason": "Session starting with context quality check",
  "additionalContext": "$warning"
}
EOF
else
  # No warning, approve silently
  cat <<EOF
{
  "decision": "approve",
  "reason": "Context quality check passed"
}
EOF
fi

# CRITICAL: Always exit 0, never crash the session
safe_exit
