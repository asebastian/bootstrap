# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
if [[ $UID == 0 || $EUID == 0 ]]; then
   # i'm root
  export ZSH="/$(whoami)/.oh-my-zsh"
else
  export ZSH="/home/$(whoami)/.oh-my-zsh"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="risto"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=90

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"
function precmd () {
  window_title="\033]0;$(whoami)@$(hostname):${PWD##*/}\007"
  echo -ne "$window_title"
}

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="yyyy-mm-dd"

# Unlimited history (almost)
HISTSIZE=9999999999
export SAVEHIST=$HISTSIZE

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias rmswap='find . -type f -name "*.sw[klmnop]" -delete'
alias lsoftcp="lsof -n -iTCP |grep LISTEN"
alias mycommits='git log --author="Alan Sebastian" --pretty=oneline'
alias commitsbyauthor="git shortlog -s -n"
alias linesinrepo="git ls-files | xargs cat | wc -l"
alias grep="rg"
alias journalctl="journalctl -o cat"
alias su="su -"

# zpool verbose properties
alias zpoola="zpool list -o health,allocated,capacity,free,freeing,size,fragmentation,ashift,delegation,failmode,guid"

# examples
alias tcpdumpheadercaptureexample="sudo tcpdump -n -S -s 0 -A 'tcp dst port 8889'"

# Checks to see if vim-workspace has an active
# session in the current working directory. To
# be used by vim-airline eventually as a status
# indicator.
function isWorkspaceToggled() {
  cwd=$(pwd)
  percentedCwd="${cwd//\//%}"

  if [ ! -f ~/.vim/sessions/$percentedCwd ]; then
    echo "no session found!"
  else
    echo "found a session!"
  fi
}

# set date on right
RPROMPT="[%D{%Y/%m/%d}|%@]"

# set GPG_TTY for git gpg signing
export GPG_TTY=$(tty)

# Add default go bin path to path
export PATH="$PATH:/usr/local/go/bin:~/go/bin:/snap/bin"
# Have fzf execute the command selected automatically.
# fzf-history-widget-accept() {
#   fzf-history-widget
#   zle accept-line
# }
# zle     -N   fzf-history-widget-accept
# bindkey '^R' fzf-history-widget-accept

unsetopt correct_all
