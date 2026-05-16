#!/bin/bash

AGENTS_FILE=~/dotfiles/ai/AGENTS.md
SKILLS_DIR=~/dotfiles/ai/ai-skills

# google
## antigravity
mkdir -p ~/.gemini/antigravity
rm -rf ~/.gemini/antigravity/skills
ln -s "$SKILLS_DIR" ~/.gemini/antigravity/skills
## gemini
mkdir -p ~/.gemini
rm -rf ~/.gemini/skills
ln -s "$SKILLS_DIR" ~/.gemini/skills
rm -rf ~/.gemini/GEMINI.md
ln -s "$AGENTS_FILE" ~/.gemini/GEMINI.md

# claude code / cursor
mkdir -p ~/.claude
rm -rf ~/.claude/skills
ln -s "$SKILLS_DIR" ~/.claude/skills
rm -rf ~/.claude/CLAUDE.md
ln -s "$AGENTS_FILE" ~/.claude/CLAUDE.md

# copilot / codex
mkdir -p ~/.codex
rm -rf ~/.codex/skills
ln -s "$SKILLS_DIR" ~/.codex/skills
rm -rf ~/.codex/AGENTS.md
ln -s "$AGENTS_FILE" ~/.codex/AGENTS.md
