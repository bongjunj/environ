require("config.lazy")
require'lspconfig'.ocamllsp.setup{}

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

vim.opt.wrap = true
vim.opt.breakindent = true

vim.cmd [[colorscheme tokyonight]]
