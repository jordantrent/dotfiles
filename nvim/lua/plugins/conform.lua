vim.pack.add({
  { src = "https://github.com/stevearc/conform.nvim"}
})

require("conform").setup({
  formatters_by_ft = {
    javascript = { 'prettierd', 'prettier' },
    typescript = { 'prettierd', 'prettier' },
    javascriptreact = { 'prettierd', 'prettier' },
    typescriptreact = { 'prettierd', 'prettier' },
    json = { 'prettierd', 'prettier' },
    html = { 'prettierd', 'prettier' },
    css = { 'prettierd', 'prettier' },
    markdown = { 'prettierd', 'prettier' },
  },
})
