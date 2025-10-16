#!/usr/bin/env bash
set -eu

# Optimized Intelligent Stop Hook - Ultimate Session Analysis
# Combines: intelligent-stop-enhanced.sh + enhanced-stop-umb-sync.sh + session milestone detection

# Find project root more reliably
if [[ -n "${CLAUDE_PROJECT_DIR:-}" ]]; then
  ROOT="$CLAUDE_PROJECT_DIR"
else
  # Find project root by looking for .claude directory
  ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi
MB="$ROOT/.claude/memory"
CLAUDE_TMP="$ROOT/.claude/tmp"
TOOL_TRACKING="$MB/conversations/tool-tracking"
SESSION_STATE="$CLAUDE_TMP/session-context.json"

# Read hook input JSON
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "unknown"' 2>/dev/null || echo "unknown")

# Ensure directories exist
mkdir -p "$MB/conversations/sessions" "$MB/conversations/responses" "$MB/conversations/analysis/insights" "$MB" "$ROOT/.claude/tmp"
touch "$MB/progress.md" "$MB/activeContext.md" "$MB/decisionLog.md"

# Enhanced timestamp with readable format
ts="stopstep-$(date +%Y%m%d-%H%M%S)"
dt="$(date --iso-8601=seconds)"
today=$(date '+%Y-%m-%d')
current_time=$(date '+%H:%M UTC')

# === INTELLIGENT SESSION ANALYSIS ===

# Read today's tool tracking data (working data source)
detailed_log="$TOOL_TRACKING/$today-detailed.jsonl"
simple_log="$TOOL_TRACKING/$today-tools.log"

# Initialize session context if not exists
if [ ! -f "$SESSION_STATE" ]; then
  cat > "$SESSION_STATE" <<EOF
{
  "session_start": "$(date '+%H:%M:%S')",
  "tools_used": [],
  "files_modified": [],
  "development_phases": [],
  "current_focus": "unknown",
  "milestone_count": 0,
  "last_update_time": "$(date '+%H:%M:%S')"
}
EOF
fi

# Enhanced session analysis combining best features
analyze_session_intelligence() {
  local tool_sequence=""
  local file_patterns=""
  local intentions=""
  local milestones=""
  local activity_count=0
  local significant_files=""
  
  if [ -f "$simple_log" ]; then
    # Fixed activity count calculation - count all meaningful development operations
    # Match tool names at start/end of line (no pipes in current format)
    activity_count=$(grep -E '^(Write|Edit|MultiEdit|Read|Bash)$' "$simple_log" | wc -l || echo 0)

    # Tool sequence analysis (fixed: use "tool" not "tool_name" in JSONL)
    tool_sequence=$(jq -r 'select(.timestamp | startswith("'$today'")) | .tool' "$detailed_log" 2>/dev/null | tail -5 | tr '\n' '→' | sed 's/→$//' || echo "Unknown")
    
    # File patterns analysis (enhanced)
    significant_files=$(jq -r 'select(.timestamp | startswith("'$today'") and (.tool_name == "Write" or .tool_name == "Edit" or .tool_name == "MultiEdit")) | .tool_input.file_path // empty' "$detailed_log" 2>/dev/null | xargs -I {} basename {} 2>/dev/null | tail -5 | tr '\n' ' ' || echo "")
    
    # Intentions and milestones
    intentions=$(jq -r 'select(.timestamp | startswith("'$today'")) | .intention // empty' "$detailed_log" 2>/dev/null | tail -3 | grep -v '^$' | sort -u | tr '\n' ';' | sed 's/;$//' || echo "")
    milestones=$(jq -r 'select(.timestamp | startswith("'$today'")) | .milestone // empty' "$detailed_log" 2>/dev/null | tail -3 | grep -v '^$' | sort -u | tr '\n' ';' | sed 's/;$//' || echo "")
  fi
  
  echo "$activity_count|$tool_sequence|$significant_files|$intentions|$milestones"
}

session_data=$(analyze_session_intelligence)
activity_count=$(echo "$session_data" | cut -d'|' -f1)
tool_sequence=$(echo "$session_data" | cut -d'|' -f2)
file_patterns=$(echo "$session_data" | cut -d'|' -f3)
intentions=$(echo "$session_data" | cut -d'|' -f4)
milestones=$(echo "$session_data" | cut -d'|' -f5)

