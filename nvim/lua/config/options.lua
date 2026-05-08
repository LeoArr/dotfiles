local o, opt = vim.o, vim.opt

o.number = true
o.mouse = 'a'
o.showmode = false
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.list = true
o.inccommand = 'split'
o.cursorline = true
o.scrolloff = 10
o.confirm = true
o.wrap = true
o.linebreak = true
o.showbreak = '↪ '

opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Defer clipboard sync (faster startup)
vim.schedule(function()
  o.clipboard = 'unnamedplus'
end)
