#!/bin/bash
set -e

# Homebrew Installation
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi

# Homebrew Packages (taps, formulae, casks)
echo "Installing Homebrew packages from Brewfile..."
brew bundle --file="$HOME/dotfiles/Brewfile"

# oh-my-zsh Installation
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "oh-my-zsh not found. Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh is already installed."
fi

# Symlink Dotfiles
echo "Linking dotfiles..."

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/karabiner"
mkdir -p "$HOME/.config/yabai"
mkdir -p "$HOME/.config/skhd"
mkdir -p "$HOME/.config/tmux"
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.config/borders"
mkdir -p "$HOME/.config/zed"

ln -sf "$HOME/dotfiles/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/zsh/p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$HOME/dotfiles/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
ln -sf "$HOME/dotfiles/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
ln -sf "$HOME/dotfiles/git/gitconfig" "$HOME/.gitconfig"
ln -sf "$HOME/dotfiles/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
ln -sf "$HOME/dotfiles/yabai/yabairc" "$HOME/.config/yabai/yabairc"
ln -sf "$HOME/dotfiles/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
ln -sf "$HOME/dotfiles/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"
ln -sf "$HOME/dotfiles/borders/bordersrc" "$HOME/.config/borders/bordersrc"
ln -sf "$HOME/dotfiles/zed/settings.json" "$HOME/.config/zed/settings.json"
ln -sf "$HOME/dotfiles/zed/keymap.json" "$HOME/.config/zed/keymap.json"
ln -sfn "$HOME/dotfiles/zed/themes" "$HOME/.config/zed/themes"

# Firefox — link into the profile Firefox actually launches (needs Firefox to have run once)
FF_DIR="$HOME/Library/Application Support/Firefox"
FF_PROFILE="$(awk -F= '/^\[Install/{f=1} f && /^Default=/{print $2; exit}' "$FF_DIR/profiles.ini" 2>/dev/null)"
if [ -n "$FF_PROFILE" ] && [ -d "$FF_DIR/$FF_PROFILE" ]; then
  echo "Linking Firefox config into $FF_PROFILE..."
  ln -sf "$HOME/dotfiles/firefox/user.js" "$FF_DIR/$FF_PROFILE/user.js"
  ln -sfn "$HOME/dotfiles/firefox/chrome" "$FF_DIR/$FF_PROFILE/chrome"
else
  echo "No Firefox profile found — open Firefox once, then re-run to link its config."
fi

# Spotify (Spicetify + Catppuccin Mocha) — re-run `spicetify backup apply` after Spotify updates
if command -v spicetify >/dev/null 2>&1; then
  echo "Linking Spicetify theme..."
  spicetify config >/dev/null 2>&1 || true  # generates ~/.config/spicetify on first run
  mkdir -p "$HOME/.config/spicetify/Themes"
  ln -sfn "$HOME/dotfiles/spicetify/Themes/catppuccin" "$HOME/.config/spicetify/Themes/catppuccin"
  echo "To theme Spotify: spicetify config current_theme catppuccin color_scheme mocha inject_css 1 inject_theme_js 1 replace_colors 1 overwrite_assets 1 && spicetify backup apply"
fi

# TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" --depth 1
else
  echo "TPM is already installed."
fi

# Neovim (NvChad) — init.lua bootstraps lazy.nvim and NvChad on first launch
if [ -L "$HOME/.config/nvim" ]; then
  echo "nvim config is already linked."
elif [ -e "$HOME/.config/nvim" ]; then
  echo "An nvim configuration already exists at ~/.config/nvim — skipping."
else
  echo "Linking nvim config..."
  ln -s "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
fi

echo "Installation complete!"
