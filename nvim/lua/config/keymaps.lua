local map = vim.keymap.set

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('n', '<leader>Q', vim.diagnostic.setqflist, { desc = 'Open workspace diagnostic [Q]uickfix list' })

-- Helix-style line motions
map({ 'n', 'v' }, 'gl', '$', { desc = 'Go to end of line' })
map({ 'n', 'v' }, 'gs', '^', { desc = 'Go to start of line' })

-- Keep selection after indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Move by visual lines
map({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'n', 'v' }, '<Down>', 'gj', { silent = true })
map({ 'n', 'v' }, '<Up>', 'gk', { silent = true })

-- Terminal escape
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation (also overridden by tmux-navigation when active)
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- File / buffer ops
map('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })
map('n', '<leader>W', '<cmd>noa w<cr>', { desc = 'Save without formatting' })
map('n', '<leader>bd', '<cmd>bd<cr>', { desc = '[D]elete [B]uffer' })
