#!/bin/bash

# Smoke checks for an isolated installation, without starting services.
set -eo pipefail
export PATH="$HOME/.local/bin:$HOME/.fzf/bin:$PATH"
source "$HOME/.nvm/nvm.sh"

for command in tmux vim zsh git tig batcat curl wget ssh htop ncdu ctags \
               clangd rg python3 pipx pinentry-tty just uv ruff pre-commit \
               ranger node npm codex gemini fzf; do
    command -v "$command"
done

tmux -V
vim --version
clangd --version
ctags --version
just --version
just --completions zsh >/dev/null
uv --version
ruff --version
pre-commit --version
ranger --version
node --version
npm --version
codex --version
gemini --version
fzf --version

for config in .vimrc .zshrc .tmux.conf .gitconfig .gitconfig-canonical \
              .devscripts .vim/coc-settings.json .codex/skills .codex/AGENTS.md \
              .gemini/skills .gemini/GEMINI.md .claude/skills .claude/CLAUDE.md; do
    test -L "$HOME/$config"
    test -e "$HOME/$config"
done

test -s "$HOME/.vim/autoload/plug.vim"
test -s "$HOME/.config/ranger/commands.py"
test -s "$HOME/.config/ranger/rc.conf"
test -s "$HOME/.fzf.zsh"
grep -Fx 'pinentry-program /usr/bin/pinentry-tty' "$HOME/.gnupg/gpg-agent.conf"
for plugin in zsh-syntax-highlighting zsh-autosuggestions git-open; do
    test -d "$HOME/.oh-my-zsh/custom/plugins/$plugin"
done
# Interactive shell integrations require a terminal (including ZLE).
script -q -e -c "zsh -ic 'command -v fzf just node; [[ -n \$ZSH_VERSION ]]'" /dev/null </dev/null

source "$HOME/.cargo/env"
rustc --version
cargo --version

if [ "${INSTALL_FULL:-0}" = "1" ]; then
    flatpak --version
    docker --version
    id -nG "$(id -un)" | grep -w docker
fi

echo 'Installation smoke checks passed.'
