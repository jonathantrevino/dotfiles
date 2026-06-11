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

# Ensure language servers are installed:

# go

# tailwindcss
# npm install -g @tailwindcss/language-server

# lua_ls
# brew install lua-language-server

# terraform
# brew install hashicorp/tap/terraform-ls

# typeScript, javaScript, jsx, and tsx files
brew install typescript-language-server

# html, css, json, and eslint diagnostics
brew install vscode-langservers-extracted
