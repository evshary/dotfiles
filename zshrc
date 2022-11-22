# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="candy"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
    git       # Able to detect git folder
    git-flow  # Support git flow command: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-flow
    git-open  # Quick open git remote folder: https://github.com/paulirish/git-open
    extract   # x to extract all kind of compressed files
    z         # z to jump the recently used folder: https://github.com/agkozak/zsh-z
    zsh-syntax-highlighting # Highlight which command can be used
    zsh-autosuggestions     # Suggest the latest used command 
)

alias ggo=git-open # Alias git-open, don't use go to avoid conflicts with golang
alias vi='vim'
alias sl='ls'
source $ZSH/oh-my-zsh.sh

# Do not share history for zsh
setopt no_share_history

# OS dependent command
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    # The default vim for mac has bugs
    alias vim='/usr/local/bin/vim'
    # The default ctags for mac is simplified version
    alias ctags='/usr/local/bin/ctags'
elif [[ "$OSTYPE" == "msys" ]]; then
    # Windows 
fi

# fzf setting
# Usage:
#   - Use ** to autocomplete files
#   - ctrl+r: command history
#   - alt+c: search folders
#   - ctrl+t: search files and folders
# Use rg for find
export FZF_DEFAULT_COMMAND="rg --files --follow --no-ignore-vcs --hidden -g '!{node_modules,build,install,log,snap,.git,.local,.*}'"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
# Setup preview while completion
PREVIEW_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
export FZF_COMPLETION_OPTS=$PREVIEW_OPTS
# f to list all files
f() {
    fzf --height 40% --layout reverse --info inline --border \
        --preview 'file {}' --preview-window up,1,border-horizontal \
        --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'
}
# Source environmental variables
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ranger setting
# j/k: up / down
# l: enter a directory / open a file
# h: back to parent directory
# q: exit
#
# yy: copy files
# pp: past files
# dd: cut files
# dD: delete files
# DD: delete files to trash
alias rf='ranger'

# Enable core dump
# If segmentation fault, run `gdb ./exe core`
ulimit -c unlimited

# Update the system with one command
upgrade() {
    sudo apt update && sudo apt upgrade && sudo apt autoremove
    python3 -m pip install --upgrade pip
    rustup update
}

# Add $HOME directory
export PATH=$HOME/.local/bin/:$PATH

# Show the ASCII photo of RIN chan
#cat ~/.rsc/rin.ans
#echo ""

# Show enable ROS settings
ros_menu_path=~/.ros_menu/ros_bashrc
if [ -f $ros_menu_path ]; then
    source $ros_menu_path
fi

# Bugfix for zsh
# https://github.com/ros2/ros2cli/issues/534
eval "$(register-python-argcomplete3 ros2)"
eval "$(register-python-argcomplete3 colcon)"

