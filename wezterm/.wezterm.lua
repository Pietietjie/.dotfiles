local wezterm = require 'wezterm'
local config = {}
local act = wezterm.action
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.colors = {
  -- The default text color
  foreground = 'silver',
  -- The default background color
  background = '#1a1b26',

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = '#bb9af7',
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = '#1a1b26',
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = '#52ad70',

  -- the foreground color of selected text
  selection_fg = '#1a1b26',
  -- the background color of selected text
  selection_bg = 'silver',

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = '#bb9af7',


  ansi = {
    '#1a1b26', -- black
    '#e0af68', -- maroon
    '#9ece6a', -- green
    '#29a4bd', -- olive
    '#0db9d7', -- navy
    '#bb9af7', -- purple
    '#29a4bd', -- teal
    'silver', -- silver
  },
  brights = {
    'grey', -- grey
    '#ff8787', -- red
    '#9ece6a', -- lime
    '#e0af68', -- yellow
    '#87afff', -- blue
    '#9d7cd8', -- fuchsia aka ugly bright pink that terminals use for an incomprehensible reason
    '#87d7d7', -- aqua
    'silver', -- white
  },

  -- Since: 20220319-142410-0fcdea07
  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  compose_cursor = '#2ac3de',

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  copy_mode_active_highlight_bg = { Color = '#ff9e64' },
  -- use `AnsiColor` to specify one of the ansi color palette values
  -- (index 0-15) using one of the names "Black", "Maroon", "Green",
  --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
  -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
  copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  copy_mode_inactive_highlight_bg = { Color = '#ff8787' },
  copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },
}

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

