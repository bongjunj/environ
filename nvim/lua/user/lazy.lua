local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local config_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("user.plugins", {
  lockfile = config_root .. "/lazy-lock.json",
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      reset = false,
    },
  },
})
