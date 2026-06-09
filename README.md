Download [JetBrainsMono Nerd Font w/ Ligatures](https://www.nerdfonts.com/font-downloads)

# Shell Navigation & Speed
brew install "fzf"
brew install "zoxide"
brew install "tmux"

# Docker & Container Dev
brew install "lazydocker"
brew install "dive"

# Local Testing & Utilities
brew install "xh"
brew install "ripgrep"

# Zoxide & Fzf Hooks
eval "$(zoxide init zsh)"
source <(fzf --zsh)

# Dev Shortcuts
alias ld='lazydocker'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias t='tmux attach -t dev || tmux new -s dev'
