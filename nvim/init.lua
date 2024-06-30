require("config.lazy")

local lspconfig = require('lspconfig')
lspconfig.ocamllsp.setup{}
lspconfig.pyright.setup{}

require('tokyonight').setup({
  transparent = true,
    styles = {
      comments = { italic = true },
    }
})

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

vim.opt.wrap = true
vim.opt.breakindent = true

vim.cmd [[colorscheme tokyonight]]
