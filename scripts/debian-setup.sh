#!/bin/bash

# Commands to get the OS to a workable state from a new ISO.
# Assumes username is creez
os-setup() {
  su -
  apt update
  apt upgrade
  echo "%creez ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/creez
  chsh -s /bin/zsh creez
}

env-setup() {
  # ensure we are running in the new shell since we usually default to bash
  exec /bin/zsh

  ssh-keygen -t ed25519 -C "git@jcraige.com"
  # Need to add this key to Github

  git clone https://github.com/jakecraige/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  git submodule update --init --recursive

  sudo apt install git build-essential net-tools linux-headers-$(uname -r) xsel
  sudo apt install snapd vim zsh curl wget openssh-server tree tmux silversearcher-ag default-jdk

  # Dependencies needed for installing languages. Ruby and Python in particular.
  # https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
  sudo apt install libbz2-dev libreadline-dev libsqlite3-dev libffi-dev # python build
  sudo apt install autoconf patch libssl-dev libyaml-dev zlib1g-dev libgmp-dev libncurses5-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev

  # Symlink dotfiles to ther expected locations
  ln -f -s ~/.dotfiles/bin ~/bin
  ln -f -s ~/.dotfiles/ctags ~/.ctags
  ln -f -s ~/.dotfiles/gemrc ~/.gemrc
  ln -f -s ~/.dotfiles/gitconfig ~/.gitconfig
  ln -f -s ~/.dotfiles/rspec ~/.rspec
  ln -f -s ~/.dotfiles/tmux.conf ~/.tmux.conf
  ln -f -s ~/.dotfiles/vimrc ~/.vimrc
  ln -f -s ~/.dotfiles/vimrc.bundles ~/.vimrc.bundles
  ln -f -s ~/.dotfiles/zshrc ~/.zshrc
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # install commonly used languages
  asdf plugin-add ruby
  asdf install ruby latest
  asdf global ruby $(asdf list ruby| cut -d ' ' -f 3)
  asdf plugin-add nodejs
  asdf install nodejs latest
  asdf global nodejs $(asdf list nodejs | cut -d ' ' -f 3)
  asdf plugin-add golang
  asdf install golang latest
  asdf global golang $(asdf list golang | cut -d ' ' -f 3)
  asdf plugin-add python
  asdf install python latest
  asdf global python $(asdf list python | cut -d ' ' -f 3)
  asdf plugin-add rust
  asdf install rust latest
  asdf global rust $(asdf list rust | cut -d ' ' -f 3)

  cd ~/.dotfiles/autojump && ./install.py
  cd ~/.dotfiles/fzf && ./install
  vim +PlugInstall +qall

  # install tmux plugins (manual with Ctrl-A + I in tmux

  sudo snap install code --classic

  mkdir ~/code
}

hax-setup() {
  sudo apt install -y jq socat nmap netcat-openbsd proxychains inetutils-telnet inetutils-ftp ffuf
  sudo snap install ngrok metasploit
  sudo snap install zaproxy --classic

  cd ~/.dotfiles/pwndbg && ./setup.sh

  go install github.com/tomnomnom/anew@latest
  go install github.com/tomnomnom/gf@latest
  go install github.com/tomnomnom/waybackurls@latest
  ln -f -s ~/.dotfiles/gf ~/.gf

  git clone git@github.com:jakecraige/hax.git ~/code/hax
  git clone git@github.com:jakecraige/ctf.git ~/code/ctf
  git clone git@github.com:jakecraige/ctf-tools.git ~/code/ctf-tools

  cd ~/Desktop && wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.3.2_build/ghidra_10.3.2_PUBLIC_20230711.zip
  unzip ghidra_10.3.2_PUBLIC_20230711.zip && rm ghidra_10.3.2_PUBLIC_20230711.zip

  pip install --upgrade pip
  pip install pycryptodome requests pwntools
  # TODO:
  #   include seclists? Currently have installed on shared mounted drive
  #   Wire up proxychains to WINHOST proxy

  # Post-install manual steps:
  # 1. Visit ngrok to get auth tken and run `ngrok authtoken $token`
}

case "$1" in
  ("os")
    os-setup "${@:2}"
    ;;
  ("env")
    env-setup "${@:2}"
    ;;
  ("hax")
    hax-setup "${@:2}"
    ;;
  (*)
    echo "command expected: os, env, hax" >&2
    exit 1
    ;;
esac
