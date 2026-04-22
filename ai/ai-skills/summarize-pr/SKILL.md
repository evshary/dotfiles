---
name: summarize-pr
description: Summarize changes and generate a PR title and description. Use when the user is ready to open a Pull Request or needs a comprehensive summary of their current changes compared to a target branch.
---

# Summarize PR Skill

You are an expert at technical communication and documentation. Your goal is to analyze changes in a codebase and generate high-quality Pull Request (PR) summaries, titles, and descriptions that follow professional standards.

## Workflow

### 1. Analyze Changes
- **Identify Target Branch**: Ask the user for the target branch (defaulting to `main` if unsure).
- **Run Diff**: Compare the current branch with the target branch using `git diff <target-branch>...HEAD`.
- **Review Commits**: Use `git log <target-branch>..HEAD --oneline` to see the commit history.

### 2. Generate PR Title
- **Format**: Follow Conventional Commits format if the project uses it, or use a concise, imperative title.
- **Example**: `feat: add PR summarization skill` or `fix(auth): resolve session timeout issue`.

### 3. Generate PR Description
A well-structured PR description should include:
- **Summary**: A high-level overview of the PR.
- **What does this PR do?**: A bulleted list of significant technical changes.
- **Why is this change needed?**: Explain the motivation, problem being solved, or the value this PR provides.
- **Testing**: Briefly mention how the changes were verified.
- **Related Issues**: Mention any issue numbers if found in commit messages.

## Guidelines
- **Output Format**: ALWAYS provide the final PR title and description in valid Markdown format.
- **Be Concise**: Avoid fluff. Focus on technical impact.
- **Categorize**: Group changes by component or functionality (e.g., UI, Backend, Documentation).
- **Highlight Breaking Changes**: Clearly call out any backwards-incompatible changes.
- **User Tone**: Match the existing documentation style of the project.

## Example Output (Markdown)

```markdown
# Title: feat(ai): add summarize-pr skill

## Description
This PR introduces a new AI skill `summarize-pr` to help automate the generation of PR titles and descriptions.

### What does this PR do?
- Added `summarize-pr` skill directory under `ai/ai-skills/`.
- Implemented `SKILL.md` with a structured workflow for PR analysis and generation.
- Included guidelines for high-quality technical summaries.

### Why is this change needed?
Manually writing PR descriptions is time-consuming and often lacks consistency. This skill ensures all PRs have a high-quality, structured summary that follows project standards, improving code review efficiency.

### Testing
- Verified skill initialization and structure.
```
