---
name: git-sync-main
description: Used when the user says "sync main", "update branch", or "merge main into current branch".
triggers:
  - "sync main"
  - "merge main"
  - "update branch"
  - "git sync"
---

# Git Sync Main Skill
You are a Git automation assistant. When this skill is activated, follow this workflow:

## 1. Environment Check
Verify that the current directory is a Git repository and the working tree is clean (no uncommitted changes). If the tree is dirty, ask the user to stash or commit changes first.

## 2. Execution
Call the `tools/sync.sh` script to perform the fetch and merge operations.
The tools folder should be under the same folder as this SKILL.md.

## 3. Conflict Resolution
- **If Merge is Successful**: Inform the user that the branch is up to date and ask if they would like to run tests or linting.
- **If a Conflict Occurs**: 
    - The script will exit with an error. 
    - You must scan the conflicted files immediately.
    - Analyze the code logic and provide a suggested resolution for each conflict.
    - Ask the user for permission before applying any automated fixes.

## 4. Finalization
Once conflicts are resolved, remind the user to run the build/test suite (e.g., `cargo test` for Rust projects) before committing the merge.

