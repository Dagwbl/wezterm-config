local Config = require('config')
local wezterm = require('wezterm')

local function get_scheme_for_appearance(appearance)
   if appearance:find('Dark') then
      return 'Catppuccin Macchiato'
   end
   return 'Catppuccin Latte'
end

local color_scheme = get_scheme_for_appearance(wezterm.gui.get_appearance())

local backdrops = require('utils.backdrops')
backdrops:scan_images_dir()

local bg_options = backdrops:initial_options({ no_img = false })
backdrops:random()

require('events.left-status').setup()
require('events.right-status').setup({ date_format = '%a %H:%M:%S' })
require('events.tab-title').setup({
   hide_active_tab_unseen = true,
   unseen_icon = 'numbered_box',
   show_progress = true,
})
require('events.new-tab-button').setup()
require('events.gui-startup').setup()

wezterm.on('toggle-theme', function(window)
   if color_scheme == 'Catppuccin Latte' then
      color_scheme = 'Catppuccin Macchiato'
   else
      color_scheme = 'Catppuccin Latte'
   end
   window:set_config_overrides({
      color_scheme = color_scheme,
   })
   local theme = color_scheme:find('Macchiato') and 'macchiato' or 'latte'
   backdrops:set_theme(theme)
   backdrops:random(window)
end)

local schemes = wezterm.color.get_builtin_schemes()
local fallback_bg = schemes[color_scheme]

local bg = bg_options or {
   {
      source = { Color = fallback_bg.background },
      height = '100%',
      width = '100%',
   },
}

local tab_bar_colors = fallback_bg.tab_bar

return Config:init()
   :append({
      color_scheme = color_scheme,
      background = bg,
      colors = {
         tab_bar = {
            background = 'rgba(0, 0, 0, 0)',
            },
      },
   })
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
