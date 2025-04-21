local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 20
config.line_height = 1.1

config.colors = {
  -- background = "#1F2531"
}

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.90
config.macos_window_background_blur = 0

config.window_close_confirmation = 'NeverPrompt'
config.max_fps = 120
config.animation_fps = 120
return config
