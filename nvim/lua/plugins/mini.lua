vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.nvim"},
  { src = "https://github.com/maximilianlloyd/ascii.nvim"}
})

require('mini.ai').setup { n_lines = 500 }

local ascii_header = require('ascii').art.text.neovim.bloody

require('mini.starter').setup {
  header = table.concat(ascii_header, '\n'),
  footer = '',
}

require('mini.surround').setup()

require('mini.statusline').setup({
  use_icons = vim.g.have_nerd_font
})


