# WezTerm Config - Agent Instructions

## Project Type
- **WezTerm terminal emulator configuration** (dotfiles, not a software project)
- Language: Lua (LuaJIT)

## Structure
| Directory | Purpose |
|-----------|---------|
| `config/` | Modular config modules (bindings, appearance, domains, fonts, launch, general) |
| `colors/` | Theme definitions (latte/macchiato variants) |
| `events/` | Event handlers (left-status, right-status, tab-title, new-tab-button, gui-startup) |
| `utils/` | Utilities (backdrops, gpu-adapter, str, math, cells, platform, opts-validator) |
| `backdrops/` | Background images |
| `wezterm.lua` | **Entry point** - loads all config modules |

## Linting & Formatting
```bash
# Format (skip config/init.lua)
stylua -g '!/config/init.lua' wezterm.lua colors/ config/ events/ utils/

# Lint
luacheck wezterm.lua colors/* config/* events/* utils/*
```

Config: `.stylua.toml` (column_width=100, indent_width=3), `.luacheckrc` (max_line_length=150)

## Key Conventions
- **SUPER key**: `Alt` on Windows/Linux, `Cmd` on macOS
- **SUPER_REV**: `Alt+Ctrl` on Windows/Linux, `Cmd+Ctrl` on macOS
- **LEADER**: `SUPER_REV+Space`
- Theme toggle: `Alt+Shift+t` (cycles latte↔macchiato)
- Background randomizer loaded at startup via `utils.backdrops`

## Gotchas
- `config/init.lua` is excluded from stylua (has special indentation)
- `utils/backdrops.lua` has ignored luacheck code 212 (unreachable)
- GPU adapter selector only works when `front_end = "WebGpu"` in appearance config

## Custom WezTerm APIs Used
- `wezterm.config_builder()` - config chaining pattern
- `wezterm.gui` - GUI detection
- `wezterm.mux` - terminal multiplexing
- `wezterm.plugin` - plugin system

## References
- Official docs: https://wezfurlong.org/wezterm/config.html
- This config: https://github.com/KevinSilvester/wezterm-config