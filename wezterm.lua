local Config = require('config')
local wezterm = require('wezterm')
local theme = require('colors.theme')

local current_theme = theme.default

local backdrops = require('utils.backdrops')
backdrops:scan_images_dir()
backdrops:set_theme(current_theme)

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
   current_theme = current_theme == 'latte' and 'macchiato' or 'latte'
   local overrides = window:get_config_overrides() or {}
   overrides.color_scheme = theme.scheme_name(current_theme)
   window:set_config_overrides(overrides)

   backdrops:set_theme(current_theme)
   backdrops:random(window)
end)

local bg = bg_options or {
   {
      source = { Color = theme.colors(current_theme).background },
      height = '100%',
      width = '100%',
   },
}

return Config:init()
   :append({
      color_scheme = theme.scheme_name(current_theme),
      background = bg,
   })
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
