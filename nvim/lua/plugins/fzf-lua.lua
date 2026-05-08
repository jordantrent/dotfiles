vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

vim.keymap.set(
  "n",
  "<leader>sf",
  require("fzf-lua").files,
  { desc = "[S]earch [F]iles" }
)

vim.keymap.set(
  "n",
  "<leader>sg",
  require("fzf-lua").live_grep,
  { desc = "[S]earch by [G]rep" }
)

vim.keymap.set(
  "n",
  "<leader><leader>",
  require("fzf-lua").buffers,
  { desc = "Find existing buffers" }
)

vim.keymap.set("n", "<leader>sn", function()
  require("fzf-lua").files({
    cwd = vim.fn.stdpath("config"),
  })
end, { desc = "[S]earch [N]eovim files" })

vim.keymap.set("n", "<leader>sc", function()
  require("fzf-lua").files({
    cwd = vim.fn.expand("~/.config"),
  })
end, { desc = "[S]earch [C]onfig files" })
