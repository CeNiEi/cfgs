eval (/opt/homebrew/bin/brew shellenv)

fish_add_path ~/.cargo/bin
fish_add_path ~/.ghcup/bin/
fish_add_path ~/.cabal/bin
# Set up fzf key bindings
fzf --fish | source
zoxide init fish --cmd cd | source
~/.local/bin/mise activate fish | source
fish_add_path ~/.elan/bin

alias sqlite="/opt/homebrew/opt/sqlite/bin/sqlite3" 
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

if status is-interactive
    tv init fish | source
end
