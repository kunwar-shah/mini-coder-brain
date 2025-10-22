#!/usr/bin/env bash
# Hook Patterns Library - Bash implementation of Python hook patterns
# Adopted from claude-code-hooks-mastery repository
#
# Purpose: Provide bulletproof patterns that ensure hooks NEVER crash
# Philosophy: Graceful degradation - prefer fallback over failure

# ============================================================================
# PATTERN 1: Graceful Stdin Reading
# Python equivalent: json.loads(sys.stdin.read()) with try/except
# ============================================================================
read_stdin_safe() {
  local default="${1:-{}}"

  # Try to read stdin, provide fallback if it fails
  if [ -t 0 ]; then
    # stdin is a terminal (no data piped) - use default
    echo "$default"
  else
    # stdin has data - try to read it
    cat 2>/dev/null || echo "$default"
  fi
}

# ============================================================================
# PATTERN 2: Safe Directory Creation
# Python equivalent: Path().mkdir(parents=True, exist_ok=True)
# ============================================================================
ensure_dir() {
  local dir="$1"

  # Create directory and all parents, never fail
  mkdir -p "$dir" 2>/dev/null || true

  # Return 0 even if mkdir failed (maybe already exists)
  return 0
}

# ============================================================================
# PATTERN 3: Safe File Reading with Fallback
# Python equivalent: try: json.load(f) except: fallback_data
# ============================================================================
read_file_safe() {
  local file="$1"
  local fallback="${2:-}"

  # Check file exists and is readable
  if [ -f "$file" ] && [ -r "$file" ]; then
    # Try to read, fallback on any error
    cat "$file" 2>/dev/null || echo "$fallback"
  else
    # File doesn't exist or not readable - use fallback
    echo "$fallback"
  fi
}

# ============================================================================
# PATTERN 4: Safe File Writing (Never Crash)
# Python equivalent: with open(file, 'w') as f: f.write(data)
# ============================================================================
write_file_safe() {
  local file="$1"
  local content="$2"

  # Ensure parent directory exists
  local dir=$(dirname "$file")
  ensure_dir "$dir"

  # Try to write, suppress errors
  echo "$content" > "$file" 2>/dev/null || true

  return 0
}

# ============================================================================
# PATTERN 5: Timeout-Protected Command Execution
# Python equivalent: subprocess.run(..., timeout=5)
# ============================================================================
run_with_timeout() {
  local timeout_seconds="$1"
  shift

  # Check if timeout command exists
  if command -v timeout >/dev/null 2>&1; then
    # GNU timeout (Linux)
    timeout "$timeout_seconds" "$@" 2>/dev/null || true
  elif command -v gtimeout >/dev/null 2>&1; then
    # GNU timeout on macOS (via brew install coreutils)
    gtimeout "$timeout_seconds" "$@" 2>/dev/null || true
  else
    # No timeout available - run without timeout
    "$@" 2>/dev/null || true
  fi

  return 0
}

# ============================================================================
# PATTERN 6: Structured Logging to logs/
# Python equivalent: log_dir / 'hook_name.json' with json.dump()
# ============================================================================
log_hook_event() {
  local hook_name="$1"
  local event_type="${2:-event}"
  local log_dir="logs"

  # Ensure logs directory exists
  ensure_dir "$log_dir"

  # Create timestamp
  local timestamp=$(date --iso-8601=seconds 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S")

  # Write JSONL format (one JSON per line)
  local log_entry="{\"timestamp\":\"$timestamp\",\"hook\":\"$hook_name\",\"event\":\"$event_type\"}"
  echo "$log_entry" >> "$log_dir/${hook_name}.jsonl" 2>/dev/null || true

  return 0
}

# ============================================================================
# PATTERN 7: Safe Exit (Always Exit 0)
# Python equivalent: sys.exit(0) at end of try/except
# ============================================================================
safe_exit() {
  # CRITICAL: Hooks must NEVER crash the session
  # Always exit 0, even if internal errors occurred
  exit 0
}

# ============================================================================
# PATTERN 8: JSON Field Extraction (No jq dependency)
# Python equivalent: data.get('field', default)
# ============================================================================
extract_json_field() {
  local json="$1"
  local field="$2"
  local default="${3:-}"

  # Try to extract field using grep + sed (POSIX compatible)
  local value=$(echo "$json" | grep -o "\"$field\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" 2>/dev/null | head -1 | sed 's/.*"\([^"]*\)"$/\1/')

  # Return extracted value or default
  if [ -n "$value" ]; then
    echo "$value"
  else
    echo "$default"
  fi
}

# ============================================================================
# PATTERN 9: Check Command Exists (Before Using It)
# Python equivalent: if shutil.which('command')
# ============================================================================
command_exists() {
  local cmd="$1"

  command -v "$cmd" >/dev/null 2>&1
}

# ============================================================================
# PATTERN 10: Safe Git Operations (Never Fail)
# Python equivalent: subprocess.run(['git', ...], check=False)
# ============================================================================
git_safe() {
  # Run git command with timeout and error suppression
  if command_exists git; then
    run_with_timeout 5 git "$@"
  else
    # Git not available - return empty
    return 0
  fi
}

# ============================================================================
# PATTERN 11: Trap Handler (Ensure Exit 0 Even on Errors)
# Python equivalent: try/finally with sys.exit(0)
# ============================================================================
setup_safe_exit_trap() {
  # Trap all error signals and ensure we exit 0
  trap 'safe_exit' EXIT ERR INT TERM
}

# ============================================================================
# PATTERN 12: Validate Input Data
# Python equivalent: if not data or not isinstance(data, dict)
# ============================================================================
validate_json_input() {
  local json="$1"

  # Check if input looks like JSON (basic validation)
  if echo "$json" | grep -q '^[[:space:]]*{.*}[[:space:]]*$' 2>/dev/null; then
    return 0  # Valid-looking JSON
  else
    return 1  # Not JSON-like
  fi
}

# ============================================================================
# USAGE EXAMPLES
# ============================================================================
#
# Example 1: Safe hook skeleton
# #!/usr/bin/env bash
# set -eu
# source "$(dirname "$0")/lib/hook-patterns.sh"
# setup_safe_exit_trap
#
# input=$(read_stdin_safe)
# session_id=$(extract_json_field "$input" "session_id" "unknown")
# log_hook_event "my-hook" "started"
#
# # ... hook logic ...
#
# safe_exit
#
# Example 2: Safe file operations
# content=$(read_file_safe "$MB/activeContext.md" "No context available")
# write_file_safe "$CLAUDE_TMP/session-data" "$content"
#
# Example 3: Git operations with timeout
# branch=$(git_safe rev-parse --abbrev-ref HEAD)
#
# ============================================================================
# CRITICAL REMINDERS
# ============================================================================
# 1. ALWAYS source this library at start of hooks
# 2. ALWAYS use setup_safe_exit_trap after sourcing
# 3. ALWAYS use safe_exit at end of hooks
# 4. NEVER let operations fail without fallback
# 5. PREFER fallback/default over error propagation
# ============================================================================

# Self-test: Verify library loaded correctly
export HOOK_PATTERNS_LOADED="yes"
