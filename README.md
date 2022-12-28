# dotfiles

This is my dotfiles setting.
You can use it to set the tools below

# Quick installation

1. Use `./install.sh` for quick installation.
2. Change the shell: `chsh -s /bin/zsh`.
3. Logout and then login
4. We use [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins here. Use `:PlugInstall` in vim to install packages.
5. Install coc plugin in vim: `:CocInstall coc-rust-analyzer` and `CocInstall coc-pyright` in vim
  - If there is coc error while opening vim, it might be node version issue. Please use nvm to update node.

# vim

Maybe you should adjust the windows size of Trinity yourself

```shell
# about 103
let g:Tlist_WinWidth = 23
# about 127
let g:SrcExpl_winHeight = 8
```

# peda

For better gdb

```shell
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit
```

