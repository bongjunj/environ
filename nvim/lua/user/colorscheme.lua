local has_github_theme, github_theme = pcall(require, "github-theme")
if not has_github_theme then
  return
end

github_theme.setup({
  options = {
    transparent = false,
    terminal_colors = true,
  },
})

vim.cmd.colorscheme("github_dark")
