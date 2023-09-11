local wezterm = require 'wezterm'
local config = {}
local act = wezterm.action
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'nordfox'
config.font_size = 10.0
config.line_height = 1.25
config.window_background_opacity = 0.9
config.enable_tab_bar = false
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10
}
config.window_decorations = "RESIZE"
config.default_domain = 'WSL:Ubuntu-22.04'
config.window_close_confirmation = 'NeverPrompt'
config.animation_fps = 1
config.disable_default_key_bindings = true
config.default_cursor_style = 'SteadyBar'

config.keys = {
  -- { key = 'Enter', mods = 'CTRL', action = act.ActivateCopyMode },
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
}

-- and finally, return the configuration to wezterm
return config

