# WezTerm Config - Agent Instructions

## Project Type
- **WezTerm terminal emulator configuration** (dotfiles, not a software project)
- Language: Lua (LuaJIT)

## Structure
| Directory | Purpose |
|-----------|---------|
| `config/` | Small plain config modules (appearance, domains, fonts, launch, general) |
| `colors/` | Theme definitions (latte/macchiato variants) |
| `utils/` | Small utilities (platform detection only) |
| `backdrops/` | Background images retained for optional future use, not loaded by default |
| `perf-tests/` | Minimal diagnostic configs for frontend/rendering comparisons |
| `wezterm.lua` | **Entry point** - plain `wezterm.config_builder()` setup |

## Linting & Formatting
```bash
# Format
stylua wezterm.lua colors/ config/ utils/ perf-tests/

# Lint
luacheck wezterm.lua colors/* config/* utils/*
```

Config: `.stylua.toml` (column_width=100, indent_width=3), `.luacheckrc` (max_line_length=150)

## Key Conventions
- Custom keybindings are intentionally minimal; only Vim-aware pane jumping is configured
- Background images are not loaded by default; the default config uses a solid theme background

## Gotchas
- Rendering defaults prioritize smooth input on Windows: OpenGL, 60 FPS, no opacity, no cursor blink
- Window size/location persistence is intentionally disabled to avoid input/rendering stutter

## Custom WezTerm APIs Used
- `wezterm.config_builder()` - config chaining pattern

## References
- Official docs: https://wezfurlong.org/wezterm/config.html
- This config: https://github.com/KevinSilvester/wezterm-config
