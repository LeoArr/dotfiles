# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for a Linux (Fedora, Ubuntu, and other distros) development environment. All configs live here and are symlinked to their canonical locations under `~/.config/`. The `.gitignore` uses an allowlist pattern — everything is ignored by default, and only the explicitly listed directories are tracked:

- `nvim/` → `~/.config/nvim`
- `helix/` → `~/.config/helix`
- `ghostty/` → `~/.config/ghostty`
- `tmux/` → `~/.config/tmux`
- `yazi/` → `~/.config/yazi`
- `lazygit/` → `~/.config/lazygit`
- `starship/` → `~/.config/starship`
- `.bash_profile` → `~/.bash_profile`
- `.bashrc` → `~/.bashrc`

`install.sh` creates the symlinks (backing up anything in the way, and migrating a pre-existing real `~/.bashrc` to `~/.bashrc.local`). Edits take effect immediately on next launch of the respective tool (no build step).

## Clipboard & keys architecture (do not regress)

**OSC 52 is the single clipboard transport.** The terminal (Ghostty) owns the system clipboard; tmux and Neovim copy by emitting OSC 52, which works identically on Wayland, X11, and over SSH. Never reintroduce `pbcopy`/`xclip`/`wl-copy` pipes. The load-bearing pieces:

- tmux: `set-clipboard on`, `allow-passthrough on`, copy bindings use `copy-selection-and-cancel` (no external command)
- Neovim: `clipboard=unnamedplus`; when `$SSH_TTY` is set, an explicit OSC 52 provider (copy only — paste comes from the terminal via Ctrl+Shift+V)
- `.bashrc` falls back to `TERM=xterm-256color` when ghostty's terminfo is missing (servers)

**Shift+Enter newline in Claude Code:** Ghostty binds `shift+enter` to send `ESC+CR` (`text:\x1b\r`); tmux additionally enables `extended-keys` for kitty-protocol apps.

## Neovim

See `nvim/CLAUDE.md` for full details — it covers architecture, formatting, keymaps, plugin layout, and Java/DAP setup.

**Formatting:** all Lua files use `stylua` (config in `nvim/.stylua.toml`): 2-space indent, single quotes, 160-col width.

```sh
stylua nvim/lua/path/to/file.lua   # format one file
stylua nvim/lua/                   # format all
```

## Consistent theme

The whole environment uses **Catppuccin Macchiato** across all tools:
- Ghostty: `theme = Catppuccin Macchiato` (`ghostty/config`)
- Helix: `theme="catppuccin_macchiato"` (`helix/config.toml`)
- tmux: `@catppuccin_flavor "macchiato"` (`tmux/tmux.conf`)
- Neovim: Catppuccin Macchiato via `lua/plugins/colorscheme.lua`

When adding new tools, keep this theme consistent.

## tmux

Prefix is `C-a`. Key non-default bindings:
- `|` / `-` — split horizontally/vertically (preserves cwd)
- `[` / `]` — switch sessions
- `C-h/j/k/l` — navigate panes (aware of Neovim splits via the `is_vim` check)
- `r` — reload config

Plugins are vendored into `tmux/plugins/` (TPM, catppuccin, tmux-battery, tmux-cpu). To install new plugins via TPM: add to `tmux.conf` then press `prefix + I`.

## Shell

Three-file structure; everything is guarded (`command -v` / dir checks) so the same files work on Fedora, Ubuntu, and headless servers:

- `.bashrc` (tracked) — all interactive setup: pyenv, starship, `EDITOR=nvim`, the `y` yazi-cwd wrapper, terminfo fallback. Sourced by every interactive shell, including tmux panes.
- `.bash_profile` (tracked) — login shells only: PATH for `~/.local/bin`, Caps Lock → Escape via `gsettings` (GNOME only), then sources `.bashrc`.
- `~/.bashrc.local` (never tracked) — machine-specific config (work Kerberos, JAVA_HOME, aliases). Sourced at the end of `.bashrc`; must never source `.bash_profile` back.

## Helix

Config at `helix/config.toml`. Language servers defined in `helix/languages.toml`:
- Python: `pylsp` with ruff + pylint enabled, autopep8/yapf/flake8/pyflakes/pycodestyle disabled
- Java: 4-space indent, jdb debugger on TCP

## Yazi

`yazi/yazi.toml` registers the `rich-preview` plugin for csv, md, rst, ipynb, json, py, java files. Flavors: catppuccin-latte and catppuccin-macchiato.
