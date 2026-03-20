#!/bin/bash
set -e

# Homebrew Installation
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Homebrew Taps
echo "Adding Homebrew taps..."
brew tap nikitabobko/tap        # aerospace
brew tap FelixKratz/formulae    # borders
brew tap koekeishiya/formulae   # yabai, skhd

# Homebrew Formulae
echo "Installing formulae..."
brew install neovim
brew install tmux
brew install fzf
brew install eza
brew install bat
brew install zoxide
brew install thefuck
brew install delta
brew install zsh-autosuggestions
brew install stylua
# brew install yabai
# brew install skhd
brew install borders

# Homebrew Casks
echo "Installing casks..."
brew install --cask aerospace
brew install --cask wezterm
brew install --cask ghostty
brew install --cask karabiner-elements
brew install --cask font-jetbrains-mono
brew install --cask raycast
brew install --cask docker
brew install --cask spotify
brew install --cask zed
brew install --cask firefox

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

ln -sf "$HOME/dotfiles/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
ln -sf "$HOME/dotfiles/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
ln -sf "$HOME/dotfiles/git/gitconfig" "$HOME/.gitconfig"
ln -sf "$HOME/dotfiles/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
ln -sf "$HOME/dotfiles/yabai/yabairc" "$HOME/.config/yabai/yabairc"
ln -sf "$HOME/dotfiles/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
ln -sf "$HOME/dotfiles/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
ln -sf "$HOME/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"
ln -sf "$HOME/dotfiles/borders/bordersrc" "$HOME/.config/borders/bordersrc"

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