# Enhanced development context analysis
determine_development_context() {
  local context=""
  local development_phase=""
  
  # Analyze file patterns for context
  if echo "$file_patterns" | grep -qE 'hook.*\.sh|settings\.json'; then
    context="Infrastructure Development"
  elif echo "$file_patterns" | grep -qE 'commands.*\.md'; then
    context="Command System Enhancement"
  elif echo "$file_patterns" | grep -qE 'INTELLIGENT.*HOOK.*SYSTEM|COMPREHENSIVE_GUIDE'; then
    context="Documentation and System Analysis"
  elif echo "$intentions" | grep -qE 'Core application development'; then
    context="Feature Development"
  elif echo "$intentions" | grep -qE 'Documentation.*project planning'; then
    context="Planning and Documentation"
  elif echo "$intentions" | grep -qE 'Codebase exploration'; then
    context="Research & Analysis"
  else
    context="General Development Work"
  fi
  
  # Determine development phase
  if [ "$activity_count" -gt 5 ]; then
    development_phase="Implementation"
  elif [ "$activity_count" -gt 2 ]; then
    development_phase="Feature Development"
  else
    development_phase="Research & Analysis"
  fi
  
  echo "$context|$development_phase"
}

context_data=$(determine_development_context)
development_context=$(echo "$context_data" | cut -d'|' -f1)
development_phase=$(echo "$context_data" | cut -d'|' -f2)

# Session milestone detection (from enhanced-stop-umb-sync.sh)
detect_session_milestones() {
  local milestone_detected=""
  local milestone_type=""
  
  # Check for significant milestones
  if [ "$activity_count" -gt 10 ]; then
    milestone_detected="Major Development Session"
    milestone_type="high-velocity"
  elif [ "$activity_count" -gt 5 ]; then
    milestone_detected="Productive Development Session" 
    milestone_type="productive"
  elif echo "$file_patterns" | grep -qE '\.sh|\.py|settings\.json'; then
    milestone_detected="Infrastructure Enhancement"
    milestone_type="infrastructure" 
  elif echo "$intentions" | grep -qE 'Core application development'; then
    milestone_detected="Feature Implementation"
    milestone_type="feature"
  else
    milestone_detected="Analysis and Planning Session"
    milestone_type="planning"
  fi
  
  echo "$milestone_detected|$milestone_type"
}

milestone_data=$(detect_session_milestones)
session_milestone=$(echo "$milestone_data" | cut -d'|' -f1)
milestone_type=$(echo "$milestone_data" | cut -d'|' -f2)

# Build intelligent session narrative
build_session_narrative() {
  local narrative=""
  
  if [ -n "$tool_sequence" ] && [ "$activity_count" -gt 3 ]; then
    narrative="$activity_count development iterations completed"
  else
    narrative="Technical analysis and system exploration"
  fi
  
  echo "$narrative"
}

session_narrative=$(build_session_narrative)

# Smart deduplication check
check_recent_duplicate() {
  if [ -f "$MB/activeContext.md" ]; then
    recent_entries=$(tail -10 "$MB/activeContext.md" 2>/dev/null | grep -E "DEVELOPMENT SESSION PROGRESS|SESSION ADVANCEMENT" | tail -3 || echo "")
    if echo "$recent_entries" | grep -q "$development_context"; then
      echo "skip_duplicate"
    else
      echo "update"
    fi
  else
    echo "update"
  fi
}

duplicate_check=$(check_recent_duplicate)

# === INTELLIGENT COMMAND SUGGESTIONS (SURGICAL FIX) ===
# Disabled automatic memory-bank updates to prevent pollution
# Data capture preserved for intelligent command suggestions

