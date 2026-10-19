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

## Back up and restore keys and shell history

Requires Python 3. Backups contain `.ssh/`, `.gnupg/`, `.bash_history`, and
`.zsh_history` from your home directory, when present. Before backing up or
restoring, close other shell sessions and applications that use these files.
Save pending history in your current shell with `history -a` (Bash) or `fc -AI`
(zsh), then exit that shell before restoring to avoid overwriting restored history.

```shell
# Create backup/dotfiles-backup-<timestamp>.tar.gz in this repository.
./scripts/export.sh
# Optionally choose a different output directory.
./scripts/export.sh /path/to/backups
# Restore a specific archive.
./scripts/import.sh /path/to/backups/dotfiles-backup-<timestamp>.tar.gz
```

Archives are **not encrypted** and have mode `600`. They preserve regular files,
directories, permissions, and modification times. Sockets and GPG lock/temporary
files are excluded; symlinks and other special files are rejected explicitly.
Only standard `.ssh` and `.gnupg` locations are supported; hardware-token secrets
and keys stored elsewhere are not copied.

Restore validates the entire archive before replacing anything. Existing targets
are moved into a private `~/.dotfiles-before-restore-*` directory, and unrelated
files stay in place. Restored `.ssh/` and `.gnupg/` directories use mode `700`;
history files use mode `600`. Check the restored data before deleting the saved
originals. Archives from the old GPG-only export script are not supported.

To run the backup tests with disposable data:

```shell
python3 scripts/test_backup.py
```
