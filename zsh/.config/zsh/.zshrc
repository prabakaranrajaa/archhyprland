# --- First add /etc/zsh/zprofile
# add this line --> export ZDOTDIR="$HOME/.config/zsh"   
# main zsh settings. env in ~/.zprofile

# EARLY INIT (ALLOWED TO PRINT)
# command-not-found (Arch / pkgfile)
if [[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
  source /usr/share/doc/pkgfile/command-not-found.zsh
fi

# fastfetch (once per session)
if [[ -z "$FASTFETCH_SHOWN" ]] && command -v fastfetch >/dev/null; then
  FASTFETCH_SHOWN=1
  fastfetch
fi

# Powerlevel10k Instant Prompt (MUST BE SILENT & FIRST)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------- Shell Options / Behavior --------------------
# Directory navigation
setopt autocd             # Change directory just by typing its name
setopt autopushd          # Push directory onto the stack with cd

# Command behavior
setopt correct            # Attempt to auto-correct commands
setopt complete_in_word   # Autocomplete within a word
setopt extended_glob      # Enable advanced globbing
setopt magicequalsubst    # Enable filename expansion like var=expression
setopt nonomatch          # Hide error if a glob pattern matches nothing
setopt no_clobber         # Prevent overwriting files with >

# Prompt & interactive tweaks
setopt promptsubst            # Enable command substitution in prompt
setopt interactive_comments   # Allow comments (#) in interactive shells
setopt no_beep                # Disable terminal beep on errors
setopt notify                 # Report background job status immediately
setopt numeric_glob_sort      # Sort filenames numerically when possible
setopt no_flow_control        # Disable Ctrl+S / Ctrl+Q terminal flow control

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word
PROMPT_EOL_MARK=""         # hide EOL sign ('%')

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# -------------------- History Settings --------------------
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zsh_history" # move histfile to cache
HISTSIZE=100000                   # Number of commands to keep in memory
SAVEHIST=100000                   # Number of commands to save in the history file

# History behavior
setopt append_history             # Append new history to the file, rather than overwriting
setopt inc_append_history         # Save each command to the history file as it's entered
setopt share_history              # Share history across all Zsh sessions
setopt hist_ignore_all_dups       # Remove all duplicate commands from the history
setopt hist_ignore_dups           # Ignore consecutive duplicates
setopt hist_ignore_space          # Ignore commands that start with a space
setopt hist_verify                # Verify history commands before executing
setopt hist_save_no_dups          # Don't write duplicate commands to the history file

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# FZF
if command -v fzf >/dev/null; then
  source <(fzf --zsh) 2>/dev/null
  bindkey '^R' fzf-history-widget
fi

# Zsh Plugins: Syntax Highlighting, Autosuggestions, Vi Mode
# -------------------- Syntax Highlighting --------------------
# MUST be last plugin to source
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# -------------------- Autosuggestions --------------------
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)

    # Bind autosuggestions only in vi insert mode
    bindkey -M viins '^e' autosuggest-accept   # Ctrl+E to accept suggestion
    bindkey -M viins '^w' autosuggest-execute  # Ctrl+W to execute suggestion
    bindkey -M viins '^t' autosuggest-toggle   # Ctrl+T to toggle suggestion
fi

# -------------------- Zsh Vi Mode --------------------
# Optional: start in insert mode (uncomment if needed)
# ZVM_LINE_INIT_MODE=insert        

ZVM_VI_INSERT_ESCAPE_BINDKEY=jj  # 'jj' leaves insert mode
ZVM_INIT_MODE=sourcing           # faster startup
ZVM_PROMPT_SYMBOLS=(INSERT:NORMAL)

if [[ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi

# History Filter: Save only successful commands
# zshaddhistory is called before a command is saved
zshaddhistory() {
    # Remove line continuations for cleaner history
    LASTHIST=${1//\\\\$\'\\n\'/}
    # Return 2 to save to internal history but not write to file yet
    return 2
}

# precmd is called before each prompt
precmd() {
    # Save last command to history only if it succeeded
    if [[ $? -eq 0 && -n ${LASTHIST//[[:space:]\\n]/} && -n $HISTFILE ]]; then
        print -sr -- ${=${LASTHIST%%\'\\n\'}}
    fi
}

# Tools
# Zoxide
eval "$(zoxide init zsh)"

# Yazi
y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    cd "$cwd"
  fi
  rm -f "$tmp"
}

# Neovim shortcut
n() { [[ $# -eq 0 ]] && nvim . || nvim "$@"; }

# Aliases
# -------------------- Directory Shortcuts --------------------
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# -------------------- Yay / Package Shortcuts --------------------
# Fuzzy search installed packages with preview and install on Enter
alias yayf='yay -Qq | fzf --preview "yay -Qi {}" --bind "enter:execute(yay -S {} --noconfirm)"'

# -------------------- Web Shortcuts --------------------
# Open websites in qutebrowser with minimal UI
alias yt='nohup qutebrowser --set tabs.show never --set window.hide_decoration true --target window https://www.youtube.com >/dev/null 2>&1 & disown'
alias x='nohup qutebrowser --set tabs.show never --set window.hide_decoration true --target window https://www.x.com >/dev/null 2>&1 & disown'
alias fb='nohup qutebrowser --set tabs.show never --set window.hide_decoration true --target window https://www.facebook.com >/dev/null 2>&1 & disown'
alias ins='nohup qutebrowser --set tabs.show never --set window.hide_decoration true --target window https://www.instagram.com >/dev/null 2>&1 & disown'
alias wa='nohup qutebrowser --set tabs.show never --set window.hide_decoration true --target window https://web.whatsapp.com >/dev/null 2>&1 & disown'

# -------------------- Git Aliases --------------------
# Core Git Aliases
alias gi="git init"                  # Initialize a new Git repository
alias gib="git init --bare"          # Create a bare Git repository
alias ga="git add ."                 # Stage all changes
alias gadd="git add"                 # Add specific files to the staging area
alias gc="git commit -m"             # Commit changes with a message
alias gca="git commit -a -m"         # Commit all changes with a message
alias gst="git status"               # Show the status of the repository
alias gsr="git status -s"            # Show a summarized status of the repository
alias gl="git log"                   # Display commit logs
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit" # Graphical log
alias glpr="git log --pretty=format:\"%C(yellow)%h%Creset - %Cred%d%Creset %s %C(bold green)(%cr)%Creset %C(blue)<%an>\"" # Pretty log format
alias gdiff="git diff"               # Show changes between commits, branches, or working trees

# Branch Management
alias gb="git branch"                # List local branches
alias gba="git branch -a"            # List all branches, including remote ones
alias gcb="git checkout -b"          # Create and switch to a new branch
alias gch="git checkout"             # Switch to another branch
alias gcoall="git checkout -- ."     # Discard changes to all tracked files
alias grb="git branch -d"            # Delete a local branch

# Remote and Merging
alias gr="git remote"                # Manage set of tracked repositories
alias grmt="git remote -v"           # List remote repositories with URLs
alias grso="git remote show origin"  # Show detailed info about the remote 'origin'
alias gm="git merge"                 # Merge the specified branch
alias gpoa="git push -u origin --all" # Push all local branches to remote 'origin'
alias gp="git push origin HEAD"      # Push the current branch to remote 'origin'
alias gpu="git pull origin"          # Pull the latest changes from remote 'origin'

# Reset and Checkout
alias gre="git reset"                # Reset the current HEAD to a specific state
alias gco="git checkout"             # Checkout a branch or paths to the working tree

# -------------------- Docker Aliases --------------------
# Docker Compose Aliases
alias dco="docker compose"     # Simplified 'docker compose' command

# General Docker Aliases
alias dk="docker"                     # Shortcut for Docker command
alias dr="docker run"                 # Run a Docker container
alias drit="docker run -it"           # Run a container interactively
alias dritrm="docker run -it --rm"    # Run and auto-remove a container after exit

# Container Management Aliases
alias dps="docker ps"                 # List running containers
alias dpa="docker ps -a"              # List all containers, including stopped ones
alias dl="docker ps -l -q"            # Get the last used container's ID
alias dpss="docker ps -s"             # Show container sizes
alias dx="docker exec -it"            # Execute commands inside a running container

# Image Management Aliases
alias dimg="docker images"            # List all Docker images
alias drmi="docker rmi"               # Remove a specific image
alias drmiall="docker rmi -f \$(docker images -q)" # Force remove all images

# Container Start/Stop Aliases
alias dstart="docker start"           # Start a stopped container
alias dstop="docker stop"             # Stop a running container
alias drm="docker rm"                 # Remove a specific container
alias drmall="docker rm -f \$(docker ps -a -q)" # Force remove all containers

# Volume Management Aliases
alias dvc="docker volume create"      # Create a new Docker volume
alias dvls="docker volume ls"         # List all Docker volumes
alias dvrm="docker volume rm"         # Remove a specific Docker volume

# -------------------- Eza Aliases --------------------
# File system
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

alias cat='bat'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# -------------------- Shell Switching --------------------
# switch between shells
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
#alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"

# Powerlevel10k Theme
source /usr/share/zsh/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.config/zsh/.p10k.zsh ]] && source ~/.config/zsh/.p10k.zsh
