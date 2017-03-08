#!/bin/zsh

export EDITOR="nvim"
export SHELL="/bin/zsh"
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH"
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
LEIN_FAST_TRAMPOLINE=y
export LEIN_FAST_TRAMPOLINE
export ZSH=$HOME/.dotfiles/oh-my-zsh
export ZSH_CUSTOM=$HOME/.dotfiles/zsh_custom
export ZSH_THEME="poetic"
export DISABLE_AUTO_TITLE="true"
export ANDROID_HOME=/usr/local/opt/android-sdk
export PATH="$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools"
export PATH="$PATH:`yarn global bin`"
export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent::1"

plugins=(git osx brew autojump zsh-syntax-highlighting ssh-agent lein)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa

source "$ZSH/oh-my-zsh.sh"

eval "$(rbenv init - zsh --no-rehash)"
source "$HOME/.zshrc.private"
export PATH="$PATH:$HOME/.asdf/bin:$HOME/.asdf/shims"

autoload bashcompinit
bashcompinit
source "$HOME/.asdf/completions/asdf.bash"

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# swift OSS
# export PATH=/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:"${PATH}"

export PATH=".git/safe/../../bin:$PATH"
[[ -f ~/.aliases ]] && source ~/.aliases
