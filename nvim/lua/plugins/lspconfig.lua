vim.pack.add({
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig"},
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
})

require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    "lua-language-server",
    "rust-analyzer",
  },
})

vim.lsp.enable({
  "lua_ls",
  "tsgo",
  "rust_analyzer",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, {
        buffer = event.buf,
        desc = "LSP: " .. desc,
      })
    end

    map("K", vim.lsp.buf.hover, "Hover")
    map("grn", vim.lsp.buf.rename, "Rename")
    map("gra", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

    map("grd", require("fzf-lua").lsp_definitions, "Definitions")
    map("grr", require("fzf-lua").lsp_references, "References")
    map("gri", require("fzf-lua").lsp_implementations, "Implementations")

    map("gO", require("fzf-lua").lsp_document_symbols, "Document Symbols")
    map("gW", require("fzf-lua").lsp_workspace_symbols, "Workspace Symbols")
  end,
})

