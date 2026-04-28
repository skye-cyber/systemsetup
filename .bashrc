#!/bin/bash
# ============================================================
# KUBUNTU FULLY INITIALIZED BASH CONFIGURATION
# ============================================================
# ~/.bashrc - Comprehensive bash setup with completions,
# colored output, environment paths, and modern tooling
# ============================================================

# ----------------------------------------------------------
# 1. SHELL OPTIONS & BEHAVIOR
# ----------------------------------------------------------

# Prevent duplicate entries in history
HISTCONTROL=ignoreboth:erasedups

# Append to history file, don't overwrite
shopt -s histappend

# Auto cd
shopt -s autocd

# History size settings
HISTSIZE=10000
HISTFILESIZE=20000

# Check window size after each command and update LINES/COLUMNS
shopt -s checkwinsize

# Enable globstar for recursive globbing (e.g., **/*.txt)
shopt -s globstar 2>/dev/null

# Enable cd spell correction
shopt -s cdspell 2>/dev/null

# Enable directory name completion
shopt -s dirspell 2>/dev/null

# Enable extended pattern matching
shopt -s extglob

# Enable programmable completion
shopt -s progcomp

# ----------------------------------------------------------
# 2. COLOR SUPPORT & TERMINAL
# ----------------------------------------------------------

# Enable color support for ls, grep, and other commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    # Color aliases
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
fi

# Force colored GCC warnings/errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Colored man pages using less
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# ----------------------------------------------------------
# 3. CUSTOM PROMPT (Powerline-style with Git integration)
# ----------------------------------------------------------

# Function to get current git branch
git_branch() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        local status=""
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
            status="*"  # Uncommitted changes
        fi
        if [ -n "$(git log --branches --not --remotes --oneline 2>/dev/null)" ]; then
            status="${status}+"  # Unpushed commits
        fi
        echo " ($branch$status)"
    fi
}

# Function to get virtual environment name
venv_name() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo " ($(basename "$VIRTUAL_ENV"))"
    fi
}

# Build the prompt
# Format: [user@host:path] (venv) (git-branch) $
# Colors: user@host=cyan, path=green, git=yellow, root=red
if [ "$EUID" -eq 0 ]; then
    # Root user prompt (red)
    PS1='\[\e[1;31m\][\u@\h:\w]\[\e[0m\]\[\e[1;33m\]$(git_branch)\[\e[0m\]\[\e[1;35m\]$(venv_name)\[\e[0m\] \[\e[1;31m\]#\[\e[0m\] '
else
    # Normal user prompt
    PS1='\[\e[1;36m\][\u@\h:\[\e[1;32m\]\w\[\e[1;36m\]]\[\e[0m\]\[\e[1;33m\]$(git_branch)\[\e[0m\]\[\e[1;35m\]$(venv_name)\[\e[0m\] \[\e[1;32m\]\$\[\e[0m\] '
fi

# Continuation prompt
PS2='\[\e[1;33m\]...\[\e[0m\] '

# Xterm title update
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"'

# ----------------------------------------------------------
# 4. ENVIRONMENT PATHS
# ----------------------------------------------------------

# User local binaries
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# User binaries
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

