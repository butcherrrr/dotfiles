#!/bin/bash
set -e

# Homebrew Installation
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# oh-my-zsh Installation
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "oh-my-zsh not found. Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh is already installed."
fi

# Symlink Dotfiles
echo "Linking dotfiles..."
ln -sf "$HOME/dotfiles/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
ln -sf "$HOME/dotfiles/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
ln -sf "$HOME/dotfiles/git/gitconfig" "$HOME/.gitconfig"
ln -sf "$HOME/dotfiles/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
ln -sf "$HOME/dotfiles/yabai/yabairc" "$HOME/.config/yabai/yabairc"
ln -sf "$HOME/dotfiles/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
ln -sf "$HOME/dotfiles/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"

# Neovim Installation
if ! command -v nvim >/dev/null 2>&1; then
  echo "Neovim not found. Installing Neovim via Homebrew..."
  brew install neovim
else
  echo "Neovim is installed."
fi

# NVChad Installation
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "NVChad is not installed. Installing NVChad..."
  git clone https://github.com/NvChad/starter "$HOME/.config/nvim" --depth 1
  echo "Symlinking NVChad to ~/.config/nvim..."
  rm -rf "$HOME/.config/nvim"
  ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
else
  echo "An nvim configuration already exists."
fi

echo "Installation complete!"
