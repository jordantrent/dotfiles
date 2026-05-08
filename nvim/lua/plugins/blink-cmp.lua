vim.pack.add({
  { src = 'https://github.com/Saghen/blink.cmp', version = 'v1' }
})

require('blink.cmp').setup {
  fuzzy = { implementation = "lua" },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
}
