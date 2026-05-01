local has_nvim_tree, nvim_tree = pcall(require, "nvim-tree")
if not has_nvim_tree then
  return
end

nvim_tree.setup({
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
