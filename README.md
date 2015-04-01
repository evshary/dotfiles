dotfiles
========
This is my dotfiles setting.
You can use it to set the tools below

##vim:
You need to install vim and neobundle which can manage the package of vim
neobundle github: https://github.com/Shougo/neobundle.vim
```bash
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
```

##zsh:
You need to install zsh and oh-my-zsh first
oh-my-zsh github: https://github.com/robbyrussell/oh-my-zsh
```bash
curl -L http://install.ohmyz.sh | sh
```

##peda
For better gdb
```bash
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit
```
