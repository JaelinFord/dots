# ---------------------------------------------------------------------------- #
# ~/.bashrc                                                                    #
# ---------------------------------------------------------------------------- #

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

set -o vi

export LESS='-R'
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway

# ---------------------------------------------------------------------------- #
# Enviroment Tweaks                                                            #
# ---------------------------------------------------------------------------- #

# Default editor
export EDITOR=nvim
export VISUAL=nvim

# Wayland Firefox
export MOZ_ENABLE_WAYLAND=1

# Better man pages
export MANPAGER="nvim +Man!"

# Use bash completion if installed
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
fi

# Use bat if available, otherwise regular cat
if command -v bat &> /dev/null; then
    alias cat='bat --style=plain'
fi

# Use eza if available, otherwise ls with color
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first --icons'
    alias la='eza -lah --group-directories-first --icons'
    alias tree='eza --tree -a'
else
    alias ls='ls --color=auto'
    alias la='ls -lah'
fi

# FZF keybindings and completion
if command -v fzf &> /dev/null; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi


# ---------------------------------------------------------------------------- #
# Aliases                                                                      #
# ---------------------------------------------------------------------------- #

alias ll='ls -lah'
alias grep='grep --color=auto'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'
alias gb='git branch'

alias v='nvim'

# Safer file ops
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#alias ..='cd ..'
#alias ...='cd ../..'
#alias ....='cd ../../..'
#alias ~='cd ~'
#alias -- -='cd -'  # Go to previous directory

#alias pacup='sudo pacman -Syu'
#alias pacin='sudo pacman -S'
#alias pacrem='sudo pacman -Rns'
#alias pacsearch='pacman -Ss'
#alias pacclean='sudo pacman -Sc'

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick backup
backup() {
    cp "$1"{,.bak}
}

# Extract any archive
extract() {
    if [ $# -ne 1 ]; then
        echo "Usage: extract <archive>"
        return 1
    fi

    local archive="$1"

    if [ ! -f "$archive" ]; then
        echo "Error: '$archive' is not a valid file"
        return 1
    fi

    # Detect file type
    local filetype
    filetype=$(file -b --mime-type "$archive")

    # Create clean directory name
    local dirname
    dirname="${archive##*/}"            # remove path
    dirname="${dirname%.*}"             # remove one extension
    dirname="${dirname%.tar}"           # handle .tar.gz case

    mkdir -p "$dirname" || return 1

    case "$filetype" in
        application/x-tar)
            tar -xf "$archive" -C "$dirname"
            ;;
        application/gzip)
            tar -xzf "$archive" -C "$dirname" 2>/dev/null \
            || gunzip -c "$archive" > "$dirname/${dirname}"
            ;;
        application/x-bzip2)
            tar -xjf "$archive" -C "$dirname"
            ;;
        application/x-xz)
            tar -xJf "$archive" -C "$dirname"
            ;;
        application/zip)
            unzip -q "$archive" -d "$dirname"
            ;;
        application/x-7z-compressed)
            7z x "$archive" -o"$dirname" >/dev/null
            ;;
        application/x-rar)
            unrar x -inul "$archive" "$dirname/"
            ;;
        *)
            echo "Error: Unsupported archive type ($filetype)"
            rmdir "$dirname"
            return 1
            ;;
    esac

    echo "Extracted to: $dirname/"
}


# ---------------------------------------------------------------------------- #
# General Behavior                                                             #
# ---------------------------------------------------------------------------- #

# Don't put duplicate commands in history
HISTCONTROL=ignoreboth

# Increase history size
HISTSIZE=10000
HISTFILESIZE=20000

# Append to history instead of overwriting
shopt -s histappend

# Save multi-line commands as single entry
shopt -s cmdhist

# Update history immediately
shopt -s histappend
PROMPT_COMMAND="history -a; history -n"

# Better globbing
shopt -s globstar
shopt -s autocd

# Enable case-insensitive completion
bind "set completion-ignore-case on"

# Show all completion matches immediately
bind "set show-all-if-ambiguous on"


# ---------------------------------------------------------------------------- #
# Prompt (Clean + Informative )                                                #
# ---------------------------------------------------------------------------- #

# Git branch in prompt (fast version)
parse_git_branch() {
	git branch 2>/dev/null | sed -n '/\* /s///p'
}

PS1='\[\e[1;34m\]\u@\h\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\]$(git branch &>/dev/null && echo " \[\e[1;35m\]($(parse_git_branch))\[\e[0m\]")\n\$ '

### Looks like:
# user@host ~/project (main)
# $


# ---------------------------------------------------------------------------- #
# Navigation Improvements                                                      #
# ---------------------------------------------------------------------------- #

# FZF-style reverse search with Ctrl+R (optional if installed)
# Otherwise fallback to default

# Quick up/down history search by prefix
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'


