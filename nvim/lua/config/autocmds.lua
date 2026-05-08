local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Force normal mode for real file buffers (fixes Telescope opening in insert)
autocmd('BufWinEnter', {
  desc = 'Start in normal mode for real files only',
  group = augroup('normal-mode-on-open', { clear = true }),
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype ~= '' then
      return
    end
    if vim.api.nvim_buf_get_name(buf) == '' then
      return
    end
    if vim.fn.mode() == 'i' then
      vim.cmd 'stopinsert'
    end
  end,
})

-- Work-specific filetype overrides
require 'work.filetypes'()
