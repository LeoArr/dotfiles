# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It is symlinked to `~/.config/nvim` — edits here take effect immediately on next Neovim launch.

## Formatting

All Lua files must be formatted with **stylua**. Configuration is in `.stylua.toml`:
- 2-space indent, single quotes preferred, 160-column width, Unix line endings.

Format a file:
```sh
stylua lua/path/to/file.lua
```

Format everything:
```sh
stylua lua/
```

## Architecture

Entry point is `init.lua`, which sets leader keys and then loads four modules in order:

```
init.lua
  → lua/config/options.lua    # vim.o / vim.opt settings
  → lua/config/keymaps.lua    # global keybindings
  → lua/config/autocmds.lua   # autocommands (+ loads lua/work/filetypes.lua)
  → lua/config/lazy.lua       # bootstraps lazy.nvim, imports lua/plugins/*
```

### Plugin organisation (`lua/plugins/`)

Each file returns a lazy.nvim plugin spec (or a list of specs). Lazy auto-imports everything in this directory.

| File | Purpose |
|------|---------|
| `lsp.lua` | nvim-lspconfig + mason + mason-lspconfig + blink.cmp capabilities. jdtls is explicitly excluded from mason's auto-handler (handled by `java.lua`). |
| `completion.lua` | blink.cmp with LuaSnip; `super-tab` preset. |
| `telescope.lua` | File/grep search; all `<leader>s*` keymaps live here. |
| `conform.lua` | Format-on-save (disabled for c/cpp); `<leader>f` to format manually. |
| `dap.lua` | nvim-dap + dapui + virtual text; Java attach config targeting port 8000. |
| `java.lua` | nvim-jdtls (loaded on `ft=java`); connects to jdtls and java-debug-adapter from Mason. |
| `mini.lua` | mini.ai, mini.surround (`gs*` mappings), mini.statusline. |
| `navigation.lua` | nvim-tmux-navigation; `<C-hjkl>` work across tmux panes. |
| `treesitter.lua` | Syntax highlighting / textobjects. |
| `colorscheme.lua` | Catppuccin Macchiato. |
| `editor.lua` | Autopairs, indent-blankline, guess-indent, todo-comments, AniMotion. |
| `gitsigns.lua` | Git hunk signs in the gutter. |
| `auto-session.lua` | Session save/restore. |
| `markview.lua` | In-buffer markdown preview with hybrid/split modes. |
| `which-key.lua` | Keybinding hints. |
| `yazi.lua` | Yazi file manager integration. |

### Work-specific overrides (`lua/work/`)

`lua/work/filetypes.lua` is called from `autocmds.lua` and sets per-filetype indent settings (js: 2, java: 4, lua: 4, python: 4). Add work-specific config here rather than polluting the main config.

## Key mappings cheat sheet

Leader is `<Space>`.

| Key | Action |
|-----|--------|
| `<leader>sf` | Find files (Telescope) |
| `<leader>sg` | Live grep (regex) |
| `<leader><leader>` | Find open buffers |
| `<leader>f` | Format buffer |
| `<leader>w` / `<leader>W` | Save / save without formatting |
| `<leader>bd` | Delete buffer |
| `gl` / `gs` | End / start of line (Helix-style) |
| `grn` / `gra` / `grr` | LSP rename / code action / references |
| `grd` / `gri` / `grt` | LSP definition / implementation / type def |
| `<F5>/<F10>/<F11>/<F12>` | DAP continue/over/into/out |
| `<leader>db` / `<leader>dB` | Toggle breakpoint / conditional breakpoint |

## Adding new plugins

Add a new file in `lua/plugins/` returning a lazy.nvim spec. Lazy picks it up automatically — no registration needed.

## Java setup

jdtls and java-debug-adapter must be installed via Mason (`:Mason`). The DAP config attaches to a process on `127.0.0.1:8000` (i.e. `mvnDebug` or equivalent).
