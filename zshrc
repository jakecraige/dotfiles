#!/bin/zsh

export EDITOR="vim"
export SHELL="/bin/zsh"
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/.bin:$PATH"
export DOT="$HOME/.dotfiles"
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export ZSH="$DOT/oh-my-zsh"
export ZSH_CUSTOM="$DOT/zsh_custom"
export ZSH_THEME="poetic"
export DISABLE_AUTO_TITLE="true"
export PATH="$DOT/asdf/bin:$HOME/.asdf/shims:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent::1"

kernel="$(uname -s)"
plugins=(git autojump zsh-syntax-highlighting ssh-agent asdf)

if [[ $kernel == "Darwin" ]]; then
  plugins+=(osx brew)
fi

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_ed25519

source "$DOT/asdf/asdf.sh"
source "$ZSH/oh-my-zsh.sh"
source "$HOME/.autojump/etc/profile.d/autojump.sh"

export GOPATH="$(asdf env go | grep GOPATH | cut -d '=' -f 2)"
source $GOPATH/pkg/mod/github.com/tomnomnom/gf@*/gf-completion.zsh

export WINHOST="$(ip route | awk '/^default/{print $3}')"
if [[ $kernel == "Linux" ]]; then
  export DISPLAY="$WINHOST:0"
fi

for config in ~/.dotfiles/zsh/*; do
  source $config
done

for function in ~/.dotfiles/zsh/functions/*; do
  source $function
done

export PATH=".git/safe/../../bin:$PATH"
[[ -f "$DOT/aliases" ]] && source "$DOT/aliases"
[[ -f "$HOME/.zshrc.private" ]] && source "$HOME/.zshrc.private"
