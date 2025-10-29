#!/usr/bin/env bats
# shellcheck shell=bash

setup() {
  # Path to the gh-cat script
  GH_CAT="${BATS_TEST_DIRNAME}/../gh-cat"

  # Test repository that should exist
  TEST_REPO="jparise/gh-cat"

  # Known file in the test repository
  TEST_FILE="README.md"
}

# =============================================================================
# Help and Version Tests
# =============================================================================

@test "help flag prints usage" {
  run "$GH_CAT" -h
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: gh cat repo path"* ]]
}

@test "version flag prints version" {
  run "$GH_CAT" -v
  [ "$status" -eq 0 ]
  [[ "$output" == *"gh-cat v"* ]]
}

# =============================================================================
# Success Cases
# =============================================================================

@test "fetch single file from valid repository" {
  run "$GH_CAT" "$TEST_REPO" "$TEST_FILE"
  [ "$status" -eq 0 ]
  [[ "$output" == *"gh-cat"* ]]
}

@test "fetch multiple files concatenates output" {
  run "$GH_CAT" "$TEST_REPO" README.md LICENSE
  [ "$status" -eq 0 ]
  [[ "$output" == *"gh-cat"* ]]
  [[ "$output" == *"MIT"* ]]
}

@test "custom branch specification works" {
  run "$GH_CAT" cli/cli -b trunk README.md
  [ "$status" -eq 0 ]
  [[ "$output" == *"GitHub CLI"* ]]
}

@test "custom command with cat works" {
  run "$GH_CAT" "$TEST_REPO" -c cat "$TEST_FILE"
  [ "$status" -eq 0 ]
  [[ "$output" == *"gh-cat"* ]]
}

@test "custom command with arguments works" {
  run bash -c "'$GH_CAT' '$TEST_REPO' -c 'head -n 1' '$TEST_FILE'"
  [ "$status" -eq 0 ]
  [[ "$output" == *"gh-cat"* ]]
}

# =============================================================================
# Error Cases - Repository Validation
# =============================================================================

@test "invalid repository shows clear error" {
  run "$GH_CAT" nonexistent/fake-repo-12345 README.md
  [ "$status" -eq 1 ]
  [[ "$output" == *"error: repository 'nonexistent/fake-repo-12345' not found or inaccessible"* ]]
}

# =============================================================================
# Error Cases - File Not Found (HTTP 404)
# =============================================================================

@test "nonexistent file shows HTTP 404 error" {
  run "$GH_CAT" "$TEST_REPO" NONEXISTENT_FILE.md
  [ "$status" -eq 1 ]
  [[ "$output" == *"not found (HTTP 404)"* ]]
}

@test "404 error includes repository and file name" {
  run "$GH_CAT" "$TEST_REPO" FAKE.txt
  [ "$status" -eq 1 ]
  [[ "$output" == *"$TEST_REPO"* ]]
  [[ "$output" == *"FAKE.txt"* ]]
}

# =============================================================================
# Error Cases - Cat Command Failures
# =============================================================================

@test "failed cat command shows error with exit code" {
  run "$GH_CAT" "$TEST_REPO" -c false "$TEST_FILE"
  [ "$status" -eq 1 ]
  [[ "$output" == *"'false' failed"* ]]
  [[ "$output" == *"error 1"* ]]
}

@test "failed cat command includes file context" {
  run "$GH_CAT" "$TEST_REPO" -c false "$TEST_FILE"
  [ "$status" -eq 1 ]
  [[ "$output" == *"$TEST_REPO"* ]]
  [[ "$output" == *"$TEST_FILE"* ]]
}

@test "nonexistent cat command fails with error" {
  run "$GH_CAT" "$TEST_REPO" -c nonexistent-command-xyz "$TEST_FILE"
  [ "$status" -eq 1 ]
  [[ "$output" == *"command not found"* ]]
  [[ "$output" == *"error 127"* ]]
}

# =============================================================================
# Error Cases - Missing Arguments
# =============================================================================

@test "no arguments shows usage" {
  run "$GH_CAT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: gh cat repo path"* ]]
}

@test "only repository without file shows usage" {
  run "$GH_CAT" "$TEST_REPO"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: gh cat repo path"* ]]
}

# =============================================================================
# Integration Tests
# =============================================================================

@test "verbose mode shows debug output" {
  run "$GH_CAT" -V "$TEST_REPO" "$TEST_FILE"
  [ "$status" -eq 0 ]
  # -V enables set -x, so we should see command traces
  [[ "$output" == *"+"* ]]
}

@test "shorthand repo name without slash works" {
  # This test assumes the user has gh configured with a default user
  # If it fails due to missing config, it should show an appropriate error
  # rather than crash
  run "$GH_CAT" gh-cat README.md 2>&1 || true
  # Should either succeed or show a clear error
  [ "$status" -eq 0 ] || [[ "$output" == *"error"* ]]
}
