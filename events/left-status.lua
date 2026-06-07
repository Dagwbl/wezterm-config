---@type Wezterm
local wezterm = require('wezterm')
local Cells = require('utils.cells')

local nf = wezterm.nerdfonts
local attr = Cells.attr
local schemes = wezterm.color.get_builtin_schemes()

local M = {}

local GLYPH_SEMI_CIRCLE_LEFT = nf.ple_left_half_circle_thick --[[ '' ]]
local GLYPH_SEMI_CIRCLE_RIGHT = nf.ple_right_half_circle_thick --[[ '' ]]
local GLYPH_KEY_TABLE = nf.md_table_key --[[ '󱏅' ]]
local GLYPH_KEY = nf.md_key --[[ '󰌆' ]]

---@param scheme_name string
---@return table<string, Cells.SegmentColors>
local function get_colors(scheme_name)
   local scheme = schemes[scheme_name]
   local is_dark = scheme.background:lower():find('^#1[13]') or scheme.background:lower():find('^#0')
   if is_dark then
      return {
         default = { bg = scheme.ansi[4], fg = scheme.background },
         scircle = { bg = 'rgba(0, 0, 0, 0)', fg = scheme.ansi[4] },
      }
   else
      return {
         default = { bg = scheme.ansi[3], fg = scheme.background },
         scircle = { bg = 'rgba(238, 232, 213, 0)', fg = scheme.ansi[3] },
      }
   end
end

local cells = Cells:new()

cells
   :add_segment(1, GLYPH_SEMI_CIRCLE_LEFT)
   :add_segment(2, ' ')
   :add_segment(3, ' ')
   :add_segment(4, GLYPH_SEMI_CIRCLE_RIGHT)

M.setup = function()
   wezterm.on('update-status', function(window, _pane)
      local scheme = window:effective_config().color_scheme or 'Catppuccin Latte'
      local colors = get_colors(scheme)

      cells:update_segment_colors(1, colors.scircle)
      cells:update_segment_colors(2, colors.default)
      cells:update_segment_colors(3, colors.default)
      cells:update_segment_colors(4, colors.scircle)

      local name = window:active_key_table()
      local res = {}

      if name then
         cells
            :update_segment_text(2, GLYPH_KEY_TABLE)
            :update_segment_text(3, ' ' .. string.upper(name))
         res = cells:render_all()
      end

      if window:leader_is_active() then
         cells:update_segment_text(2, GLYPH_KEY):update_segment_text(3, ' ')
         res = cells:render_all()
      end
      window:set_left_status(wezterm.format(res))
   end)
end

return M
