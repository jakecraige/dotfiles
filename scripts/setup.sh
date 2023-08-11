#!/usr/bin/env zsh

# Linux (clearly lol), and very very incomplete
sudo apt install gettext
sudo apt install gdb gdbserver

sudo apt install libbz2-dev libreadline-dev libsqlite3-dev libffi-dev # python build
sudo apt install libyaml-dev # ruby build

git submodule update --init --recursive

ln -f -s ~/.dotfiles/bin ~/bin
ln -f -s ~/.dotfiles/ctags ~/.ctags
ln -f -s ~/.dotfiles/gemrc ~/.gemrc
ln -f -s ~/.dotfiles/gitconfig ~/.gitconfig
ln -f -s ~/.dotfiles/gitignore ~/.gitignore
ln -f -s ~/.dotfiles/gitmessage ~/.gitmessage
ln -f -s ~/.dotfiles/rspec ~/.rspec
ln -f -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -f -s ~/.dotfiles/vimrc ~/.vimrc
ln -f -s ~/.dotfiles/vimrc.bundles ~/.vimrc.bundles
ln -f -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -f -s ~/.dotfiles/zshrc ~/.zshrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

./autojump/install

# Mac only
#ln -f -s ~/.dotfiles/iterm ~/.iterm
#ln -f -s ~/.dotfiles/xvimrc ~/.xvimrc