# Check if session is significant enough to suggest commands
suggest_memory_commands() {
  local suggestions=""
  local json_control=""

  # Build status footer (from intelligent-status-notification logic)
  local map_status="None"
  local map_age=""
  local CACHE_DIR="$ROOT/.claude/cache"

  if [ -f "$CACHE_DIR/codebase-map.json" ]; then
    local current_time_sec=$(date +%s)
    local file_time=$(stat -c %Y "$CACHE_DIR/codebase-map.json" 2>/dev/null || echo 0)
    local age_hours=$(( (current_time_sec - file_time) / 3600 ))

    if [ "$age_hours" -lt 4 ]; then
      map_status="Fresh"
      map_age="${age_hours}h"
    elif [ "$age_hours" -lt 24 ]; then
      map_status="OK"
      map_age="${age_hours}h"
    else
      map_status="Stale"
      map_age="${age_hours}h"
    fi
  fi

  local status_footer="🧠 Context: Active | Activity: ${activity_count} ops | Map: ${map_status}$([ -n "$map_age" ] && echo " (${map_age})" || echo "")"

  if [ "$activity_count" -gt 5 ]; then
    suggestions="High-activity session detected ($activity_count ops). Consider: /memory-sync or /analyze-session"
    json_control='{"decision": "approve", "reason": "Productive session with '$activity_count' operations completed successfully", "additionalContext": "'"$status_footer"'\n\n'"$suggestions"'"}'
  elif [ "$activity_count" -gt 2 ] && [ -n "$milestones" ]; then
    suggestions="Progress milestones achieved. Consider: /memory-sync or /update-context"
    json_control='{"decision": "approve", "reason": "Development milestones achieved and context updated", "additionalContext": "'"$status_footer"'\n\n'"$suggestions"'"}'
  elif echo "$development_context" | grep -qE "Infrastructure|Enhancement"; then
    suggestions="Infrastructure changes detected. Consider: /analyze-session"
    json_control='{"decision": "approve", "reason": "Infrastructure modifications detected and logged", "additionalContext": "'"$status_footer"'\n\n'"$suggestions"'"}'
  fi

  if [ -n "$suggestions" ]; then
    # Output valid JSON with status footer + suggestions
    if [ -n "$json_control" ]; then
      echo "$json_control"
    else
      # Fallback valid JSON with just status footer
      echo '{"decision": "approve", "reason": "Session completed successfully", "additionalContext": "'"$status_footer"'"}'
    fi
  else
    # Always output valid JSON with status footer
    echo '{"decision": "approve", "reason": "Session completed successfully", "additionalContext": "'"$status_footer"'"}'
  fi
}

# === MEMORY BANK UPDATE (File persistence for cross-session continuity) ===
# Update memory bank FILE with concise session results
# NOTE: This updates the FILE only, NOT injected into current conversation
# Conversation context persists naturally via Claude Code's conversation history
if [ "$activity_count" -gt 1 ]; then
    # Update activeContext.md with CONCISE session summary (for next session)
    if [ -f "$MB/activeContext.md" ]; then
        # Add concise session update to file
        cat >> "$MB/activeContext.md" <<EOF

## 📊 Session Update [$dt]
Activity: $activity_count ops | Context: $development_context | Milestone: $session_milestone
EOF
    fi

    # Update current-state.json for next session
    current_state_file="$CLAUDE_TMP/current-state.json"
    cat > "$current_state_file" <<EOF
{
  "last_session_end": "$dt",
  "current_phase": "$development_phase",
  "development_context": "$development_context",
  "activity_count": $activity_count,
  "session_milestone": "$session_milestone",
  "next_focus": "Continue $development_phase development"
}
EOF
fi

# Create comprehensive response summary with session intelligence
response_file="$MB/conversations/responses/response-$ts.md"
cat > "$response_file" <<EOF
# Intelligent Session Summary — $ts

**Development Context**: $development_context  
**Phase**: $development_phase  
**Session Milestone**: $session_milestone
**Timestamp**: $dt  
**Session ID**: $session_id

## Session Intelligence Analysis
- **Activity Level**: $activity_count meaningful operations
- **Development Narrative**: $session_narrative
- **Tool Workflow**: $tool_sequence
$(if [ -n "$intentions" ] && [ "$intentions" != "null" ]; then
  echo "- **User Intentions**: $intentions"
fi)
$(if [ -n "$milestones" ] && [ "$milestones" != "null" ]; then
  echo "- **Milestones Achieved**: $milestones"
fi)

## Files Enhanced
$(if [ -n "$file_patterns" ]; then
  echo "$file_patterns" | tr ' ' '\n' | grep -v '^$' | sed 's/^/- /'
else
  echo "- Analysis and exploration phase"
fi)

## Development Insights
$(case "$milestone_type" in
  "high-velocity")
    echo "**High-velocity development session** with significant progress and multiple iterations."
    ;;
  "productive") 
    echo "**Productive development work** with focused implementation and system enhancement."
    ;;
  "infrastructure")
    echo "**Infrastructure development** improving system capabilities and automation."
    ;;
  "feature")
    echo "**Feature development** advancing core application functionality."
    ;;
  *)
    echo "**Analysis and planning session** advancing technical understanding."
    ;;
