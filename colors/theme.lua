local wezterm = require('wezterm')

local M = {}

M.default = 'macchiato'

M.names = {
   latte = 'Catppuccin Latte',
   macchiato = 'Catppuccin Macchiato',
}

local schemes = wezterm.color.get_builtin_schemes()

function M.scheme_name(theme)
   local name = M.names[theme]
   assert(name ~= nil, 'Unknown theme: ' .. tostring(theme))
   return name
end

function M.colors(theme)
   local scheme = schemes[M.scheme_name(theme)]
   assert(scheme ~= nil, 'Unknown built-in color scheme: ' .. M.scheme_name(theme))
   return scheme
end

return M
