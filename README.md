# Dotfiles

This repo uses [rcm](https://github.com/thoughtbot/rcm) to manage it's dotfiles

## Installation
Clone repo into `~/.dotfiles` and setup symlinks with `rcup`

```sh
git clone https://github.com/jakecraige/dotfiles ~/.dotfiles
ln -s ~/.dotfiles/rcrc ~/.rcrc
rcup -v
```

## Useful info

- List what will be symlinked with `lsrc -v`

## Setup new machine

1. Get laptop local file

```sh
curl https://raw.githubusercontent.com/jakecraige/dotfiles/master/laptop.local
> ~/.laptop.local
```

2. Setup core dev environment

```sh
xcode-select --install
curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
sh mac 2>&1 | tee ~/laptop.log
vim +PlugInstall +qall
```

3. Install app store apps
  - Xcode
  - BetterSnapTool

