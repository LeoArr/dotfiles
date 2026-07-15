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

-- Defer clipboard sync (faster startup). Locally Neovim picks up wl-copy/xclip;
-- over SSH there is none, so copy via OSC 52 instead — tmux passes it through
-- (set-clipboard / allow-passthrough) and the local terminal writes the real
-- clipboard. Pasting from the system comes from the terminal (Ctrl+Shift+V),
-- so the OSC 52 paste side just returns the last yank instead of querying.
vim.schedule(function()
  o.clipboard = 'unnamedplus'
  if vim.env.SSH_TTY then
    local osc52 = require 'vim.ui.clipboard.osc52'
    local function paste()
      return { vim.split(vim.fn.getreg '"', '\n'), vim.fn.getregtype '"' }
    end
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = { ['+'] = osc52.copy '+', ['*'] = osc52.copy '*' },
      paste = { ['+'] = paste, ['*'] = paste },
    }
  end
end)