# Cargo (Rust)
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Go
if [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi
export GOPATH="$HOME/go"

# Node.js global packages (npm/pnpm)
if [ -d "$HOME/.npm-global/bin" ]; then
    export PATH="$HOME/.npm-global/bin:$PATH"
fi
if [ -d "$HOME/.local/share/pnpm" ]; then
    export PATH="$HOME/.local/share/pnpm:$PATH"
fi

# Poetry (Python)
if [ -d "$HOME/.poetry/bin" ]; then
    export PATH="$HOME/.poetry/bin:$PATH"
fi

# Pyenv
if [ -d "$HOME/.pyenv/bin" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
fi

# SDKMAN (Java/Kotlin/Scala)
export SDKMAN_DIR="$HOME/.sdkman"
if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Android SDK
if [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_HOME="$HOME/Android/Sdk"
    export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
fi

# Flutter
if [ -d "$HOME/flutter/bin" ]; then
    export PATH="$HOME/flutter/bin:$PATH"
fi

# Deno
if [ -d "$HOME/.deno/bin" ]; then
    export PATH="$HOME/.deno/bin:$PATH"
fi

# Bun
if [ -d "$HOME/.bun/bin" ]; then
    export PATH="$HOME/.bun/bin:$PATH"
fi

# Snap packages
if [ -d "/snap/bin" ]; then
    export PATH="/snap/bin:$PATH"
fi

# Flatpak
if [ -d "/var/lib/flatpak/exports/bin" ]; then
    export PATH="/var/lib/flatpak/exports/bin:$PATH"
fi
if [ -d "$HOME/.local/share/flatpak/exports/bin" ]; then
    export PATH="$HOME/.local/share/flatpak/exports/bin:$PATH"
fi

# ----------------------------------------------------------
# 5. DEFAULT APPLICATIONS & EDITORS
# ----------------------------------------------------------

# Default editor priority: nvim > vim > nano
if command -v nvim &> /dev/null; then
    export EDITOR='nano'
    export VISUAL='nano'
    alias vim='nvim'
elif command -v vim &> /dev/null; then
    export EDITOR='vim'
    export VISUAL='vim'
else
    export EDITOR='nvim'
    export VISUAL='nvim'
fi

# Pager
export PAGER='less'
export LESS='-R -i -g -c -W -M -z-4'

# Bat as cat replacement (if installed)
if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Eza as ls replacement (if installed)
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first --icons'
    alias ll='eza -l --group-directories-first --icons'
    alias la='eza -la --group-directories-first --icons'
    alias lt='eza --tree --group-directories-first --icons'
    alias l.='eza -la --group-directories-first --icons .*'
fi

# ----------------------------------------------------------
# 6. USEFUL ALIASES
# ----------------------------------------------------------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Directory listing (fallback if eza not installed)
if ! command -v eza &> /dev/null; then
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias l.='ls -d .* --color=auto'
fi

# File operations with safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -pv'

# Disk usage
alias df='df -h'
alias du='du -h'
alias dus='du -sh'
# no -h as is aliased in du above
alias dusort='du -s * | sort -rh | head -20'

# System info
alias meminfo='free -h -l -t'
alias cpuinfo='lscpu'
alias gpumem='nvidia-smi'
alias psu='ps auxf'
alias psg='ps aux | grep -v grep | grep -i'
alias topcpu='ps auxf | sort -nr -k 3 | head -10'
alias topmem='ps auxf | sort -nr -k 4 | head -10'

# Network
alias ports='netstat -tulanp 2>/dev/null || netstat -tulan'
alias myip='curl -s ipinfo.io/ip'
alias localip='ip addr show | grep "inet " | grep 127.0.0.1'
alias pingg='ping -c 5 google.com'
alias wget='wget -c'

# Search
alias fhere='find . -name'
alias ftext='grep -rnw . -e'
alias hist='history | grep'

# Archives
alias untar='tar -xvf'
alias ungz='tar -xzvf'
alias unbz2='tar -xjvf'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias gl='git log --oneline --graph --decorate'
alias gll='git log --graph --pretty=format:"%C(auto)%h%d %s %C(black)%C(bold)%cr"'
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git stash'
alias gsp='git stash pop'

# Docker shortcuts
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\\t{{.Status}}\\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\\t{{.Status}}\\t{{.Ports}}"'
alias di='docker images'
alias dv='docker volume ls'
alias dn='docker network ls'
alias dl='docker logs -f'
alias dex='docker exec -it'
alias dprune='docker system prune -af --volumes'

# Kubernetes shortcuts
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'

# APT shortcuts
alias aptupd='sudo apt update'
alias aptupg='sudo apt update && sudo apt upgrade -y'
alias aptin='sudo apt install'
alias aptrm='sudo apt remove'
alias aptar='sudo apt autoremove'
alias aptse='apt search'
alias aptsh='apt show'

# Flatpak shortcuts
alias fpup='flatpak update -y'
alias fpin='flatpak install'
alias fprm='flatpak uninstall'
alias fpls='flatpak list'

# Clipboard
alias cpy='xclip -selection clipboard'
alias pst='xclip -selection clipboard -o'

# Misc
alias please='sudo'
alias zshconfig='$EDITOR ~/.zshrc'
alias bashconfig='$EDITOR ~/.bashrc'
alias reload='source ~/.bashrc'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias week='date +%V'
alias timer='echo "Timer started. Stop with Ctrl+D." && date && time cat && date'

# Program Command aliases
alias python=python3

# ----------------------------------------------------------
# 7. SHELL COMPLETIONS
# ----------------------------------------------------------

# Enable bash completion in interactive shells
if ! shopt -oq posix; then
    # System-wide bash completion
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi

    # User-local completions
    if [ -d ~/.bash_completion.d ]; then
        for f in ~/.bash_completion.d/*; do
            [ -f "$f" ] && source "$f"
        done
    fi
fi

# Git completion (if available)
if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
fi

# Docker completion
if command -v docker &> /dev/null; then
    if [ -f /usr/share/bash-completion/completions/docker ]; then
        source /usr/share/bash-completion/completions/docker
    elif command -v docker &> /dev/null; then
        docker completion bash 2>/dev/null | source /dev/stdin 2>/dev/null
    fi
fi

# kubectl completion
if command -v kubectl &> /dev/null; then
    source <(kubectl completion bash 2>/dev/null)
    complete -o default -F __start_kubectl k
fi

# Helm completion
if command -v helm &> /dev/null; then
    source <(helm completion bash 2>/dev/null)
fi

# Terraform completion
if command -v terraform &> /dev/null; then
    complete -C /usr/bin/terraform terraform
fi

# AWS CLI completion
if command -v aws &> /dev/null; then
    complete -C '/usr/local/bin/aws_completer' aws 2>/dev/null || \
    complete -C 'aws_completer' aws 2>/dev/null
fi

# Rust (cargo) completion
if command -v rustup &> /dev/null; then
    source <(rustup completions bash 2>/dev/null)
    source <(rustup completions bash cargo 2>/dev/null)
fi

# Poetry completion
if command -v poetry &> /dev/null; then
    source <(poetry completions bash 2>/dev/null)
fi

# ----------------------------------------------------------
# 10. BLE.SH - BASH LINE EDITOR (Autosuggestions & Syntax Highlighting)
# ----------------------------------------------------------
# ble.sh brings fish/zsh-like features to bash:
# - Auto-suggestions from history (gray text, accept with Right Arrow)
# - Syntax highlighting (valid commands green, invalid red)
# - Menu completion with arrow key navigation
# - Vim/emacs editing modes

# Auto-install ble.sh if not present
if [[ ! -f ~/.local/share/blesh/ble.sh ]]; then
    echo "ble.sh not found. Installing..."
    if command -v git &> /dev/null; then
        temp_dir=$(mktemp -d)
        git clone --recursive --depth 1 --shallow-submodules \
            https://github.com/akinomyoga/ble.sh.git "$temp_dir" 2>/dev/null
        if [[ -d "$temp_dir" ]]; then
            make -C "$temp_dir" install PREFIX=~/.local 2>/dev/null
            rm -rf "$temp_dir"
            echo "ble.sh installed. Restart your terminal to activate."
        fi
    else
        echo "git not found. Install git and run: make -C ble.sh install PREFIX=~/.local"
    fi
fi

# Completion using blesh--Source ble.sh
if [[ -f ~/.local/share/blesh/ble.sh ]]; then
    source ~/.local/share/blesh/ble.sh

    # ble.sh configuration
    # Suggestion color (gray like zsh-autosuggestions)
    ble-face -s auto_complete 'fg=240,bg=default'

    # Syntax highlighting colors
    ble-face -s syntax_default 'fg=default'
    ble-face -s syntax_command 'fg=green,bold'
    ble-face -s syntax_quoted 'fg=cyan'
    ble-face -s syntax_quotation 'fg=cyan,bold'
    ble-face -s syntax_error 'fg=red,bold'
    ble-face -s syntax_expr 'fg=default'
    ble-face -s syntax_varname 'fg=208'
    ble-face -s syntax_function_name 'fg=yellow,bold'
    ble-face -s syntax_comment 'fg=242'
    ble-face -s syntax_document 'fg=242'
    ble-face -s syntax_delimiter 'bold'
    ble-face -s syntax_escape 'fg=magenta'
    ble-face -s syntax_glob 'fg=198,bold'
    ble-face -s syntax_brace 'fg=37,bold'
    ble-face -s syntax_tilde 'fg=navy,bold'
    ble-face -s syntax_param_expansion 'fg=purple'
    ble-face -s syntax_history_expansion 'bg=94,fg=231'

    # Command-type faces (aliases, builtins, functions, files)
    ble-face -s command_alias 'fg=teal'
    ble-face -s command_builtin 'fg=red'
    ble-face -s command_builtin_dot 'fg=red,bold'
    ble-face -s command_function 'fg=92'
    ble-face -s command_file 'fg=green'
    ble-face -s command_keyword 'fg=blue'
    ble-face -s command_directory 'fg=26,underline'
    ble-face -s command_jobs 'fg=red'

    # Filename faces
    ble-face -s filename_directory 'underline,fg=26'
    ble-face -s filename_executable 'underline,fg=green'
    ble-face -s filename_link 'underline,fg=teal'
    ble-face -s filename_orphan 'underline,fg=teal,bg=224'
    ble-face -s filename_setuid 'underline,fg=black,bg=220'
    ble-face -s filename_setgid 'underline,fg=black,bg=191'
    ble-face -s filename_socket 'underline,fg=cyan,bg=black'
    ble-face -s filename_pipe 'underline,fg=lime,bg=black'

    # Variable faces
    ble-face -s varname_array 'fg=orange,bold'
    ble-face -s varname_empty 'fg=31'
    ble-face -s varname_export 'fg=200,bold'
    ble-face -s varname_expr 'fg=92,bold'
    ble-face -s varname_hash 'fg=70,bold'
    ble-face -s varname_number 'fg=64'
    ble-face -s varname_readonly 'fg=200'
    ble-face -s varname_transform 'fg=29,bold'
    ble-face -s varname_unset 'fg=124'

    # Argument faces
    ble-face -s argument_option 'fg=teal'
    ble-face -s argument_error 'fg=black,bg=225'

    # Enable menu completion with arrow keys
    bleopt complete_menu_style=desc
    bleopt complete_menu_maxlines=10

    # History settings for ble.sh
    bleopt history_share=1

    # Key bindings for ble.sh auto-complete
    # Ctrl+Space: accept full suggestion
    # ble-bind -m auto_complete -f C-SP auto_complete/complete

    # Right arrow: accept full suggestion
    # ble-bind -m auto_complete -f right auto_complete/complete

    # Ctrl+F: accept one word
    # ble-bind -m auto_complete -f C-f auto_complete/next
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi

# FZF integration
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
elif [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
    source /usr/share/doc/fzf/examples/completion.bash
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi

# Starship prompt (if installed - overrides custom PS1)
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# ----------------------------------------------------------
# 8. ENVIRONMENT VARIABLES
# ----------------------------------------------------------

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Python
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export PYTHONSTARTUP="$HOME/.pythonrc"

# Node.js
export NODE_ENV=development

# Java
if [ -d /usr/lib/jvm/default-java ]; then
    export JAVA_HOME=/usr/lib/jvm/default-java
fi

# Qt/KDE specific
export QT_QPA_PLATFORMTHEME=gtk2
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# GPG
export GPG_TTY=$(tty)

# SSH Agent (auto-start if not running)
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# ----------------------------------------------------------
# 9. FUNCTIONS
# ----------------------------------------------------------

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1" || exit
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.tar.xz)    tar xJf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"      ;;
            *.deb)       dpkg-deb -x "$1" "${1%.deb}" ;;
            *)           echo "'"$1"' cannot be extracted via extract()" ;;
        esac
    else
        echo "'"$1"' is not a valid file"
    fi
}

# Quick file backup with timestamp
backup() {
    cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# Find and replace in files
replace() {
    if [ $# -ne 3 ]; then
        echo "Usage: replace <search> <replace> <file>"
        return 1
    fi
    sed -i "s/$1/$2/g" "$3"
}

# Show weather (requires curl)
weather() {
    local city="${1:-}"
    curl -s "wttr.in/${city}?format=3" || echo "Install curl or check internet"
}

# Quick HTTP server
serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Generate random password
genpass() {
    local length="${1:-16}"
    < /dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*' | head -c "$length"; echo
}

# Show directory sizes
dirsize() {
    du -sh */ 2>/dev/null | sort -rh
}

# Quick note taking
note() {
    local notes_dir="$HOME/notes"
    mkdir -p "$notes_dir"
    if [ -z "$1" ]; then
        $EDITOR "$notes_dir/$(date +%Y-%m-%d).md"
    else
        echo "$(date '+%Y-%m-%d %H:%M') - $*" >> "$notes_dir/quicknotes.md"
        echo "Note saved."
    fi
}

# Search and open file with fzf
fo() {
    local file
    file=$(fzf --query="$1" --select-1 --exit-0)
    [ -n "$file" ] && xdg-open "$file"
}

# Search and edit file with fzf
fe() {
    local file
    file=$(fzf --query="$1" --select-1 --exit-0)
    [ -n "$file" ] && $EDITOR "$file"
}

# ----------------------------------------------------------
# 10. KUBUNTU/KDE SPECIFIC
# ----------------------------------------------------------

# Enable KDE/GTK application integration
export GTK_USE_PORTAL=1

# KDE Connect aliases
alias kdec='kdeconnect-cli'
alias kdecdev='kdeconnect-cli -l'

# Dolphin file manager from terminal
alias dol='dolphin . > /dev/null 2>&1 &'

# Konsole new tab
alias kon='konsole > /dev/null 2>&1 &'

# ----------------------------------------------------------
# 11. FINAL SETUP
# ----------------------------------------------------------

# Source local customizations (keep at end)
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

# Source aliases from .bash_aliases if it exists
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Enable stty sane settings
stty sane

# Clear screen shortcut
bind '"\C-l": clear-screen'

# Ignore case in tab completion
bind 'set completion-ignore-case on'

# Show completion list immediately
bind 'set show-all-if-ambiguous on'

# Mark symlinked directories
bind 'set mark-symlinked-directories on'

# Welcome message
echo -e "\e[1;32mWelcome to Kubuntu, \e[1;36m$USER\e[0m\e[1;32m!\e[0m"
echo -e "\e[0;90m$(date '+%A, %B %d %Y - %H:%M')\e[0m"
if command -v neofetch &> /dev/null; then
    neofetch --disable packages resolution theme icons term --color_blocks off 2>/dev/null
fi

# export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
