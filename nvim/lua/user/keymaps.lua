vim.g.mapleader = " "
vim.g.maplocalleader = " "

local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc, noremap = true })
end

vim.keymap.set({ "n", "x" }, "j", "gj", { desc = "Down screen line", noremap = true })
vim.keymap.set({ "n", "x" }, "k", "gk", { desc = "Up screen line", noremap = true })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

nmap("K", vim.lsp.buf.hover, "Hover Documentation")
nmap("gd", vim.lsp.buf.definition, "Go to Definition")
nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
nmap("gi", vim.lsp.buf.implementation, "Go to Implementation")
nmap("gr", vim.lsp.buf.references, "Find References")
nmap("gt", vim.lsp.buf.type_definition, "Go to Type Definition")
nmap("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
nmap("<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, "Format Code")
