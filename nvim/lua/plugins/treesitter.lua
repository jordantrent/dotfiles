vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require("nvim-treesitter").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  }
})

require("nvim-treesitter").install { "rust", "javascript", "typescript", "tsx", "go" }

