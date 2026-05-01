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
