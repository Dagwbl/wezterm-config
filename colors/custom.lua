-- Catppuccin Latte and Macchiato for Wezterm
-- stylua: ignore

-- Light theme (Latte)
local latte = {
   rosewater = '#dc8a78',
   flamingo  = '#dd7878',
   pink      = '#ea76cb',
   mauve     = '#8839ef',
   red       = '#d20f39',
   maroon    = '#e64553',
   peach     = '#fe640b',
   yellow    = '#df8e1d',
   green     = '#40a02b',
   teal      = '#179299',
   sky       = '#04a5e5',
   sapphire  = '#209fb5',
   blue      = '#1e66f5',
   lavender  = '#7287fd',
   text      = '#4c4c4c',
   subtext1  = '#5c5f77',
   subtext0  = '#737487',
   overlay2  = '#9099b2',
   overlay1  = '#8c8fa1',
   overlay0  = '#7d7f99',
   surface2  = '#bccddc',
   surface1  = '#ccd4e3',
   surface0  = '#dce0e8',
   base      = '#fdf6e3',
   mantle    = '#eee8d5',
   crust     = '#ddd6c1',
}

-- Dark theme (Macchiato)
local macchiato = {
   rosewater = '#f5e0dc',
   flamingo = '#f2cdcd',
   pink = '#f5c2e7',
   mauve = '#cba6f7',
   red = '#f38ba8',
   maroon = '#eba0ac',
   peach = '#fab387',
   yellow = '#f9e2af',
   green = '#a6e3a1',
   teal = '#94e2d5',
   sky = '#89dceb',
   sapphire = '#74c7ec',
   blue = '#89b4fa',
   lavender = '#b4befe',
   text = '#cdd6f4',
   subtext1 = '#bac2de',
   subtext0 = '#a6adc8',
   overlay2 = '#9399b2',
   overlay1 = '#7f849c',
   overlay0 = '#6c7086',
   surface2 = '#585b70',
   surface1 = '#45475a',
   surface0 = '#313244',
   base = '#232634',
   mantle = '#181825',
   crust = '#11111b',
}

local function create_colorscheme(theme)
   local c = theme
   return {
      foreground = c.text,
      background = c.base,
      cursor_bg = c.rosewater,
      cursor_border = c.rosewater,
      cursor_fg = c.crust,
      selection_bg = c.surface2,
      selection_fg = c.text,
      ansi = {
         c.mantle,
         c.red,
         c.green,
         c.yellow,
         c.blue,
         c.mauve,
         c.teal,
         c.crust,
      },
      brights = {
         c.overlay0,
         c.red,
         c.green,
         c.yellow,
         c.blue,
         c.mauve,
         c.sky,
         c.text,
      },
      tab_bar = {
         background = 'rgba(0, 0, 0, 0.2)',
         active_tab = {
            bg_color = c.blue,
            fg_color = c.crust,
         },
         inactive_tab = {
            bg_color = c.mantle,
            fg_color = c.subtext1,
         },
         inactive_tab_hover = {
            bg_color = c.peach,
            fg_color = c.crust,
         },
         new_tab = {
            bg_color = c.base,
            fg_color = c.text,
         },
         new_tab_hover = {
            bg_color = c.mantle,
            fg_color = c.text,
            italic = true,
         },
      },
      visual_bell = c.yellow,
      indexed = {
         [16] = c.peach,
         [17] = c.rosewater,
      },
      scrollbar_thumb = c.surface1,
      split = c.overlay0,
      compose_cursor = c.flamingo,
   }
end

return {
   latte = create_colorscheme(latte),
   macchiato = create_colorscheme(macchiato),
}
