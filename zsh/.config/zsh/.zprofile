#!/bin/sh
# Login environment (zprofile)
# ZDOTDIR should be set in /etc/zsh/zshenv:
#   export ZDOTDIR="$HOME/.config/zsh"

export GTK_THEME=Adwaita:dark

### XDG Base Directories (must come first)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_MUSIC_DIR="$HOME/Music"

### Default programs
export EDITOR="nvim"
export TERMINAL="kitty"
export MUSICPLAYER="rmpc"
export BROWSER="qutebrowser"
export BROWSER2="brave"

### Locale
export LANG="en_US.UTF-8"

### History files
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

### PATH setup
# Custom scripts first
export PATH="$XDG_CONFIG_HOME/scripts:$PATH"

### Go
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export PATH="$PATH:$GOBIN"

### Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$PATH:$CARGO_HOME/bin"

### Node / npm (fully XDG-compliant)
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export PATH="$PATH:$NPM_CONFIG_PREFIX/bin"

### X11 / GTK
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export XPROFILE="$XDG_CONFIG_HOME/x11/xprofile"
export XRESOURCES="$XDG_CONFIG_HOME/x11/xresources"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"

### Networking / CLI tools
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export CURL_HOME="$XDG_CONFIG_HOME/curl"

### Python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PIP_CONFIG_FILE="$XDG_CONFIG_HOME/pip/pip.conf"

### Security / Keys
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
# OpenSSH does NOT respect SSH_HOME; keep ~/.ssh or symlink it

### Java / JVM
export JAVA_TOOL_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export _JAVA_AWT_WM_NONREPARENTING=1

### Gradle / NuGet
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"

### Parallel / ffmpeg
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"

### Wine
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
