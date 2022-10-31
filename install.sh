#!/bin/bash

# install packages
sudo apt install tmux vim-gtk zsh \
                 git exuberant-ctags \
                 silversearcher-ag ripgrep \
                 xclip
# install bat
# We need to install this way since the confliction of bat and ripgrep
# https://github.com/BurntSushi/ripgrep/issues/1562
apt-get download bat
sudo dpkg --force-overwrite -i bat*.deb
rm bat*.deb
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

# vim settings
echo "vim settings ..."
rm ~/.vimrc
rm -rf ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s ~/dotfiles/vimrc ~/.vimrc

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

# fzf installation
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install ranger
python3 -m pip install ranger-fm
rm -rf ~/.config/ranger/*
ranger --copy-config=all
# Settings is from https://yangxuanx.github.io/2019/03/11/ranger%E7%9A%84%E4%BD%BF%E7%94%A8/
cat ranger/commands.py >> ~/.config/ranger/commands.py
cat ranger/rc.conf >> ~/.config/ranger/rc.conf

# Other settings
echo "other settings ..."
rm -rf ~/.rsc
ln -s dotfiles/rsc ~/.rsc
rm -rf ~/.tmux.conf
ln -s dotfiles/tmux.conf ~/.tmux.conf
rm -rf ~/.gitconfig
ln -s dotfiles/gitconfig ~/.gitconfig