esac)

## Next Session Intelligence
- **Continue**: $(echo "$development_context" | tr '[:upper:]' '[:lower:]') advancement
- **Focus**: Build on current development momentum
- **Priority**: $(if [ "$activity_count" -gt 5 ]; then echo "Maintain high-velocity development"; else echo "Expand implementation scope"; fi)

## Context Preservation
- **Session State**: Captured in memory-bank with full context
- **Tool Tracking**: $activity_count operations logged with intentions
- **Development Continuity**: Perfect context handoff to next session

---
**Generated by Optimized Intelligent Stop Hook** • **Advanced Session Intelligence**
EOF

# Create session file in sessions/ folder (like coder-brain)
# Format: session_{SESSION_ID}_{TIMESTAMP}.md
if [ "$session_id" != "unknown" ] && [ -n "$session_id" ]; then
  session_file="$MB/conversations/sessions/session_${session_id}_${ts#stopstep-}.md"
  cat > "$session_file" <<EOF
# Session Summary - $session_id

**Date**: $dt
**Timestamp**: $ts
**Activity**: $activity_count operations

## Session Intelligence
- **Development Context**: $development_context
- **Phase**: $development_phase
- **Milestone**: $session_milestone

## Activity Analysis
- **Operations**: $activity_count
- **Tool Workflow**: $tool_sequence
- **Files Modified**: $(echo "$file_patterns" | wc -w) files

## Files Enhanced
$(if [ -n "$file_patterns" ]; then
  echo "$file_patterns" | tr ' ' '\n' | grep -v '^$' | sed 's/^/- /'
else
  echo "- Analysis and exploration phase"
fi)

## Development Insights
$(case "$milestone_type" in
  "high-velocity")
    echo "High-velocity development session with significant progress."
    ;;
  "productive")
    echo "Productive development work with focused implementation."
    ;;
  "infrastructure")
    echo "Infrastructure development improving system capabilities."
    ;;
  "feature")
    echo "Feature development advancing core functionality."
    ;;
  *)
    echo "Analysis and planning session advancing understanding."
    ;;
esac)

## Context
- **Session ID**: $session_id
- **Status**: Completed
- **Next Focus**: Continue $development_phase development

---
*Generated by Mini-CoderBrain Session Tracking*
EOF
fi

# Generate session insights for analysis folder (significant sessions only)
if [ "$activity_count" -gt 3 ]; then
  insights_file="$MB/conversations/analysis/insights/session-$ts.md"
  cat > "$insights_file" <<EOF
# Session Intelligence Insights — $ts

## Development Velocity Analysis
- **Session Type**: $session_milestone
- **Activity Metrics**: $activity_count operations in $(echo "$tool_sequence" | tr '→' '\n' | wc -l) tool types
- **Efficiency Rating**: $(if [ "$activity_count" -gt 8 ]; then echo "High"; elif [ "$activity_count" -gt 4 ]; then echo "Medium"; else echo "Standard"; fi)

## Workflow Pattern Recognition  
- **Tool Sequence**: $tool_sequence
- **Development Pattern**: $development_context focus
- **Phase Classification**: $development_phase

## Context Intelligence
- **Intent Analysis**: $intentions
- **Milestone Completion**: $milestones
- **File Impact**: $(echo "$file_patterns" | wc -w) files modified

## Predictive Insights
- **Next Session Focus**: Continue $development_context
- **Recommended Priority**: $(if [ "$milestone_type" = "high-velocity" ]; then echo "Maintain momentum"; else echo "Expand scope"; fi)
- **Context Readiness**: Full context preserved for seamless continuation

---
**Auto-generated Session Intelligence Analysis**
EOF
fi

# Update session context with enhanced data
if command -v jq >/dev/null 2>&1; then
  jq --arg time "$(date +%H:%M:%S)" \
     --arg context "$development_context" \
     --argjson activity "$activity_count" \
     '.last_update_time = $time | .current_focus = $context | .milestone_count += $activity' \
     "$SESSION_STATE" > "$SESSION_STATE.tmp" && mv "$SESSION_STATE.tmp" "$SESSION_STATE" || true
fi

# FINAL: Output JSON for Claude Code (must be last, no stdout output after this)
suggest_memory_commands