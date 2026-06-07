---@type Wezterm
local wezterm = require('wezterm')
local mux = wezterm.mux
local window_state = require('utils.window-state')

local M = {}

M.setup = function()
   window_state.setup()

   wezterm.on('gui-startup', function(cmd)
      local _, _, window = mux.spawn_window(cmd or {})
      window_state.restore(window:gui_window())
   end)
end

return M
