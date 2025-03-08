: ${XDG_DATA_HOME:=${HOME}/.local/share}
: ${XDG_CONFIG_HOME:=${HOME}/.config}
: ${XDG_STATE_HOME:=${HOME}/.local/state}
: ${XDG_CACHE_HOME:=${HOME}/.cache}
export XDG_DATA_HOME XDG_CONFIG_HOME XDG_STATE_HOME XDG_CACHE_HOME

zsh_cache_dir=${XDG_CACHE_HOME}/zsh
zsh_plugin_dir=${XDG_CONFIG_HOME}/zsh/plugins

autoload -U compinit select-word-style
compinit -d "${zsh_cache_dir}/compdump"

prompt () {
    unset PS1
    if [ -n "$RANGER_LEVEL" ]; then
        PS1+='[%F{magenta}ranger%f] '
    fi
    PS1+='[%F{blue}%B%~%b%f]'
    if [ -d ".git" ]; then
        head="$(< .git/HEAD)"
        head=${head#*refs/heads/}
        # if head is a specific commit, try to find tag name
	[ -f .git/packed-refs ] && while read -r line; do
            [[ "$line" == '#'* ]] && continue
            line_arr=(${=line})
            commit=$line_arr[1]
            ref=$line_arr[2]
            [ "$head" = "$commit" ] && [[ "$ref" == "refs/tags"* ]] &&
                head="${ref#refs/tags/}"
        done < .git/packed-refs
        PS1+=" [%F{yellow}${head}%f]"
    fi
    PS1+=$'\n'
    PS1+='%F{%(?.green.red)}%(?.❯.🞬)%f '
}
precmd_functions+=(prompt)

setopt autocd
setopt extendedglob

# WORDCHARS doesn't seem to be working with normal, so bash lets
# path separators act as word separators
select-word-style bash

setopt hist_ignore_all_dups
setopt hist_ignore_space # don't save commands that start with space
setopt share_history # share history between zsh instances
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="${zsh_cache_dir}/history"

# completion cache
zstyle ':completion:*' use-cache 1
zstyle ':completion:*' cache-path "${zsh_cache_dir}/completion-cache"

# case insensitive completion + match anywhere in name
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

bindkey -e

# context-sensitive history navigation
bindkey '^[[A' up-line-or-search
bindkey '^p' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^n' down-line-or-search

# include $HOME/.local/bin and all subdirectories in $PATH
typeset -U path # prevents duplicate entries
path=(${HOME}/.local/bin ${HOME}/.local/bin/**/*(/) $path)
path=(${HOME}/misc/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin $path)

export _ZO_RESOLVE_SYMLINKS=1
source <(zoxide init zsh --cmd cd)

source <(fzf --zsh)
source "${zsh_plugin_dir}/fzf-tab/fzf-tab.plugin.zsh"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1p --color=always $realpath'

source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh

alias dots="git --git-dir=${HOME}/.dots --work-tree=$HOME"
alias lazydots="lazygit --git-dir=${HOME}/.dots --work-tree=$HOME"

alias ls="ls --color --group-directories-first -hvp"
alias grep="grep --color"
alias lg="lazygit"

ranger () {
    # prevent nesting
    if [ -n "$RANGER_LEVEL" ]; then
        exit
    fi
    local file=/tmp/rangerdir
    "$commands[ranger]" --choosedir="${file}" "$@" < "$TTY"
    # redirect necessary because of zoxide printing directory
    cd $(< "$file") >/dev/null
    zle && zle reset-prompt
}
zle -N ranger
bindkey '^[r' ranger
