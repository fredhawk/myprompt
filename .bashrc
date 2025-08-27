#!/usr/bin/env bash

# Check if running interactively
[[ $- != *i* ]] && return
#######################################################
# INITIALIZATION
#######################################################

# Source system-wide bash configuration
[[ -f /etc/bashrc ]] && source /etc/bashrc

# Enable bash completion
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
fi

#######################################################
# SHELL OPTIONS
#######################################################

# Update window size after each command
shopt -s checkwinsize

# Append to history instead of overwriting
shopt -s histappend

# Disable terminal bell
bind "set bell-style none" 2>/dev/null

# Case-insensitive completion
bind "set completion-ignore-case on" 2>/dev/null

# Show completion list immediately
bind "set show-all-if-ambiguous on" 2>/dev/null

# Allow Ctrl+S for forward history search
stty -ixon 2>/dev/null
#######################################################
# HISTORY CONFIGURATION
#######################################################

export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL="erasedups:ignoredups:ignorespace"
export PROMPT_COMMAND="history -a"
#######################################################
# ENVIRONMENT VARIABLES
#######################################################

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Default editors
export EDITOR="nvim"
export VISUAL="nvim"

# Color support
export CLICOLOR=1
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'

# PATH additions
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
#######################################################
# UTILITY FUNCTIONS
#######################################################

# Detect Linux distribution
get_distro() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
            fedora|rhel|centos|rocky|almalinux) echo "redhat" ;;
            ubuntu|debian|mint) echo "debian" ;;
            arch|manjaro|endeavouros) echo "arch" ;;
            opensuse*|sles) echo "suse" ;;
            gentoo) echo "gentoo" ;;
            *) echo "unknown" ;;
        esac
    else
        echo "unknown"
    fi
}

# Extract various archive formats
extract() {
    for file in "$@"; do
        if [[ -f "$file" ]]; then
            case "$file" in
                *.tar.bz2) tar xjf "$file" ;;
                *.tar.gz) tar xzf "$file" ;;
                *.tar.xz) tar xJf "$file" ;;
                *.bz2) bunzip2 "$file" ;;
                *.rar) unrar x "$file" ;;
                *.gz) gunzip "$file" ;;
                *.tar) tar xf "$file" ;;
                *.tbz2) tar xjf "$file" ;;
                *.tgz) tar xzf "$file" ;;
                *.zip) unzip "$file" ;;
                *.Z) uncompress "$file" ;;
                *.7z) 7z x "$file" ;;
                *) echo "Unknown archive format: $file" ;;
            esac
        else
            echo "File not found: $file"
        fi
    done
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Go up n directories
up() {
    local levels=${1:-1}
    local path=""
    for ((i=0; i<levels; i++)); do
        path="../$path"
    done
    cd "$path"
}

# Enhanced cd with auto-ls
cd() {
    if [[ $# -eq 0 ]]; then
        builtin cd ~ && ls -la
    else
        builtin cd "$@" && ls -la
    fi
}

# Search text in files
search() {
    grep -rn --color=always "$1" . | less -R
}

# Get internal and external IP
myip() {
    echo "Internal IP:"
    ip route get 1.1.1.1 | awk '{print $7}' 2>/dev/null || echo "Not connected"
    echo "External IP:"
    curl -s ifconfig.me || echo "Unable to fetch"
}
#######################################################
# ALIASES - SYSTEM
#######################################################

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

#######################################################
# ALIASES - FILE OPERATIONS
#######################################################

alias ls='ls --color=auto -F'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -ltr'
alias lh='ls -lh'
alias tree='tree -C'
# Eza
alias e="eza --icons -F -H --group-directories-first --git -1 -al"
alias ez="eza -l"

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -pv'

# Safe alternatives
command -v trash >/dev/null 2>&1 && alias rm='trash'

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history
alias h="history | grep "

# Search files in the current folder
alias f="find . | grep "

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

#######################################################
# ALIASES - TEXT PROCESSING
#######################################################

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Use modern alternatives if available
command -v rg >/dev/null 2>&1 && alias grep='rg'
command -v bat >/dev/null 2>&1 && alias cat='bat'
command -v exa >/dev/null 2>&1 && alias ls='exa'

#######################################################
# ALIASES - SYSTEM MONITORING
#######################################################

alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep'
alias top='htop'
alias ports='netstat -tulanp'
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

#######################################################
# ALIASES - PACKAGE MANAGEMENT
#######################################################

DISTRO=$(get_distro)
case "$DISTRO" in
    "debian")
        alias install='sudo apt install'
        alias update='sudo apt update && sudo apt upgrade'
        alias search='apt search'
        alias remove='sudo apt remove'
        ;;
    "redhat")
        alias install='sudo dnf install'
        alias update='sudo dnf update'
        alias search='dnf search'
        alias remove='sudo dnf remove'
        ;;
    "arch")
        alias install='sudo pacman -S'
        alias update='sudo pacman -Syu'
        alias search='pacman -Ss'
        alias remove='sudo pacman -R'
        ;;
esac

#######################################################
# ALIASES - DEVELOPMENT
#######################################################

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias edit='$EDITOR'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gcon='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"

# Lazygit
alias lg="lazygit"

# Tmux
alias tls="tmux ls"
alias tmk="tmux kill-session -t"

# SHA1
alias sha1='openssl sha1'

# Quick commit
gcom() {
    git add . && git commit -m "$1"
}

# Lazy git (add, commit, push)
lazy() {
    git add . && git commit -m "$1" && git push
}

#######################################################
# ALIASES - DOCKER
#######################################################

alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias dclean='docker system prune -af'

# alias to cleanup unused docker containers, images, networks, and volumes
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '

#######################################################
# ALIASES - NETWORKING
#######################################################

alias ping='ping -c 5'
alias wget='wget -c'
alias curl='curl -L'

#######################################################
# CUSTOM KEYBINDINGS
#######################################################

# Bind Ctrl+f to zi (zoxide interactive)
bind '"\C-f":"zi\n"' 2>/dev/null

#######################################################
# PROMPT AND SHELL ENHANCEMENTS
#######################################################

# Initialize starship prompt if available
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

# Initialize zoxide if available
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"

#######################################################
# AUTO-START X11
#######################################################

# Auto-start X11 on tty1
if [[ -z "$DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
exec startx
fi
