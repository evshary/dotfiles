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

alias go=git-open # Alias git-open
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

# Enable core dump
# If segmentation fault, run `gdb ./exe core`
ulimit -c unlimited

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
_bash_complete () {
	local ret=1 
	local -a suf matches
	local -x COMP_POINT COMP_CWORD
	local -a COMP_WORDS COMPREPLY BASH_VERSINFO
	local -x COMP_LINE="$words" 
	local -A savejobstates savejobtexts
	(( COMP_POINT = 1 + ${#${(j. .)words[1,CURRENT-1]}} + $#QIPREFIX + $#IPREFIX + $#PREFIX ))
	(( COMP_CWORD = CURRENT - 1))
	COMP_WORDS=($words) 
	BASH_VERSINFO=(2 05b 0 1 release) 
	savejobstates=(${(kv)jobstates}) 
	savejobtexts=(${(kv)jobtexts}) 
	[[ ${argv[${argv[(I)nospace]:-0}-1]} = -o ]] && suf=(-S '') 
	matches=(${(f)"$(compgen $@ -- ${words[CURRENT]})"}) 
	if [[ -n $matches ]]
	then
		if [[ ${argv[${argv[(I)filenames]:-0}-1]} = -o ]]
		then
			compset -P '*/' && matches=(${matches##*/}) 
			compset -S '/*' && matches=(${matches%%/*}) 
			compadd -Q -f "${suf[@]}" -a matches && ret=0 
		else
			compadd -Q "${suf[@]}" -a matches && ret=0 
		fi
	fi
	if (( ret ))
	then
		if [[ ${argv[${argv[(I)default]:-0}-1]} = -o ]]
		then
			_default "${suf[@]}" && ret=0 
		elif [[ ${argv[${argv[(I)dirnames]:-0}-1]} = -o ]]
		then
			_directories "${suf[@]}" && ret=0 
		fi
	fi
	return ret
}
