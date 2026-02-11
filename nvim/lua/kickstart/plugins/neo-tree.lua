-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<Leader>b', ':Neotree reveal position=left<CR>', desc = 'NeoTree reveal', silent = true },
    { '\\', ':Neotree reveal position=float<CR>', desc = 'NeoTree float', silent = true },
    { '<Leader>git', ':Neotree float git_status<CR>', desc = 'NeoTree git status', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
