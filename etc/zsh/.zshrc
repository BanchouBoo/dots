. "${XDG_CONFIG_HOME:=$HOME/.config}"
. "${XDG_DATA_HOME:=$HOME/.local/share}"
. "${XDG_CACHE_HOME:=~/.cache}"
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME

### XDG COMPATIBILITY
HISTFILE="$XDG_CACHE_HOME/zsh/history"
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-${HOST/.*/}-$ZSH_VERSION"

export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export LESSHISTFILE="$XDG_CACHE_HOME/less/hist"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# Add ~/bin/ and it's subfolders to the path
PATH="$CARGO_HOME/bin:$PATH"
export PATH="$HOME/bin/wrappers:$(find -L $HOME/bin/ -maxdepth 2 -type d -not -name '*wrappers' -not -name '.*' | sed 's|/$||'| tr '\n' ':')$PATH"

# Assign programs to variables
export TERMINAL=st
export EDITOR=kak

# History
HISTSIZE=10000
SAVEHIST=10000

# Completion
source $ZDOTDIR/zshcomp

# Options
setopt appendhistory autocd extendedglob
unsetopt beep

### PLUGINS
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'

source "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

source "$ZDOTDIR/plugins/zsh-vim-mode/zsh-vim-mode.plugin.zsh"
MODE_CURSOR_VICMD="white underline"
MODE_CURSOR_VIINS="white bar"
MODE_CURSOR_SEARCH="white underline"
MODE_CURSOR_VISUAL="white block"
KEYTIMEOUT=1

source "$ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"

# Theme
autoload -U colors && colors
source $ZDOTDIR/prompts/star.zsh-theme

# User files to source that are under VC
find "$ZDOTDIR/source" -type f | while read -r file; do
	source "$file"
done

# User files to source that are NOT under VC
find "$XDG_DATA_HOME/zsh/source" -type f | while read -r file; do
	source "$file"
done

# Change this
test -f "$BOOTIQUE_OUTPUT_DIR/tty-colors" && "$BOOTIQUE_OUTPUT_DIR/tty-colors"

# less/man colors
export LESS=-R
export LESS_TERMCAP_md=$'\033[1;34m'       # begin blink
export LESS_TERMCAP_{me,ue}=$'\033[0m'     # reset bold/blink and underline
export LESS_TERMCAP_us=$'\033[1;35m'       # begin underline

# Local man path
export MANPATH="$HOME/bin/man:/usr/share/man"

# SSH Agent location
export SSH_AUTH_SOCK="$HOME/.ssh/agent"

### SHORTCUTS

function src {
	cd ~/opt/void-packages/
}

function dots {
	cd ~/opt/dots/
}

function pdots {
	cd ~/opt/dots/pdots/
}

function suckless {
	cd ~/opt/suckless/
}

function kakrc {
	current_dir="$PWD"
	dots
	kak etc/kak/kakrc
	cd "$current_dir"
}
