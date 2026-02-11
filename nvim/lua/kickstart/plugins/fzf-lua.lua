return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup {
        keymap = {
          builtin = {},
        },
      }
      vim.keymap.set('n', '<leader>sf', require('fzf-lua').files, { desc = '[S]earcg [F]iles' })
      vim.keymap.set('n', '<leader>sg', require('fzf-lua').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader><leader>', require('fzf-lua').buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>sn', function()
        require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
