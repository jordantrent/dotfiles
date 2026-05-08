vim.pack.add({
  { src = "https://github.com/catppuccin/nvim"}
})

require("catppuccin").setup({
  flavour = "frappe"
})

vim.cmd.colorscheme "catppuccin-nvim"
