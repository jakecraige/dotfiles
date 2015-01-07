# Dotfiles

This is build on top of the base dotfiles found at
[poetic/dotfiles](https://github.com/poetic/dotfiles)

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
