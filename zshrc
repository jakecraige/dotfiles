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
export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent::1"

plugins=(git osx brew autojump zsh-syntax-highlighting ssh-agent asdf)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_ed25519

source "$HOME/.dotfiles/asdf/asdf.sh"
source "$ZSH/oh-my-zsh.sh"
source "$HOME/.autojump/etc/profile.d/autojump.sh"

for config in ~/.dotfiles/zsh/*; do
  source $config
done

for function in ~/.dotfiles/zsh/functions/*; do
  source $function
done

export PATH=".git/safe/../../bin:$PATH"
[[ -f ~/.dotfiles/aliases ]] && source ~/.dotfiles/aliases
[[ -f "$HOME/.zshrc.private" ]] && source "$HOME/.zshrc.private"
