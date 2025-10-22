#!/usr/bin/env bash
# Assertion helpers for integration tests

assert_exit_zero() {
  local exit_code="$1"
  local test_name="$2"

  if [ "$exit_code" -eq 0 ]; then
    echo "✅ PASS: $test_name"
    return 0
  else
    echo "❌ FAIL: $test_name (exit code: $exit_code)"
    return 1
  fi
}

assert_file_exists() {
  local file="$1"
  local test_name="$2"

  if [ -f "$file" ]; then
    echo "✅ PASS: $test_name"
    return 0
  else
    echo "❌ FAIL: $test_name (file not found: $file)"
    return 1
  fi
}

assert_string_contains() {
  local haystack="$1"
  local needle="$2"
  local test_name="$3"

  if echo "$haystack" | grep -q "$needle"; then
    echo "✅ PASS: $test_name"
    return 0
  else
    echo "❌ FAIL: $test_name (string not found: $needle)"
    return 1
  fi
}

assert_equals() {
  local expected="$1"
  local actual="$2"
  local test_name="$3"

  if [ "$expected" = "$actual" ]; then
    echo "✅ PASS: $test_name"
    return 0
  else
    echo "❌ FAIL: $test_name (expected: $expected, got: $actual)"
    return 1
  fi
}
