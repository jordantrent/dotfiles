return {
  {
    'numToStr/Fterm.nvim',
    config = function()
      require('FTerm').setup {
        dimensions = {
          height = 0.8,
          width = 0.8,
        },
      }
      -- Example keybindings
      vim.keymap.set('n', '<C-y>', '<CMD>lua require("FTerm").toggle()<CR>')
      vim.keymap.set('t', '<C-y>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    end,
  },
}
