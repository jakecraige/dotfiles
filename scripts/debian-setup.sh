#!/bin/bash

set -e

# Commands to get the OS to a workable state from a new ISO.
# Assumes username is creez
os-setup() {
  su -
  apt update
  apt upgrade
  echo "%creez ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/creez
  chsh -s /bin/zsh creez
  # Maybe useful: https://unix.stackexchange.com/questions/458893/vmware-on-linux-host-causes-regular-freezes#458894
  # echo never | sudo tee /sys/kernel/mm/transparent_hugepage/defrag
  # echo 0 | sudo tee /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
}

env-setup-gui() {
  sudo apt install alacritty fonts-firacode
  sudo apt install rofi
  sudo snap install code --classic
}

# This section is meant to be run manually before other commands.
initial-manual-setup() {
  sudo apt update && sudo apt upgrade
  sudo apt install -y git openssh-server curl zsh
  git clone https://github.com/jakecraige/dotfiles ~/.dotfiles
  ln -f -s ~/.dotfiles/gitconfig ~/.gitconfig
  cd ~/.dotfiles
  # If on WSL2, nothing to do because git will delegate to OnePassword.
  # If not, generate an SSH Key and add it to GitHub before swapping the remote.
  # $ ssh-keygen -t ed25519 -C "git@jcraige.com"
  git remote remove origin && git remote add origin git@github.com:jakecraige/dotfiles.git
  git branch --set-upstream-to=origin/master master
  git pull
  git submodule update --init --recursive

  sudo sh -c 'cat << EOF > /etc/wsl.conf
[boot]
systemd=true
EOF'
  echo "Done. If on WSL, run 'wsl.exe --shutdown' from PowerShell to restart with systemd enabled."
}

env-setup() {
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
  ln -f -s ~/.dotfiles/alacritty.yml ~/.alacritty.yml
  mkdir -p ~/.config/rofi
  ln -f -s ~/.dotfiles/config/rofi/config.rasi ~/.config/rofi/config.rasi

  sudo apt install -y zsh build-essential net-tools xsel gnupg snapd vim wget tree tmux fd-find silversearcher-ag default-jdk man-db manpages-dev

  # Dependencies needed for installing languages. Ruby and Python in particular.
  # https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
  sudo apt install -y libbz2-dev libreadline-dev libsqlite3-dev libffi-dev # python build
  sudo apt install -y autoconf patch libssl-dev libyaml-dev zlib1g-dev libgmp-dev libncurses5-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev

  # install commonly used languages
  # we need to source this since we aren't in zsh yet
  . ~/.dotfiles/asdf/asdf.sh
  (asdf plugin list | grep ruby) || asdf plugin-add ruby
  asdf install ruby latest
  asdf global ruby $(asdf list ruby | awk -F'[ \*]' '{print $3}')

  (asdf plugin list | grep nodejs) || asdf plugin-add nodejs
  asdf install nodejs latest
  asdf global nodejs $(asdf list nodejs | awk -F'[ \*]' '{print $3}')

  (asdf plugin list | grep golang) || asdf plugin-add golang
  asdf install golang latest
  asdf global golang $(asdf list golang | awk -F'[ \*]' '{print $3}')

  (asdf plugin list | grep python) || asdf plugin-add python
  asdf install python latest
  asdf global python $(asdf list python | awk -F'[ \*]' '{print $3}')

  (asdf plugin list | grep rust) || asdf plugin-add rust
  asdf install rust latest
  asdf global rust $(asdf list rust | awk -F'[ \*]' '{print $3}')

  asdf reshim

  cd ~/.dotfiles/autojump && ./install.py
  cd ~/.dotfiles/fzf && ./install --bin

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall

  gem update --system
  gem install bundler

  echo "Install tmux plugins when you run it with: Ctrl-A + I"
  mkdir -p ~/code

  chsh -s /bin/zsh creez
  exec /bin/zsh
}

docker-setup() {
  # WSL2 Notes:
  #   Use the Docker Desktop integration for best performance. Make sure to set
  #   it as the default distribution as documented here: https://docs.docker.com/desktop/wsl/
  #   $ wsl.exe --set-default debian
  # Else
  #   This code runs as described here:
  #   https://docs.docker.com/engine/install/debian/#install-using-the-repository
  sudo apt update
  sudo apt install ca-certificates curl gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

env-wsl2-gui() {
  # This was needed for Firefox to show a file chooser from WSL2
  sudo apt install xdg-desktop-portal-gtk
}

hax-setup-gui() {
  sudo apt install -y wireshark
  sudo snap install zaproxy --classic
  wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.3.2_build/ghidra_10.3.2_PUBLIC_20230711.zip
  unzip ghidra_10.3.2_PUBLIC_20230711.zip && rm ghidra_10.3.2_PUBLIC_20230711.zip
  sudo mkdir /opt/
  sudo mkdir ~/.local/share/applications
  sudo mv ghidra_10.3.2_PUBLIC /opt/Ghidra
  cat << EOF > ~/.local/share/applications/ghidra.desktop
[Desktop Entry]
Encoding=UTF-8
Version=10.3.2
Type=Application
Terminal=false
Exec=/opt/Ghidra/ghidraRun
Name=Ghidra
Icon=/opt/Ghidra/support/ghidra.ico
EOF
}

hax-setup() {
  sudo apt install -y jq socat nmap netcat-openbsd proxychains inetutils-telnet inetutils-ftp ffuf strace
  sudo snap install ngrok metasploit-framework searchsploit

  # TODO: This submodule can be moved into the hax repo instead of in dotfiles
  cd ~/.dotfiles/pwndbg && ./setup.sh

  go install github.com/tomnomnom/anew@latest
  go install github.com/tomnomnom/gf@latest
  go install github.com/tomnomnom/waybackurls@latest
  ln -f -s ~/.dotfiles/gf ~/.gf

  git clone --recurse-submodules git@github.com:jakecraige/hax.git ~/code/hax
  git clone git@github.com:jakecraige/ctf.git ~/code/ctf
  git clone git@github.com:jakecraige/ctf-tools.git ~/code/ctf-tools

  pip install --upgrade pip
  pip install pycryptodome requests pwntools

  gem install one_gadget
  # Post-install manual steps:
  # 1. Visit https://ngrok.com/ to get your auth token and run the command it
  #    tells you to configure it.
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
  ("hax-gui")
    hax-setup "${@:2}"
    ;;
  (*)
    echo "command expected: os, env, hax, hax-gui" >&2
    exit 1
    ;;
esac
