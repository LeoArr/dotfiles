-- Requires treesitter parsers: :TSInstall markdown markdown_inline
return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  dependencies = { 'saghen/blink.cmp' },
  keys = {
    { '<leader>mv', '<cmd>Markview toggle<cr>', desc = '[M]ark[v]iew toggle' },
    { '<leader>ms', '<cmd>Markview splitToggle<cr>', desc = '[M]arkview [S]plit toggle' },
    { '<leader>mh', '<cmd>Markview hybridToggle<cr>', desc = '[M]arkview [H]ybrid toggle' },
  },
}
