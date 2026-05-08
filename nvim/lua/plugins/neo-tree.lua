vim.pack.add({
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
})

vim.keymap.set(
  "n",
  "\\",
  "<cmd>Neotree reveal position=float<cr>",
  { desc = "NeoTree float", silent = true }
)

require("neo-tree").setup({
  filesystem = {
    window = {
      mappings = {
        ["\\"] = "close_window",
      },
    },
  },
})
