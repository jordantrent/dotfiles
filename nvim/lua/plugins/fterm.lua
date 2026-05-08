vim.pack.add({
    { src = "https://github.com/numToStr/Fterm.nvim"}
}) 

vim.keymap.set('n', '<C-y>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-y>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

require("FTerm").setup({
  dimensions = {
    height = 0.8,
    width = 0.8
  }
})

