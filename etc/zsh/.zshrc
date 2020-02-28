export PATH="$(find -L ~/bin/ -maxdepth 1 -type d | sed 's|/$||'| tr '\n' ':')$PATH"
export TERMINAL=xst
export TERMINFO=${XDG_CONFIG_HOME:-$HOME/.config}/terminfo
export EDITOR=kak

export CARGO_HOME=${XDG_CONFIG_HOME:-$HOME/.config}/cargo

# History
HISTFILE="${XDG_CACHE_HOME:-~/.cache}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

# Completion
ZSH_COMPDUMP="${XDG_CACHE_HOME:-~/.cache}/zsh/zcompdump-${HOST/.*/}-$ZSH_VERSION"
source $ZDOTDIR/zshcomp

# Options
setopt appendhistory autocd extendedglob
unsetopt beep

# Plugins
# plugins=(git vi-mode zsh-syntax-highlighting zsh-autosuggestions)
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'

source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"

source "$ZDOTDIR/plugins/zsh-vim-mode/zsh-vim-mode.plugin.zsh"
MODE_CURSOR_VICMD="white underline"
MODE_CURSOR_VIINS="white bar"
MODE_CURSOR_SEARCH="white underline"
MODE_CURSOR_VISUAL="white block"
KEYTIMEOUT=1

# Theme
autoload -U colors && colors
source $ZDOTDIR/prompts/boo.zsh-theme

# source "${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs"

# User files to source that are under VC
for file in $(ls $ZDOTDIR/source); do
	source "$ZDOTDIR/source/$file"
done

# User files to source that are NOT under VC
for file in $(ls "${XDG_DATA_HOME:-~/.local/share}/zsh/source"); do
	source "${XDG_DATA_HOME:-~/.local/share}/zsh/source/$file"
done

# Change this
test -f "$BOOTIQUE_OUTPUT_DIR/slop_color" && source "$BOOTIQUE_OUTPUT_DIR/slop_color"
test -f "$BOOTIQUE_OUTPUT_DIR/tty-colors" && "$BOOTIQUE_OUTPUT_DIR/tty-colors"

# less/man colors
export LESS=-R
export LESS_TERMCAP_md=$'\033[1;34m'       # begin blink
export LESS_TERMCAP_{me,ue}=$'\033[0m'     # reset bold/blink and underline
export LESS_TERMCAP_us=$'\033[1;35m'       # begin underline

# kak as pager and man
# export PAGER=kak-pager
# export MANPAGER=kak-man

source /home/boo/etc/broot/launcher/bash/br
