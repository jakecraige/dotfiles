export EDITOR="vim"
export SHELL="/bin/zsh"

export PATH="$HOME/.bin:$PATH"
export PATH="/usr/local/bin:$PATH"
eval "$(rbenv init - zsh --no-rehash)"

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

ZSH=$HOME/.dotfiles/oh-my-zsh
ZSH_CUSTOM=$HOME/.dotfiles/zsh_custom

ZSH_THEME="poetic"
DISABLE_AUTO_TITLE="true"

plugins=(git osx rails brew bower bundle gem vim gem npm tmux tmuxinator autojump zsh-syntax-highlighting jsontools)
source $ZSH/oh-my-zsh.sh

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Default to standard vi bindings, regardless of editor stringj
# / to do backward search
bindkey -v
bindkey "jj" vi-cmd-mode
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd v edit-command-line

plugins+=(lein)
LEIN_FAST_TRAMPOLINE=y
export LEIN_FAST_TRAMPOLINE
alias cljsbuild="lein trampoline cljsbuild $@"

# export CLOJURESCRIPT_HOME="/Users/jake/gitrepos/clojurescript"
# path+=("$CLOJURESCRIPT_HOME/bin")

[[ -f ~/.aliases ]] && source ~/.aliases
