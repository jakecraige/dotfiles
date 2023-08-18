#!/bin/zsh

export EDITOR="vim"
export SHELL="/bin/zsh"
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:/usr/sbin:$PATH"
export DOT="$HOME/.dotfiles"
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export ZSH="$DOT/oh-my-zsh"
export ZSH_CUSTOM="$DOT/zsh_custom"
export ZSH_THEME="poetic"
export DISABLE_AUTO_TITLE="true"
export PATH="$DOT/asdf/bin:$HOME/.asdf/shims:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent::1"

kernel="$(uname -s)"
plugins=(git zsh-syntax-highlighting)

if [[ $kernel == "Darwin" ]]; then
  plugins+=(osx brew)
fi


if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
  plugins+=ssh-agent
  zstyle :omz:plugins:ssh-agent agent-forwarding on
  zstyle :omz:plugins:ssh-agent identities id_ed25519
fi

source "$DOT/asdf/asdf.sh"
source "$ZSH/oh-my-zsh.sh"
source "$HOME/.autojump/etc/profile.d/autojump.sh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# There's a script in the asdf-go plugin to do this but something is buggy
# about it and it doesn't set the right GOPATH (an incorrect version) plus
# it doesn't have them ready to be used in the following lines.
local goInstallDir="$(dirname $(dirname $(dirname $(asdf which go))))"
export GOROOT="$goInstallDir/go"
export GOPATH="$goInstallDir/packages"

gf_completion=($GOPATH/pkg/modx/github.com/tomnomnom/gf@*/gf-completion.zsh(N))
if [[ -f "$gf_completion" ]]; then
  source "$gf_completion"
fi

if [[ -d "/mnt/c/Windows" ]]; then
  export WINHOST="$(ip route | awk '/^default/{print $3}')"
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
