require('lazy').setup({

  'NMAC427/guess-indent.nvim',

  require 'kickstart.plugins.gitsigns',

  require 'kickstart.plugins.which-key',

  require 'kickstart.plugins.fzf-lua',

  require 'kickstart.plugins.lspconfig',

  require 'kickstart.plugins.conform',

  require 'kickstart.plugins.blink-cmp',

  require 'kickstart.plugins.catppuccin',

  require 'kickstart.plugins.todo-comments',

  require 'kickstart.plugins.mini',

  require 'kickstart.plugins.treesitter',

  require 'kickstart.plugins.autopairs',

  require 'kickstart.plugins.neo-tree',

  require 'kickstart.plugins.ascii',

  require 'kickstart.plugins.lazygit',

  require 'kickstart.plugins.fterm',

  require 'kickstart.plugins.opencode',

  require 'kickstart.plugins.gh-dash',

  require 'kickstart.plugins.markview',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
