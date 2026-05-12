local has_textobjects, textobjects = pcall(require, "nvim-treesitter-textobjects")
if not has_textobjects then
  return
end

textobjects.setup({
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
})

local ts_select = require("nvim-treesitter-textobjects.select")
local ts_shared = require("nvim-treesitter-textobjects.shared")

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

vim.keymap.set({ "x", "o" }, "aC", function()
  ts_select.select_textobject("@conditional.outer", "textobjects")
end, { desc = "Select outer conditional" })
vim.keymap.set({ "x", "o" }, "iC", function()
  ts_select.select_textobject("@conditional.inner", "textobjects")
end, { desc = "Select inner conditional" })

vim.keymap.set({ "x", "o" }, "ac", function()
  if
    vim.bo.filetype == "rust"
    and ts_shared.textobject_at_point("@rust_class.outer", "textobjects", 0, nil, {})
  then
    ts_select.select_textobject("@rust_class.outer", "textobjects")
  else
    ts_select.select_textobject("@class.outer", "textobjects")
  end
end, { desc = "Select outer class" })
vim.keymap.set({ "x", "o" }, "ic", function()
  ts_select.select_textobject("@class.inner", "textobjects")
end, { desc = "Select inner class" })

vim.keymap.set({ "x", "o" }, "a=", function()
  ts_select.select_textobject("@assignment.outer", "textobjects")
end, { desc = "Select outer assignment" })
vim.keymap.set({ "x", "o" }, "i=", function()
  ts_select.select_textobject("@assignment.rhs", "textobjects")
end, { desc = "Select assignment RHS" })

-- Rust Match Expressions
vim.keymap.set({ "x", "o" }, "am", function()
  ts_select.select_textobject("@match.outer", "textobjects")
end, { desc = "Select outer match" })
vim.keymap.set({ "x", "o" }, "im", function()
  ts_select.select_textobject("@match.inner", "textobjects")
end, { desc = "Select inner match" })
vim.keymap.set({ "x", "o" }, "aa", function()
  ts_select.select_textobject("@match_arm.outer", "textobjects")
end, { desc = "Select outer match arm" })
vim.keymap.set({ "x", "o" }, "ia", function()
  ts_select.select_textobject("@match_arm.inner", "textobjects")
end, { desc = "Select inner match arm" })

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
