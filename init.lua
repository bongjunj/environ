
-- Packer Plugin Manager
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use { "catppuccin/nvim", as = "catppuccin" }

  -- IDE
  use { "neovim/nvim-lspconfig" }
  use { "nvim-treesitter/nvim-treesitter" }
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-path' }

	use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
	})

  use {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		requires = { {'nvim-lua/plenary.nvim'} }
	}


  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

vim.cmd("colorscheme catppuccin")
vim.cmd("set nu")
vim.cmd("set shiftwidth=2")
vim.cmd("set tabstop=2")

-- LSP

vim.lsp.enable({
  "pyright",
  "ocamllsp",
  "rust_analyzer",
})

-- Keymaps

-- <leader> = <space>
vim.g.mapleader = " "

local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc, buffer = 0 })
end

nmap("gd", vim.lsp.buf.definition, "Go to Definition")
nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
nmap("gr", vim.lsp.buf.references, "Find References")
nmap("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
nmap("<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, "Format Code")
nmap("<leader>e", vim.diagnostic.open_float, "Show Diagnostics")
nmap("<leader>o", vim.lsp.buf.document_symbol, "Show Document Symbols")

local builtin = require('telescope.builtin')
nmap('<leader>ff', builtin.find_files, 'Telescope find files')
nmap('<leader>fs', builtin.lsp_document_symbols, 'Telescope find symbols')
nmap('<leader>fg', builtin.live_grep, 'Telescope live grep')
nmap('<leader>fb', builtin.buffers, 'Telescope buffers')
nmap('<leader>fh', builtin.help_tags, 'Telescope help tags')

local cmp = require('cmp')

cmp.setup({
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	}),
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
})


