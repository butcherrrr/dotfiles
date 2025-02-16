local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 18

config.colors = {
  background = "#1F2531"
}
config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '1cell',
  bottom = '-1cell',
}
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.color_scheme = "nord"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 0

config.window_close_confirmation = 'NeverPrompt'
config.max_fps = 120
config.animation_fps = 120
return config

