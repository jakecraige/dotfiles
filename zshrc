#!/bin/zsh

export EDITOR="vim"
export SHELL="/bin/zsh"
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/.bin:$PATH"
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export ZSH=$HOME/.dotfiles/oh-my-zsh
export ZSH_CUSTOM=$HOME/.dotfiles/zsh_custom
export ZSH_THEME="poetic"
export DISABLE_AUTO_TITLE="true"
export ANDROID_SDK_ROOT="$(brew --prefix)/share/android-sdk"
export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
export PATH="$PATH:`yarn global bin`"
export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent::1"
# Temp attempt to fix listen issue https://github.com/rails/rails/issues/26158
export DISABLE_SPRING=1

plugins=(git osx brew autojump zsh-syntax-highlighting ssh-agent)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa

source "$ZSH/oh-my-zsh.sh"

eval "$(rbenv init - zsh --no-rehash)"
source "$HOME/.zshrc.private"

autoload bashcompinit
bashcompinit
source "$HOME/.asdf/completions/asdf.bash"

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

export PATH=".git/safe/../../bin:$PATH"
[[ -f ~/.aliases ]] && source ~/.aliases
