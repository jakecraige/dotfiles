# Dotfiles

This repo uses [rcm](https://github.com/thoughtbot/rcm) to manage it's dotfiles

## Installation
Clone repo into `~/.dotfiles` and setup symlinks with `rcup`

```sh
git clone https://github.com/jakecraige/dotfiles ~/.dotfiles
rcup -B jaine.local -v -x iterm -x README && rcup -B jaine.local -v
```

## Useful info

- List what will be symlinked with `lsrc -v`
- rcup is run twice so that it links the .rcrc first, then the second run sets
  up the rest of the dotfiles

## Setup new machine

1. Setup core dev environment

```sh
xcode-select --install
curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
sh mac 2>&1 | tee ~/laptop.log
```

2. Install app store apps
  - Xcode
  - BetterSnapTool

