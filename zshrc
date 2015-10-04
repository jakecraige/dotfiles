export EDITOR="vim"
export SHELL="/bin/zsh"
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/.bin:$PATH"
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export NVM_DIR=~/.nvm
LEIN_FAST_TRAMPOLINE=y
export LEIN_FAST_TRAMPOLINE
ZSH=$HOME/.dotfiles/oh-my-zsh
ZSH_CUSTOM=$HOME/.dotfiles/zsh_custom
ZSH_THEME="poetic"
DISABLE_AUTO_TITLE="true"
path+=("$HOME/.dotfiles/powerline/scripts")

plugins=(git osx brew autojump zsh-syntax-highlighting ssh-agent lein)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa

source $ZSH/oh-my-zsh.sh

eval "$(rbenv init - zsh --no-rehash)"
source $(brew --prefix nvm)/nvm.sh

export PATH=".git/safe/../../bin:$PATH"
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
