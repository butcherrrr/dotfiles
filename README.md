# dotfiles

dotfiles for macos

## Install

```sh
git clone https://github.com/butcherrrr/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` installs Homebrew, everything in the `Brewfile`, oh-my-zsh and TPM, then symlinks the configs below. It expects the repo to live at `~/dotfiles`.

After installing:

- Open tmux and press `prefix + I` to install plugins
- Open nvim to let lazy.nvim install plugins, then `:MasonInstall` any language servers you need
- Private git settings (name, email, signing) go in `~/.gitconfig-private`

## What's in here

| Folder       | Linked to                                   | Notes                                    |
| ------------ | ------------------------------------------- | ---------------------------------------- |
| `zsh/`       | `~/.zshrc`, `~/.p10k.zsh`                   | oh-my-zsh, powerlevel10k, fzf helpers    |
| `git/`       | `~/.gitconfig`                              | delta pager                              |
| `nvim/`      | `~/.config/nvim`                            | NvChad                                   |
| `tmux/`      | `~/.config/tmux/tmux.conf`                  | TPM, catppuccin                          |
| `ghostty/`   | `~/.config/ghostty/config`                  |                                          |
| `wezterm/`   | `~/.wezterm.lua`                            |                                          |
| `zed/`       | `~/.config/zed/{settings,keymap}.json`, `themes/` |                                    |
| `aerospace/` | `~/.aerospace.toml`                         | tiling window manager                    |
| `borders/`   | `~/.config/borders/bordersrc`               | window borders                           |
| `karabiner/` | `~/.config/karabiner/karabiner.json`        |                                          |
| `yabai/`     | `~/.config/yabai/yabairc`                   | not installed by default (using aerospace) |
| `skhd/`      | `~/.config/skhd/skhdrc`                     | not installed by default (using aerospace) |
| `raycast/`   | —                                           | script commands, add the folder in Raycast |

Theme everywhere is Catppuccin Mocha.

## Shell helpers

- `brewin` / `brewrm` — fuzzy search and install / uninstall Homebrew packages
- `gbf` — fuzzy git branch checkout
- `glf` — fuzzy git log with delta previews

## Keeping the Brewfile up to date

```sh
brew bundle check --file=~/dotfiles/Brewfile --verbose   # what's missing
brew bundle dump --file=~/dotfiles/Brewfile --force      # overwrite with what's installed
```
