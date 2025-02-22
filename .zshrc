: ${XDG_DATA_HOME:=${HOME}/.local/share}
: ${XDG_CONFIG_HOME:=${HOME}/.config}
: ${XDG_STATE_HOME:=${HOME}/.local/state}
: ${XDG_CACHE_HOME:=${HOME}/.cache}
export XDG_DATA_HOME XDG_CONFIG_HOME XDG_STATE_HOME XDG_CACHE_HOME

autoload -U compinit promptinit select-word-style
compinit
promptinit
prompt gentoo

setopt autocd
setopt extendedglob

# WORDCHARS doesn't seem to be working with normal, so bash lets
# path separators act as word separators
select-word-style bash

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt SHARE_HISTORY
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="${XDG_CACHE_HOME}/zsh/history"

# completion cache
zstyle ':completion::complete:*' use-cache 1

bindkey -e

# context-sensitive history navigation
bindkey '^[[A' up-line-or-search
bindkey '^p' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^n' down-line-or-search

# include $HOME/.local/bin and all immediate subdirectories in $PATH
PATH="$(find ${HOME}/.local/bin -maxdepth 1 -type d | paste -s -d ':'):${PATH}"

export _ZO_ECHO=1
export _ZO_RESOLVE_SYMLINKS=1
source <(zoxide init zsh --cmd cd)

export FZF_DEFAULT_OPTS="-m"
source <(fzf --zsh)
source "${HOME}/git/fzf-tab-completion/zsh/fzf-zsh-completion.sh"
bindkey '^I' fzf_completion
# TODO: do this globally on all path completions
zstyle ':completion::*:cd:*' fzf-completion-keybindings /:accept:'repeat-fzf-completion'
zstyle ':completion::*:ls:*' fzf-completion-keybindings /:accept:'repeat-fzf-completion'

source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh

alias dots="git --git-dir=${HOME}/.dots --work-tree=$HOME"
alias lazydots="lazygit --git-dir=${HOME}/.dots --work-tree=$HOME"

