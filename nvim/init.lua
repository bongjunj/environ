local config_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
if config_dir then
  vim.opt.runtimepath:prepend(config_dir)
end

require("user.options")
require("user.keymaps")
require("user.lazy")
