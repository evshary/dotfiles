dotfiles
========
This is my dotfiles setting.
You can use it to set the tools below

## vim:
You need to install vim and neobundle which can manage the package of vim

neobundle github: https://github.com/Shougo/neobundle.vim
```bash
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
```
NOTE: You should adjust the windows size of Trinity yourself
```bash
# about 103
let g:Tlist_WinWidth = 23
# about 127
let g:SrcExpl_winHeight = 8
```

## zsh:
You need to install zsh and oh-my-zsh first

oh-my-zsh github: https://github.com/robbyrussell/oh-my-zsh
```bash
curl -L http://install.ohmyz.sh | sh
```
Then install [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

## peda
For better gdb
```bash
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit
```
