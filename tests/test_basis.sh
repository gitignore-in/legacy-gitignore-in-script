#!/usr/bin/env bash

set -euo pipefail

# get gitignore.in command absolute path
self_path=$(realpath $(dirname "$0"))
gitignore_in_path=$(realpath "$self_path/../gitignore.in")

# Create a temporary directory for testing
tmp_dir=$(mktemp -d)
echo "Testing in temporary directory: $tmp_dir"

# Test in sub shell to clean up in case of failure
(
    cd "$tmp_dir"
    # Create a git repository
    git init
    # First run
    "$gitignore_in_path"
    # .gitignore.in should be created
    test -f .gitignore.in && echo "OK"

    # Second run
    "$gitignore_in_path"
    # .gitignore should be created
    test -f .gitignore && echo "OK"
)

# Clean up
rm -rf "$tmp_dir"
