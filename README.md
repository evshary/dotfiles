# dotfiles

This is my dotfiles setting.
You can use it to set the tools below

## Quick installation

1. Run installation script inside the OS.

   ```shell
   # Basic
   ./ubuntu2404/install.sh
   # Full (Package management / docker)
   ./ubuntu2404/install_full.sh
   ```

2. Change the shell: `chsh -s /bin/zsh`.

3. Logout and then login (Also make some environmental variables take effect)

4. We use [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins here. Use `:PlugInstall` in vim to install packages.

5. Install coc plugin in vim: `:CocInstall coc-rust-analyzer` and `:CocInstall coc-pyright` in vim
  - If there is coc error while opening vim, it might be node version issue. Please use nvm to update node.

