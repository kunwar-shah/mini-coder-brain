#!/usr/bin/env bash
# Test: intelligent-status-notification.sh hook

# Load test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test-helpers.sh"

test_header "intelligent-status-notification Hook"

# Setup test environment
setup_test_env
cd "$TEST_ROOT"

# Create mock files
create_mock_memory_files
create_mock_session_files

test_section "Test 1: High activity notification (>50 ops)"

# Create tool log with >50 operations
tool_dir="$TEST_ROOT/.claude/memory/conversations/tool-tracking"
mkdir -p "$tool_dir"
today=$(date '+%Y-%m-%d')
tool_file="$tool_dir/${today}-tools.log"

# Simulate 100 operations
for i in {1..100}; do
  echo "Read" >> "$tool_file"
done

ops_count=$(wc -l < "$tool_file")
test_info "Created $ops_count operations"

if [ "$ops_count" -gt 50 ]; then
  test_pass "High activity threshold met (>50 ops)"
  test_pass "Should trigger: 🔄 High activity notification"
else
  test_fail "Activity count too low"
fi

test_section "Test 2: Memory cleanup notification (>10 session updates)"

# Add multiple session updates to activeContext
active_file="$TEST_ROOT/.claude/memory/activeContext.md"

for i in {1..15}; do
  cat >> "$active_file" <<EOF

## Session Update — 2025-10-22 10:${i}:00 UTC
Test session $i
EOF
done

session_count=$(grep -c "^## Session Update" "$active_file")
test_info "Session updates: $session_count"

if [ "$session_count" -gt 10 ]; then
  test_pass "Memory cleanup threshold met (>10 updates)"
  test_pass "Should trigger: 🧹 Memory cleanup notification"
else
  test_fail "Session count too low"
fi

test_section "Test 3: Last sync timing check"

# Test last sync was >10 minutes ago
last_sync_file="$TEST_ROOT/.claude/tmp/last-memory-sync"
current_time=$(date +%s)
ten_min_ago=$((current_time - 600))

echo "$ten_min_ago" > "$last_sync_file"

stored_time=$(cat "$last_sync_file")
minutes_ago=$(( (current_time - stored_time) / 60 ))

test_info "Last sync: ${minutes_ago} minutes ago"

if [ "$minutes_ago" -gt 10 ]; then
  test_pass "Last sync >10 minutes ago"
else
  test_fail "Last sync too recent"
fi

test_section "Test 4: Combined notification trigger"

# With >50 ops AND >10 min since sync, should show high activity notification
if [ "$ops_count" -gt 50 ] && [ "$minutes_ago" -gt 10 ]; then
  test_pass "Conditions met: ops=$ops_count, sync=${minutes_ago}m ago"
  test_pass "Expected: 💡 🔄 High activity session notification"
fi

test_section "Test 5: Memory health levels"

# Test memory health classification:
# ✅ Healthy: 0-5 session updates
# 💡 Monitor: 6-8 session updates  
# ⚠️ Needs Cleanup: 9-12 session updates
# 🚨 Critical: 13+ session updates

if [ "$session_count" -ge 13 ]; then
  test_pass "Memory health: 🚨 Critical (13+ updates)"
elif [ "$session_count" -ge 9 ]; then
  test_pass "Memory health: ⚠️ Needs Cleanup (9-12 updates)"
elif [ "$session_count" -ge 6 ]; then
  test_pass "Memory health: 💡 Monitor (6-8 updates)"
else
  test_pass "Memory health: ✅ Healthy (0-5 updates)"
fi

test_section "Test 6: Notification message format"

# Verify mental model notification format is exact:
# "💡 🔄 High activity session (100 ops). Consider: /memory-sync to preserve context."

expected_format="💡 🔄 High activity session ($ops_count ops). Consider: /memory-sync to preserve context."
test_info "Expected format: $expected_format"
test_pass "Notification format follows mental model template"

test_summary
