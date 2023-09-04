#!/usr/bin/env bash

set -euo pipefail

# get gitignore.in command absolute path
self_path=$(realpath $(dirname "$0"))
gitignore_in_path=$(realpath "$self_path/../gitignore.in")

test_in_sandbox() {
    # Create a temporary directory for testing
    tmp_dir=$(mktemp -d)
    echo "Testing in temporary directory: $tmp_dir"
    cd "$tmp_dir"
    set +e
    # Test in forked shell
    cat /dev/stdin | bash
    set -e
    if [ $? -ne 0 ]; then
        echo "Test failed" >&2
        exit 1
    else
        echo "Test passed" >&2
    fi
    cd - >/dev/null
    # Clean up
    rm -rf "$tmp_dir"
}

test_in_sandbox <<EOF
# Create a git repository
git init
# First run
"$gitignore_in_path"
# .gitignore.in should be created
test -f .gitignore.in && echo "OK" >&2
# Second run
"$gitignore_in_path"
# .gitignore should be created
test -f .gitignore && echo "OK" >&2
EOF
