export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
# Use ag in fzf for listing files. Lightning fast and respects .gitignore
export FZF_DEFAULT_COMMAND='ag --files-with-matches --nocolor --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export PATH="${PATH:+${PATH}:}$HOME/.dotfiles/fzf/bin"
source "$HOME/.dotfiles/fzf/shell/completion.zsh"
source "$HOME/.dotfiles/fzf/shell/key-bindings.zsh"
