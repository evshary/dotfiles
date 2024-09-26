#!/bin/bash

# install packages
sudo add-apt-repository ppa:jonathonf/vim # Use the latest vim
sudo apt update
sudo apt install tmux vim vim-gtk zsh \
                 git exuberant-ctags ccls \
                 silversearcher-ag ripgrep \
                 xclip curl python3-pip python3-argcomplete


# bat: print with color
# We need to install this way since the confliction of bat and ripgrep
# https://github.com/BurntSushi/ripgrep/issues/1562
apt-get download bat
sudo dpkg --force-overwrite -i bat*.deb
rm bat*.deb
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat


# RUST environment setup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"


# Python environment setup
## poetry
curl -sSL https://install.python-poetry.org | python3 -
### poetry: Always make sure the virtualenv is under the project
poetry config virtualenvs.in-project true
## pyenv
curl https://pyenv.run | bash
## Ruff: Python3 linter & fixer
python3 -m pip install ruff
## pre-commit: Add hooks to git commit
### Run `pre-commit install --install-hooks` to enable `.pre-commit-config.yaml`
python3 -m pip install pre-commit


# install nvm (This is necessary for vim Coc plugin)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source "$HOME/.nvm/nvm.sh"
nvm install node


# vim settings
echo "vim settings ..."
rm ~/.vimrc
rm -rf ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/coc-settings.json ~/.vim/coc-settings.json


# zsh settings
echo "zsh settings ..."
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
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


# ranger: file manager in console
python3 -m pip install ranger-fm
rm -rf ~/.config/ranger/*
ranger --copy-config=all
# Settings is from https://yangxuanx.github.io/2019/03/11/ranger%E7%9A%84%E4%BD%BF%E7%94%A8/
cat ranger/commands.py >> ~/.config/ranger/commands.py
cat ranger/rc.conf >> ~/.config/ranger/rc.conf


# Other settings
echo "other settings ..."
rm -rf ~/.tmux.conf
ln -s dotfiles/tmux.conf ~/.tmux.conf
rm -rf ~/.gitconfig
ln -s dotfiles/gitconfig ~/.gitconfig

