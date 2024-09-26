#!/bin/bash

# Stop whenever any commit fails
set -e

echo "======== Start to install basic dotfiles configuration ========"
echo ""


# install packages
sudo apt update
sudo apt install tmux vim zsh git tig bat curl wget ssh just \
                 exuberant-ctags ccls ripgrep \
                 python3-pip pipx


# RUST environment setup
if [ ! -d ~/.cargo ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.cargo/env"
fi


# Python environment setup
## poetry
curl -sSL https://install.python-poetry.org | python3 -
### poetry: Always make sure the virtualenv is under the project
poetry config virtualenvs.in-project true
## pyenv
if [ ! -d ~/.pyenv ]; then
    curl https://pyenv.run | bash
fi
## Ruff: Python3 linter & fixer
pipx install ruff
## pre-commit: Add hooks to git commit
### Run `pre-commit install --install-hooks` to enable `.pre-commit-config.yaml`
pipx install pre-commit


# install nvm (This is necessary for vim Coc plugin)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source "$HOME/.nvm/nvm.sh"
nvm install node


# vim settings
rm ~/.vimrc
ln -s ~/dotfiles/vimrc ~/.vimrc
if [ "$CLEAN" = "1" ]; then
    rm -rf ~/.vim
fi
if [ ! -d ~/.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ln -s ~/dotfiles/coc-settings.json ~/.vim/coc-settings.json
fi


# zsh settings
if [ "$CLEAN" = "1" ]; then
    rm -rf ~/.oh-my-zsh
fi
if [ ! -d ~/.oh-my-zsh ]; then
    curl -L http://install.ohmyz.sh | sh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open
fi
rm ~/.zshrc
ln -s dotfiles/zshrc ~/.zshrc
rm -rf ~/.zsh


# fzf: fuzzy finder
if [ "$CLEAN" = "1" ]; then
    rm -rf ~/.fzf
fi
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
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


echo ""
echo "======== Basic dotfiles installation is done ======="
