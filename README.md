# dotfiles

This is my dotfiles setting.
You can use it to set the tools below

## Quick installation

1. Clone this repository to `~/dotfiles`, then run the installer inside the OS.

   ```shell
   # Ubuntu 26.04 (use ubuntu2404 for Ubuntu 24.04)
   # Basic
   ./ubuntu2604/install.sh
   # Full (Package management / docker)
   ./ubuntu2604/install_full.sh
   ```

2. Change the shell: `chsh -s /bin/zsh`.

3. Logout and then login (Also make some environmental variables take effect)

4. We use [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins.
   Use `:PlugInstall` in vim to install packages.

5. Install coc plugin in vim `:CocInstall coc-rust-analyzer coc-pyright`

   - If Coc reports an error when opening vim, use nvm to update Node.js.

## Test Ubuntu 26.04 with Docker

Run one command from the repository root:

```shell
docker build --progress=plain -f ubuntu2604/Dockerfile -t dotfiles:26.04 .
```

This runs the full installer as a non-root user, including Rust, and automatically
checks installed commands, shell configuration, and configuration links.
Rust download progress is displayed during the build.
It requires internet access and does not change your host configuration.

To test only the basic installer, add `--build-arg INSTALL_FULL=0`.

Docker checks installation and CLI startup. Login behavior, desktop applications,
and Docker daemon operation still need a VM or a real Ubuntu installation.
