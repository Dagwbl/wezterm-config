---@type Wezterm
local wezterm = require('wezterm')
local launch_menu = require('config.launch').launch_menu
local domains = require('config.domains')
local Cells = require('utils.cells')

local nf = wezterm.nerdfonts
local act = wezterm.action
local attr = Cells.attr
local schemes = wezterm.color.get_builtin_schemes()

local M = {}

---@param scheme_name string
---@return table<string, Cells.SegmentColors>
local function get_colors(scheme_name)
   local scheme = schemes[scheme_name]
   return {
      label_text   = { fg = scheme.foreground },
      icon_default = { fg = scheme.ansi[5] },
      icon_wsl     = { fg = scheme.ansi[3] },
      icon_ssh     = { fg = scheme.ansi[1] },
      icon_unix    = { fg = scheme.ansi[6] },
   }
end

local default_scheme = wezterm.gui.get_appearance():find('Dark') and 'Catppuccin Macchiato' or 'Catppuccin Latte'
local colors = get_colors(default_scheme)

local cells = Cells:new()
   :add_segment('icon_default', ' ' .. nf.oct_terminal .. ' ')
   :add_segment('icon_wsl', ' ' .. nf.cod_terminal_linux .. ' ')
   :add_segment('icon_ssh', ' ' .. nf.md_ssh .. ' ')
   :add_segment('icon_unix', ' ' .. nf.dev_gnu .. ' ')
   :add_segment('label_text', '')

local function build_choices()
   local choices = {}
   local choices_data = {}
   local idx = 1

   -- Add launch menu items (DefaultDomain)
   for _, v in ipairs(launch_menu) do
      cells:update_segment_text('label_text', v.label)

      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_default', 'label_text' })),
      })
      table.insert(choices_data, {
         args = v.args,
         domain = 'DefaultDomain',
      })
      idx = idx + 1
   end

   -- Add WSL domains
   for _, v in ipairs(domains.wsl_domains) do
      cells:update_segment_text('label_text', v.name)

      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_wsl', 'label_text' })),
      })
      table.insert(choices_data, {
         domain = { DomainName = v.name },
      })
      idx = idx + 1
   end

   -- Add SSH domains
   for _, v in ipairs(domains.ssh_domains) do
      cells:update_segment_text('label_text', v.name)
      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_ssh', 'label_text' })),
      })
      table.insert(choices_data, {
         domain = { DomainName = v.name },
      })
      idx = idx + 1
   end

   -- Add Unix domains
   for _, v in ipairs(domains.unix_domains) do
      cells:update_segment_text('label_text', v.name)
      table.insert(choices, {
         id = tostring(idx),
         label = wezterm.format(cells:render({ 'icon_unix', 'label_text' })),
      })
      table.insert(choices_data, {
         domain = { DomainName = v.name },
      })
      idx = idx + 1
   end

   return choices, choices_data
end

local choices, choices_data = build_choices()

M.setup = function()
   wezterm.on('new-tab-button-click', function(window, pane, button, default_action)
      if default_action and button == 'Left' then
         window:perform_action(default_action, pane)
      end

      if button == 'Right' then
         local scheme = window:effective_config().color_scheme or default_scheme
         local current_colors = get_colors(scheme)

         cells:update_segment_colors('icon_default', current_colors.icon_default)
         cells:update_segment_colors('icon_wsl', current_colors.icon_wsl)
         cells:update_segment_colors('icon_ssh', current_colors.icon_ssh)
         cells:update_segment_colors('icon_unix', current_colors.icon_unix)
         cells:update_segment_colors('label_text', current_colors.label_text)

         local function apply_colors_to_choices(choice_list)
            for i, v in ipairs(choice_list) do
               local icon_key
               if i <= #launch_menu then
                  icon_key = 'icon_default'
               elseif i <= #launch_menu + #domains.wsl_domains then
                  icon_key = 'icon_wsl'
               elseif i <= #launch_menu + #domains.wsl_domains + #domains.ssh_domains then
                  icon_key = 'icon_ssh'
               else
                  icon_key = 'icon_unix'
               end
               cells:update_segment_text('label_text', v.label)
               cells:update_segment_colors(icon_key, current_colors[icon_key])
               cells:update_segment_colors('label_text', current_colors.label_text)
               v.label = wezterm.format(cells:render({ icon_key, 'label_text' }))
            end
         end

         apply_colors_to_choices(choices)

         window:perform_action(
            act.InputSelector({
               title = 'InputSelector: Launch Menu',
               choices = choices,
               fuzzy = true,
               fuzzy_description = nf.md_rocket .. ' Select a lauch item: ',
               action = wezterm.action_callback(function(_window, _pane, id, label)
                  if not id and not label then
                     return
                  end
                  wezterm.log_info('you selected ', id, label)
                  wezterm.log_info(choices_data[tonumber(id)])
                  window:perform_action(act.SpawnCommandInNewTab(choices_data[tonumber(id)]), pane)
               end),
            }),
            pane
         )
      end

      return false
   end)
end

return M
