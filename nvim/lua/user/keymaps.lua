vim.g.mapleader = " "
vim.g.maplocalleader = " "

local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc, noremap = true })
end

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

nmap("gd", vim.lsp.buf.definition, "Go to Definition")
nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
nmap("gr", vim.lsp.buf.references, "Find References")
nmap("<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, "Format Code")
