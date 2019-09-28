dotfiles
========
This is my dotfiles setting.
You can use it to set the tools below

# Quick installation
Use `./install.sh` for quick installation.

After installation, use `:PlugInstall` in vim to install packages.

# vim:
Maybe you should adjust the windows size of Trinity yourself
```bash
# about 103
let g:Tlist_WinWidth = 23
# about 127
let g:SrcExpl_winHeight = 8
```

# peda
For better gdb
```bash
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit
```
