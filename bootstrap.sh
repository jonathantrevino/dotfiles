#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"
PLUGINS_DIR="$CONFIG/nvim/pack/plugins/start"
BACKUP="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

echo "🚀 Starting dotfiles bootstrap..."

# -------------------------------------
# 1. Create backup directory
# -------------------------------------
mkdir -p "$BACKUP"

# -------------------------------------
# 2. Symlink config folders
# -------------------------------------
link_config() {
    local src="$DOTFILES/$1"
    local dest="$CONFIG/$1"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "📦 Backing up existing $dest → $BACKUP/$1"
        mv "$dest" "$BACKUP/$1"
    fi

    echo "🔗 Linking $src → $dest"
    ln -s "$src" "$dest"
}

# Add each config folder you want to sync here:
link_config "nvim"
link_config "kitty"
link_config "zsh"


install_plugin() {
    local repo="$1"
    local name=$(basename "$repo" .git)
    local dest="$PLUGINS_DIR/$name"

    if [ -d "$dest" ]; then
        echo "✅ $name already installed, skipping"
    else
        echo "📥 Cloning $name from $repo"
        git clone --depth 1 "$repo" "$dest"
    fi
}

# -----------------------------
# Add plugins you use here
# -----------------------------
install_plugin "https://github.com/nvim-treesitter/nvim-treesitter.git"
install_plugin "https://github.com/nvim-lua/plenary.nvim.git"
install_plugin "https://github.com/nvim-tree/nvim-web-devicons.git"
install_plugin "https://github.com/chriskempson/tomorrow-theme.git"
install_plugin "https://github.com/stevearc/oil.nvim.git"
install_plugin "https://github.com/nvim-telescope/telescope.nvim.git"
install_plugin "https://github.com/neovim/nvim-lspconfig.git"
install_plugin "https://github.com/hrsh7th/nvim-cmp.git"
install_plugin "https://github.com/hrsh7th/cmp-nvim-lsp.git"
install_plugin "https://github.com/L3MON4D3/LuaSnip.git"
install_plugin "https://github.com/saadparwaiz1/cmp_luasnip.git"
install_plugin "https://github.com/epwalsh/obsidian.nvim.git"
install_plugin "https://github.com/MeanderingProgrammer/render-markdown.nvim.git"

# -------------------------------------
# 5. Copy Tomorrow-Night-Blue.vim into colors/
# -------------------------------------
mkdir -p "$CONFIG/nvim/colors"
if [ -f "$PLUGINS_DIR/tomorrow-theme/vim/colors/Tomorrow-Night-Blue.vim" ]; then
    cp "$PLUGINS_DIR/tomorrow-theme/vim/colors/Tomorrow-Night-Blue.vim" "$CONFIG/nvim/colors/"
    echo "🎨 Tomorrow-Night-Blue theme installed."
else
    echo "⚠️ Could not find Tomorrow-Night-Blue.vim"
fi

# -------------------------------------
# 3. Install Homebrew if missing
# -------------------------------------
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "🍺 Homebrew already installed."
fi

# -------------------------------------
# 4. Install Brew packages (optional)
# -------------------------------------
if [ -f "$DOTFILES/Brewfile" ]; then
    echo "📦 Installing packages from Brewfile..."
    brew bundle --file "$DOTFILES/Brewfile"
else
    echo "ℹ️ No Brewfile found — skipping package install."
fi

echo "🎉 Dotfiles bootstrap complete!"
echo "Backups saved in: $BACKUP"
