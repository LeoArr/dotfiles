-- Resolve the repo's default branch: prefer the remote's HEAD (origin/HEAD),
-- fall back to a local main/master, then to 'master'.
local function default_branch()
  local function git(args)
    local out = vim.fn.systemlist({ 'git', unpack(args) })
    if vim.v.shell_error ~= 0 or not out[1] or out[1] == '' then
      return nil
    end
    return out[1]
  end

  local head = git { 'symbolic-ref', '--short', '-q', 'refs/remotes/origin/HEAD' }
  if head then
    return head:gsub('^origin/', '')
  end
  for _, name in ipairs { 'main', 'master' } do
    if git { 'rev-parse', '--verify', '-q', name } then
      return name
    end
  end
  return 'master'
end

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
  keys = {
    -- Review working-tree changes (unstaged + staged vs HEAD)
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[D]iff working tree' },
    -- Review the whole current branch against the repo's default branch
    {
      '<leader>gb',
      function()
        vim.cmd('DiffviewOpen ' .. default_branch() .. '...HEAD')
      end,
      desc = 'Diff [B]ranch vs default',
    },
    -- History of all changes in the repo
    { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = 'File [H]istory (repo)' },
    -- History of the current file only
    { '<leader>gf', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history ([F]ile)' },
    -- History of the visually selected lines
    { '<leader>gf', "<esc><cmd>'<,'>DiffviewFileHistory<cr>", desc = 'File history (selection)', mode = 'v' },
    -- Close the diffview tab
    { '<leader>gc', '<cmd>DiffviewClose<cr>', desc = '[C]lose diffview' },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      -- Single-file review reads best side-by-side
      default = { layout = 'diff2_horizontal' },
      -- Merge conflicts: working copy in the middle, both sides flanking it
      merge_tool = { layout = 'diff3_mixed', disable_diagnostics = true },
    },
    keymaps = {
      view = {
        { 'n', '<tab>', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle file panel' } },
      },
      file_panel = {
        { 'n', '<tab>', '<cmd>DiffviewToggleFiles<cr>', { desc = 'Toggle file panel' } },
      },
    },
  },
}
