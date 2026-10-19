#!/bin/bash

# Stop whenever a command or download fails.
set -eo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR"
if [ "$DOTFILES_DIR" != "$HOME/dotfiles" ]; then
    echo "Please clone this repository to $HOME/dotfiles before installing." >&2
    exit 1
fi
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

echo "======== Start to install basic dotfiles configuration ========"
echo ""


# install packages
sudo apt update
sudo apt install -y tmux vim zsh git tig bat curl wget ssh htop ncdu \
                 universal-ctags clangd just ripgrep build-essential ca-certificates unzip zip \
                 python3-pip pipx

# git configuration
git config --global user.email "evshary@gmail.com"
git config --global user.name "ChenYing Kuo"
git config --global core.editor "vim"

# GPG configuration
sudo apt install -y pinentry-tty
mkdir -p ~/.gnupg
echo "pinentry-program /usr/bin/pinentry-tty" >> ~/.gnupg/gpg-agent.conf
# might need to restart if gpg-agent is running
#gpgconf --kill gpg-agent

# RUST environment setup
if [ ! -f "$HOME/.cargo/env" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source "$HOME/.cargo/env"

# Python environment setup
## uv
curl -LsSf https://astral.sh/uv/install.sh | sh
## Ruff: Python3 linter & fixer
pipx install ruff
## pre-commit: Add hooks to git commit
### Run `pre-commit install --install-hooks` to enable `.pre-commit-config.yaml`
pipx install pre-commit


# install nvm (This is necessary for vim Coc plugin)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source "$HOME/.nvm/nvm.sh"
nvm install --lts


# vim settings
rm -rf ~/.vimrc
ln -s ~/dotfiles/vimrc ~/.vimrc
if [ "$CLEAN" = "1" ]; then
    rm -rf ~/.vim
fi
if [ ! -d ~/.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ln -s ~/dotfiles/ubuntu2604/coc-settings.json ~/.vim/coc-settings.json
fi


# zsh settings
if [ "$CLEAN" = "1" ]; then
    rm -rf ~/.oh-my-zsh
fi
if [ ! -d ~/.oh-my-zsh ]; then
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | RUNZSH=no CHSH=no sh -s -- --unattended
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open
fi
rm -rf ~/.zshrc
ln -s dotfiles/zshrc ~/.zshrc
rm -rf ~/.zsh


# fzf: fuzzy finder
if [ "$CLEAN" = "1" ]; then
    rm -rf ~/.fzf
fi
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-update-rc
fi


# ranger: file manager in console
pipx install ranger-fm
rm -rf ~/.config/ranger/*
ranger --copy-config=all
# Settings is from https://yangxuanx.github.io/2019/03/11/ranger%E7%9A%84%E4%BD%BF%E7%94%A8/
cat ranger/commands.py >> ~/.config/ranger/commands.py
cat ranger/rc.conf >> ~/.config/ranger/rc.conf


# Other settings
rm -rf ~/.tmux.conf
ln -s dotfiles/tmux.conf ~/.tmux.conf
rm -rf ~/.gitconfig
ln -s dotfiles/gitconfig ~/.gitconfig
rm -rf ~/.gitconfig-canonical
ln -s dotfiles/gitconfig-canonical ~/.gitconfig-canonical
rm -rf ~/.devscripts
ln -s dotfiles/devscripts ~/.devscripts

# Install AI-related settings
## Install CLI
npm install -g @openai/codex
npm install -g @google/gemini-cli
## Install skills
./ai/install.sh

echo ""
echo "======== Basic dotfiles installation is done ======="
