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

  -- IDE
  use { "neovim/nvim-lspconfig" }
  use { "nvim-treesitter/nvim-treesitter" }
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })
  use {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }
  use { 'lewis6991/gitsigns.nvim' }
  use { "projekt0n/github-nvim-theme" }
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

  -- Autocompletion
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }

  use({
    "kylechui/nvim-surround",
    tag = "*",
    config = function()
        require("nvim-surround").setup({})
    end
  })

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
local has_github_theme, github_theme = pcall(require, "github-theme")
if has_github_theme then
  github_theme.setup({
    options = {
      transparent = false,
      terminal_colors = true,
    },
  })
  vim.cmd.colorscheme("github_dark")
end
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

require("gitsigns").setup()

vim.opt.background = "dark"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.foldopen:remove('block')
vim.cmd("set nu")
vim.cmd("set nowrap")

-- LSP

vim.lsp.enable({
  "pyright",
  "ruff",
  "ocamllsp",
  "rust_analyzer",
  "bashls",
})

-- Keymaps

-- <leader> = <space>
vim.g.mapleader = " "

local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc, noremap = true })
end

-- system clipboard

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

-- utilities
nmap("<leader>ff", require("telescope.builtin").find_files, "Find Files")

-- lsp shortcuts
nmap("K", vim.lsp.buf.hover, "Hover Documentation")
nmap("<leader>e", vim.diagnostic.open_float, "Show Line Diagnostics")

nmap("gd", vim.lsp.buf.definition, "Go to Definition")
nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
nmap("gr", vim.lsp.buf.references, "Find References")
nmap("<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, "Format Code")

local cmp = require('cmp')

cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
})

local treesitter_languages = { "python", "ocaml", "rust", "bash" }
local treesitter_filetypes = { "python", "ocaml", "rust", "sh", "bash" }

vim.treesitter.language.register("bash", { "sh", "bash" })

local has_treesitter_configs, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if has_treesitter_configs then
  treesitter_configs.setup({
    ensure_installed = treesitter_languages,
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  })
else
  pcall(require("nvim-treesitter").setup)
end

vim.api.nvim_create_user_command("TSInstallCore", function()
  vim.cmd("TSInstall " .. table.concat(treesitter_languages, " "))
end, { desc = "Install configured Tree-sitter parsers" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitter_filetypes,
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if not vim.list_contains(treesitter_languages, lang) then
      return
    end

    pcall(vim.treesitter.start, args.buf, lang)
  end,
})

pcall(vim.cmd, "packadd nvim-treesitter-textobjects")

local has_textobjects, textobjects = pcall(require, "nvim-treesitter-textobjects")
if has_textobjects then
  textobjects.setup({
    select = {
      lookahead = true,
    },
    move = {
      set_jumps = true,
    },
  })

  local ts_select = require("nvim-treesitter-textobjects.select")

  vim.keymap.set({ "x", "o" }, "af", function()
    ts_select.select_textobject("@function.outer", "textobjects")
  end, { desc = "Select outer function" })
  vim.keymap.set({ "x", "o" }, "if", function()
    ts_select.select_textobject("@function.inner", "textobjects")
  end, { desc = "Select inner function" })
  vim.keymap.set({ "x", "o" }, "ap", function()
    ts_select.select_textobject("@parameter.outer", "textobjects")
  end, { desc = "Select outer parameter" })
  vim.keymap.set({ "x", "o" }, "ip", function()
    ts_select.select_textobject("@parameter.inner", "textobjects")
  end, { desc = "Select inner parameter" })
  vim.keymap.set({ "x", "o" }, "ab", function()
    ts_select.select_textobject("@block.outer", "textobjects")
  end, { desc = "Select outer block" })
  vim.keymap.set({ "x", "o" }, "ib", function()
    ts_select.select_textobject("@block.inner", "textobjects")
  end, { desc = "Select inner block" })
  vim.keymap.set({ "x", "o" }, "al", function()
    ts_select.select_textobject("@loop.outer", "textobjects")
  end, { desc = "Select outer loop" })
  vim.keymap.set({ "x", "o" }, "il", function()
    ts_select.select_textobject("@loop.inner", "textobjects")
  end, { desc = "Select inner loop" })
  vim.keymap.set({ "x", "o" }, "ac", function()
    ts_select.select_textobject("@class.outer", "textobjects")
  end, { desc = "Select outer class" })
  vim.keymap.set({ "x", "o" }, "ic", function()
    ts_select.select_textobject("@class.inner", "textobjects")
  end, { desc = "Select inner class" })

  local ts_move = require("nvim-treesitter-textobjects.move")

  vim.keymap.set({ "n", "x", "o" }, "]f", function()
    ts_move.goto_next_start("@function.outer", "textobjects")
  end, { desc = "Next function start" })
  vim.keymap.set({ "n", "x", "o" }, "]c", function()
    ts_move.goto_next_start("@class.outer", "textobjects")
  end, { desc = "Next class start" })
  vim.keymap.set({ "n", "x", "o" }, "]z", function()
    ts_move.goto_next_start("@fold", "folds")
  end, { desc = "Next fold" })
  vim.keymap.set({ "n", "x", "o" }, "[f", function()
    ts_move.goto_previous_start("@function.outer", "textobjects")
  end, { desc = "Previous function start" })
  vim.keymap.set({ "n", "x", "o" }, "[c", function()
    ts_move.goto_previous_start("@class.outer", "textobjects")
  end, { desc = "Previous class start" })
  vim.keymap.set({ "n", "x", "o" }, "[z", function()
    ts_move.goto_previous_start("@fold", "folds")
  end, { desc = "Previous fold" })
end
