vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

require 'options'

require 'keymaps'

require ("plugins.neo-tree")
require ("plugins.mini")
require ("plugins.catppuccin")
require ("plugins.fzf-lua")
require ("plugins.treesitter")
require ("plugins.autopairs")
require ("plugins.conform")
require ("plugins.fterm")
require ("plugins.lazygit")
require ("plugins.lspconfig")
require ("plugins.blink-cmp")
require ("plugins.todo-comments")

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
  },
  callback = function(args)
    vim.treesitter.start(args.buf)
  end,
})
