eval (/opt/homebrew/bin/brew shellenv)

fish_add_path ~/.cargo/bin
fish_add_path ~/.ghcup/bin/
fish_add_path ~/.cabal/bin
# Set up fzf key bindings
fzf --fish | source
zoxide init fish --cmd cd | source
~/.local/bin/mise activate fish | source
