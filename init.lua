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
  use { 'wbthomason/packer.nvim' }

  -- Colorscheme
  use { "catppuccin/nvim", as = "catppuccin" }
  use {'nyoom-engineering/oxocarbon.nvim'}
  use { 'projekt0n/github-nvim-theme' }

  -- IDE
  use { "neovim/nvim-lspconfig" }
  use { "nvim-treesitter/nvim-treesitter" }
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })
  use { 'lewis6991/gitsigns.nvim' }
  use { 'nvim-tree/nvim-tree.lua',
      requires = {
        'nvim-tree/nvim-web-devicons', -- optional
      },
  }
  use { "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup {}
    end
  }

  use {
    'lervag/vimtex',
    event = { 'BufReadPre *.tex', 'BufNewFile *.tex' },
  }

  use {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    requires = {
      { 'neovim/nvim-lspconfig' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      require("lean").setup({ mappings = true })
    end
  }

  -- Autocompletion
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-path' }

  use { 'saadq/cmp_luasnip' }
  use { 'L3MON4D3/LuaSnip' }

  use({
    "kylechui/nvim-surround",
    tag = "*",
    config = function()
        require("nvim-surround").setup({})
    end
  })

  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- NVIM TREE --
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true -- optionally enable 24-bit colour
require("nvim-tree").setup({
  view = { width = 30 },
  renderer = {
    special_files = { "Makefile", "README.md", "requirements.txt", "*.opam", "*.install", "Dockerfile" },
  },
  actions = {
    open_file = {
      resize_window = true,
      window_picker = { enable = false },
    },
  },
})
-- NVIM TREE --

vim.opt.background = "dark"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.foldopen:remove('block')
vim.cmd("colorscheme catppuccin-frappe")
vim.cmd("set nu")
vim.cmd("set nowrap")

-- LSP

vim.lsp.enable({
  "pyright",
  "ruff",
  "ocamllsp",
  "rust_analyzer",
})

-- Keymaps

-- <leader> = <space>
vim.g.mapleader = " "

local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc, noremap = true })
end

-- nmap("gto", , "open neovim tree")
nmap("gd", vim.lsp.buf.definition, "Go to Definition")
nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
nmap("gr", vim.lsp.buf.references, "Find References")
nmap("<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, "Format Code")

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

-- VimTex

vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_view_method = 'zathura'

if vim.fn.has('wsl') then
  -- use the system clipboard for yank/paste
  vim.opt.clipboard = 'unnamedplus'
end

local treesitter = require('nvim-treesitter.configs');

treesitter.setup({
  -- Ensure that the parsers for your languages are installed
  ensure_installed = { "python", "ocaml", "rust", "c", "cpp", "lua", "bash", "fish", "html", "markdown", "json" },
  event = { "BufReadPre", "BufNewFile" },

  highlight = {
    enable = true,
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = { query = "@class.outer", desc = "Next class start" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[z"] = "@fold",
      },
    },
  }
})

