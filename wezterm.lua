local wezterm = require('wezterm')
local theme = require('colors.theme')
local act = wezterm.action

local config = wezterm.config_builder()

local function apply(options)
   for key, value in pairs(options) do
      config[key] = value
   end
end

local current_theme = theme.default
local pane_directions = {
   h = 'Left',
   j = 'Down',
   k = 'Up',
   l = 'Right',
}

local function is_vim(pane)
   if pane:get_user_vars().IS_NVIM == 'true' then
      return true
   end

   local process_name = pane:get_foreground_process_name() or ''
   process_name = process_name:gsub('(.*[/\\])(.*)', '%2'):lower()
   return process_name == 'nvim' or process_name == 'nvim.exe' or process_name == 'vim' or process_name == 'vim.exe'
end

local function pane_jump(key)
   return {
      key = key,
      mods = 'CTRL',
      action = wezterm.action_callback(function(window, pane)
         if is_vim(pane) then
            window:perform_action(act.SendKey({ key = key, mods = 'CTRL' }), pane)
         else
            window:perform_action(act.ActivatePaneDirection(pane_directions[key]), pane)
         end
      end),
   }
end

apply({
   color_scheme = theme.scheme_name(current_theme),
   keys = {
      pane_jump('h'),
      pane_jump('j'),
      pane_jump('k'),
      pane_jump('l'),
   },
})

apply(require('config.appearance'))
apply(require('config.domains'))
apply(require('config.fonts'))
apply(require('config.general'))
apply(require('config.launch'))

wezterm.on('toggle-theme', function(window)
   current_theme = current_theme == 'latte' and 'macchiato' or 'latte'

   local overrides = window:get_config_overrides() or {}
   overrides.color_scheme = theme.scheme_name(current_theme)
   window:set_config_overrides(overrides)
end)

return config
