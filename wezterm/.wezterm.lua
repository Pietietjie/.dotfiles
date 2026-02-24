local wezterm = require 'wezterm'
local config = {}
local act = wezterm.action
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Tokyo Night Storm'
config.default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe' }

config.font_size = 13.0
config.line_height = 1.25
config.window_background_opacity = 0.8
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

config.leader = { key = ' ', mods = 'CTRL' }
local is_zoomed = false
local function zoom_toggle(window, pane)
  is_zoomed = not is_zoomed
  window:perform_action(act.SetPaneZoomState(is_zoomed), pane)
end
local function navigate_panes_with_zoom(window, pane, direction)
  window:perform_action(act.ActivatePaneDirection(direction), pane)
  if is_zoomed then
    window:perform_action(act.SetPaneZoomState(true), pane)
  end
end

config.keys = {
  -- Send CTRL space to the terminal when pressing CTRL space, CTRL space
  { key = " ", mods = 'LEADER|CTRL',  action = wezterm.action { SendKey = { key = ' ', mods = 'CTRL' } }, },
  { key = '"', mods = 'LEADER|SHIFT', action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' }, }, },
  { key = '%', mods = 'LEADER|SHIFT', action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' }, }, },
  { key = 's', mods = 'LEADER',       action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' }, }, },
  { key = 'v', mods = 'LEADER',       action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' }, }, },
  { key = 'z', mods = 'LEADER',       action = wezterm.action_callback(function(window, pane) zoom_toggle(window, pane) end), },
  { key = 'c', mods = 'LEADER',       action = wezterm.action { SpawnTab = 'CurrentPaneDomain' }, },
  { key = 'L', mods = 'CTRL|SHIFT',   action = wezterm.action.ShowDebugOverlay },
  { key = 'h', mods = 'LEADER',       action = wezterm.action_callback(function(window, pane) navigate_panes_with_zoom(window, pane, 'Left') end), },
  { key = 'j', mods = 'LEADER',       action = wezterm.action_callback(function(window, pane) navigate_panes_with_zoom(window, pane, 'Down') end), },
  { key = 'k', mods = 'LEADER',       action = wezterm.action_callback(function(window, pane) navigate_panes_with_zoom(window, pane, 'Up') end), },
  { key = 'l', mods = 'LEADER',       action = wezterm.action_callback(function(window, pane) navigate_panes_with_zoom(window, pane, 'Right') end), },
  { key = 'H', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Left', 5 } }, },
  { key = 'J', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Down', 5 } }, },
  { key = 'K', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Up', 5 } }, },
  { key = 'L', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Right', 5 } }, },
  { key = '1', mods = 'LEADER',       action = wezterm.action { ActivateTab = 0 } },
  { key = '2', mods = 'LEADER',       action = wezterm.action { ActivateTab = 1 } },
  { key = '3', mods = 'LEADER',       action = wezterm.action { ActivateTab = 2 } },
  { key = '4', mods = 'LEADER',       action = wezterm.action { ActivateTab = 3 } },
  { key = '5', mods = 'LEADER',       action = wezterm.action { ActivateTab = 4 } },
  { key = '6', mods = 'LEADER',       action = wezterm.action { ActivateTab = 5 } },
  { key = '7', mods = 'LEADER',       action = wezterm.action { ActivateTab = 6 } },
  { key = '8', mods = 'LEADER',       action = wezterm.action { ActivateTab = 7 } },
  { key = '9', mods = 'LEADER',       action = wezterm.action { ActivateTab = 8 } },
  { key = '=', mods = 'CTRL',         action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL',         action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL',         action = act.ResetFontSize },
  { key = 'C', mods = 'SHIFT|CTRL',   action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL',         action = act.PasteFrom 'Clipboard' },
}


-- and finally, return the configuration to wezterm
return config
