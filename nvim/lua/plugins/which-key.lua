return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font, keys = vim.g.have_nerd_font and {} or nil },
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>g', group = '[G]it diff', mode = { 'n', 'v' } },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>b', group = '[B]uffer' },
    },
  },
}
