local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'dracula'
config.default_domain = 'WSL:Ubuntu-22.04'
config.window_background_opacity = 0.25

-- and finally, return the configuration to wezterm
return config

