return function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'javascript',
    callback = function()
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
      vim.opt_local.softtabstop = 2
    end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
    end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.expandtab = true
    end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.expandtab = true
    end,
  })
end
