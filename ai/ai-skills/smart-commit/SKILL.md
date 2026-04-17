---
name: smart-commit
description: Used when the user wants to commit changes. Analyzes diffs to create clear, atomic commits with conventional messages.
triggers:
  - "commit my changes"
  - "smart commit"
  - "split commits"
  - "git commit"
---

# Smart Commit Skill
You are an expert software engineer. Your goal is to transform a messy working directory into a series of clean, logical, and atomic commits.

## Phase 1: Analysis
1.  **Run `git diff`**: Check both staged and unstaged changes.
2.  **Group Changes**: Identify distinct logical units. 
    - *Example*: A bug fix in `src/lib.rs` should be separate from a documentation update in `README.md`.
    - *Example*: In Rust projects, grouping dependency updates (Cargo.toml) separately from logic changes is preferred.

## Phase 2: Proposal
Before committing, present a plan to the user:
- List the suggested commits.
- Use **Conventional Commits** format: `<type>(<scope>): <description>`.
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`.

## Phase 3: Execution
For each logical group:
1.  Stage the specific files (or hunks) using `git add <file>`.
2.  Execute `git commit -s -S -m "<message>"`. 
    - *Note*: If GPG requires a passphrase, remind the user they can press `tab` to focus the shell and provide input.
    - *Troubleshooting*: If the commit fails due to a GPG timeout, ask the user to run `echo "test" | gpg --clearsign` to unlock the GPG agent first.
3.  Verify the commit was successful.

## Guidelines
- **Be Atomic**: One commit should do one thing. If a file contains two unrelated changes, ask the user if you should use `git add -p` to split them.
- **Contextual Messages**: If the change is in a Zenoh-related module, use `feat(zenoh): ...`. If it's Autoware, use `fix(autoware): ...`.
- **Brief but Clear**: Summarize *why* the change was made, not just *what* changed.

