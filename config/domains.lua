local platform = require('utils.platform')

local options = {
   -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ---@type SshDomain[]
   ssh_domains = {},

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   ---@type UnixDomain[]
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   ---@type WslDomain[]
   wsl_domains = {},
}

if platform.is_win then
   options.ssh_domains = {
      {
         name = 'ssh:wsl',
         username = 'jinpeng6',
         remote_address = 'wvliu-gd15',
         multiplexing = 'None',
         default_prog = { 'bash', '-l' },
         assume_shell = 'Posix',
      },
   }

   options.wsl_domains = {
      {
         name = 'wsl:ubuntu-fish',
         distribution = 'Ubuntu',
         username = 'pumbaa',
         default_cwd = '/home/pumbaa',
         default_prog = { 'fish', '-l' },
      },
      {
         name = 'wsl:ubuntu-bash',
         distribution = 'Ubuntu',
         username = 'pumbaa',
         default_cwd = '/home/pumbaa',
         default_prog = { 'bash', '-l' },
      },
   }
end

return options
