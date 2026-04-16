#!/bin/bash

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "--- Step 1: Fetching latest changes from origin/main ---"
git fetch origin main

echo "--- Step 2: Merging origin/main into $CURRENT_BRANCH ---"
# Attempt to merge without auto-committing to allow AI intervention if needed
git merge origin/main --no-commit --no-ff

# Check exit status
if [ $? -ne 0 ]; then
    echo "STATUS: Merge Conflict detected! AI intervention required."
    exit 1
else
    echo "STATUS: Merge successful. Please review changes before committing."
    exit 0
fi

