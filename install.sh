#!/bin/bash

# install packages
sudo apt install tmux vim zsh git

# vim settings
rm ~/.vimrc
rm -rf ~/.vim
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
ln -s ~/dotfiles/.vimrc ~/.vimrc

# zsh settings
curl -L http://install.ohmyz.sh | sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm ~/.zshrc
ln -s dotfiles/.zshrc ~/.zshrc
rm -rf ~/.zsh
ln -s dotfiles/.zsh ~/.zsh

# Other settings
rm -rf ~/.rsc
ln -s dotfiles/.rsc ~/.rsc
rm -rf ~/.tmux.conf
ln -s dotfiles/.tmux.conf ~/.tmux.conf
rm -rf ~/.gitconfig
ln -s dotfiles/.gitconfig ~/.gitconfig
