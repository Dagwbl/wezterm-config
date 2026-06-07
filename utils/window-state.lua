local wezterm = require('wezterm')
local platform = require('utils.platform')

local M = {}

local state_path = wezterm.config_dir .. '/window-state.json'
local rect_script_path = wezterm.config_dir .. '/utils/window-rect.ps1'
local last_position_save = 0

local function read_state()
   local file = io.open(state_path, 'r')
   if file == nil then
      return nil
   end

   local contents = file:read('*a')
   file:close()

   if contents == nil or contents == '' then
      return nil
   end

   local ok, state = pcall(wezterm.json_parse, contents)
   if not ok then
      wezterm.log_warn('Unable to parse window state: ' .. tostring(state))
      return nil
   end

   return state
end

local function write_state(state)
   local file = io.open(state_path, 'w')
   if file == nil then
      wezterm.log_warn('Unable to write window state: ' .. state_path)
      return
   end

   file:write(wezterm.json_encode(state))
   file:close()
end

local function read_window_position()
   if not platform.is_win then
      return nil
   end

   local success, stdout = wezterm.run_child_process({
      'pwsh',
      '-NoLogo',
      '-NoProfile',
      '-ExecutionPolicy',
      'Bypass',
      '-File',
      rect_script_path,
   })

   if not success or stdout == nil or stdout == '' then
      return nil
   end

   local ok, position = pcall(wezterm.json_parse, stdout)
   if not ok then
      wezterm.log_warn('Unable to parse window position: ' .. tostring(position))
      return nil
   end

   if type(position.x) ~= 'number' or type(position.y) ~= 'number' then
      return nil
   end

   return position
end

local function save(window, include_position)
   local dimensions = window:get_dimensions()
   if dimensions.is_full_screen then
      return
   end

   local state = read_state() or {}
   state.pixel_width = dimensions.pixel_width
   state.pixel_height = dimensions.pixel_height

   if include_position then
      local position = read_window_position()
      if position ~= nil then
         state.x = position.x
         state.y = position.y
      end
   end

   write_state(state)
end

function M.restore(window)
   local state = read_state()
   if state == nil then
      return
   end

   if type(state.x) == 'number' and type(state.y) == 'number' then
      window:set_position(state.x, state.y)
   end

   if type(state.pixel_width) ~= 'number' or type(state.pixel_height) ~= 'number' then
      return
   end

   window:set_inner_size(state.pixel_width, state.pixel_height)
end

function M.setup()
   wezterm.on('window-resized', function(window)
      save(window, true)
   end)

   wezterm.on('update-status', function(window)
      if not window:is_focused() then
         return
      end

      local now = os.time()
      if now - last_position_save < 5 then
         return
      end

      last_position_save = now
      save(window, true)
   end)
end

return M
