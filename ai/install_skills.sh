#!/bin/bash

# google
## antigravity
mkdir -p ~/.gemini/antigravity
rm -rf ~/.gemini/antigravity/skills
ln -s ~/dotfiles/ai/ai-skills ~/.gemini/antigravity/skills
## gemini
rm -rf ~/.gemini/skills
ln -s ~/dotfiles/ai/ai-skills ~/.gemini/skills

# claude code / cursor
mkdir -p ~/.claude
rm -rf ~/.claude/skills
ln -s ~/dotfiles/ai/ai-skills ~/.claude/skills

# copilot / codex
mkdir -p ~/.codex
rm -rf ~/.codex/skills
ln -s ~/dotfiles/ai/ai-skills ~/.codex/skills
