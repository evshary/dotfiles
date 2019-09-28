#!/bin/bash

# install packages
sudo apt install tmux vim zsh git

# vim settings
echo "vim settings ..."
rm ~/.vimrc
rm -rf ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc

# zsh settings
echo "zsh settings ..."
if [ ! -d ~/.oh-my-zsh ]; then
  curl -L http://install.ohmyz.sh | sh
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
rm ~/.zshrc
ln -s dotfiles/.zshrc ~/.zshrc
rm -rf ~/.zsh
ln -s dotfiles/.zsh ~/.zsh

# Other settings
echo "other settings ..."
rm -rf ~/.rsc
ln -s dotfiles/.rsc ~/.rsc
rm -rf ~/.tmux.conf
ln -s dotfiles/.tmux.conf ~/.tmux.conf
rm -rf ~/.gitconfig
ln -s dotfiles/.gitconfig ~/.gitconfig
