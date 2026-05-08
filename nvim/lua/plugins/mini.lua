return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.ai').setup { n_lines = 500 }

    require('mini.surround').setup {
      mappings = {
        add = 'gsa', -- Add surrounding
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find right surrounding
        find_left = 'gsF', -- Find left surrounding
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
        suffix_last = 'l',
        suffix_next = 'n',
      },
    }

    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
