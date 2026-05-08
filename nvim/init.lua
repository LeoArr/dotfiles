-- Leader keys must be set before plugins load
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'

-- vim: ts=2 sts=2 sw=2 et
