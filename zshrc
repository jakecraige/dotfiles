#!/bin/zsh

export EDITOR="vim"
export SHELL="/bin/zsh"
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH"
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export NVM_DIR=~/.nvm
LEIN_FAST_TRAMPOLINE=y
export LEIN_FAST_TRAMPOLINE
export ZSH=$HOME/.dotfiles/oh-my-zsh
export ZSH_CUSTOM=$HOME/.dotfiles/zsh_custom
export ZSH_THEME="poetic"
export DISABLE_AUTO_TITLE="true"
export ANDROID_HOME=/usr/local/opt/android-sdk
export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent::1"

plugins=(git osx brew autojump zsh-syntax-highlighting ssh-agent lein)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa

source "$ZSH/oh-my-zsh.sh"

eval "$(rbenv init - zsh --no-rehash)"
source "$(brew --prefix nvm)/nvm.sh"
source "$HOME/.zshrc.private"

# swift OSS
# export PATH=/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:"${PATH}"

export PATH=".git/safe/../../bin:$PATH"
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
