#!/bin/bash

# Commands to get the OS to a workable state from a boostrapped Arch imported
# into WSL2 with wsl --import arch D:\ArchVirtualDrive D:\arch_bootstrap.tar.gz
#
# Hasn't been run as a single script before so probably won't work but here
# for documentation purposes.
os-setup() {
  pacman-key --init
  pacman-key --populate archlinux
  curl "https://archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4&use_mirror_status=on" | cut -c 2- > /etc/pacman.d/mirrorlist
  pacman -Syyu base base-devel git vim zsh wget openssh man tmux the_silver_searcher
  ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
  hwclock --systohc
  sed -i 's:#en_US.UTF-8 UTF-8:en_US.UTF-8 UTF-8:g' /etc/locale.gen
  locale-gen
  echo LANG=en_US.UTF-8 >> /etc/locale.conf
  echo LANGUAGE=en_US.UTF-8 >> /etc/locale.conf
  echo LC_ALL=en_US.UTF-8 >> /etc/locale.confS
  passwd
  useradd -m -G wheel -s /bin/zsh -d /home/creez creez
  passwd creez
  touch /home/creez/.zshrc && chown creez:creez /home/creez/.zshrc
  sed -i '/%wheel ALL=(ALL) ALL/c\%wheel ALL=(ALL) ALL' /etc/sudoers
  sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/c\%wheel ALL=(ALL) NOPASSWD: ALL' /etc/sudoers #tmp: for yay install.

  git clone https://aur.archlinux.org/yay.git /opt/yay
  chown -R creez:creez /opt/yay
  su creez
  passwd
  cd /opt/yay
  makepkg -si
  yay -Sy daemonize # dependency of genie
  wget https://github.com/arkane-systems/genie/releases/download/v1.42/genie-systemd-1.42-1-x86_64.pkg.tar.zst
  sudo pacman -U genie-systemd-1.42-1-x86_64.pkg.tar.zst
  rm genie-systemd-1.42-1-x86_64.pkg.tar.zst
  exit
  sed -i 's/%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers # revert nopasswd req
  exit
  echo "Run wsl --shutdown and restart the instance with wsl -d arch -- genie -s"
}

# this is semi-idempotent but not really
env-setup() {
  sudo pacman -S --needed \
    git vim zsh wget mlocate openssh man tree cmake tmux the_silver_searcher \
    dnsutils
  sudo updatedb # setup locate db

  git clone git@github.com:jakecraige/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  echo 'export TARGET=127.0.0.1' > ~/.zshrc.private
  git submodule update --init --recursive

  # Symlink dotfiles to ther expected locations
  ln -f -s ~/.dotfiles/bin ~/bin
  ln -f -s ~/.dotfiles/ctags ~/.ctags
  ln -f -s ~/.dotfiles/gemrc ~/.gemrc
  ln -f -s ~/.dotfiles/gitconfig ~/.gitconfig
  ln -f -s ~/.dotfiles/rspec ~/.rspec
  ln -f -s ~/.dotfiles/tmux.conf ~/.tmux.conf
  ln -f -s ~/.dotfiles/vimrc ~/.vimrc
  ln -f -s ~/.dotfiles/vimrc.bundles ~/.vimrc.bundles
  ln -f -s ~/.dotfiles/tmux.conf ~/.tmux.conf
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

  mkdir ~/code
}

hax-setup() {
  sudo pacman -S --needed \
    jq socat nmap netcat metasploit proxychains \
    inetutils  # ftp/telnet/etc
  yay -S --needed ffuf ngrok

  # I would use ASDF but there's some dep issues that to resovle
  # require installing PHP system wide anyways. If I need particular
  # versions I can still drop down to asdf.
  sudo pacman -S --needed php

  go install github.com/tomnomnom/anew@latest
  go install github.com/tomnomnom/gf@latest
  go install github.com/tomnomnom/waybackurls@latest

  ln -f -s ~/.dotfiles/gf ~/.gf

  git clone git@github.com:jakecraige/hax.git ~/code/hax
  git clone git@github.com:jakecraige/ctf.git ~/code/ctf
  git clone git@github.com:jakecraige/ctf-tools.git ~/code/ctf-tools
  mkdir -p ~/code/bounty

  pip install pycrypto requests
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
