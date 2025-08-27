local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 20
config.colors = {
  background = "#2A2A36"
}

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.color_scheme = "Nord (Gogh)"
config.window_background_opacity = 0.87
config.macos_window_background_blur = 100

config.window_close_confirmation = 'NeverPrompt'
config.max_fps = 120
config.animation_fps = 120
return config
