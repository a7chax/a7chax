require("core.options")
require("core.keymaps")
require("core.autocmds")
require("plugins")

if vim.fn.has("macunix") then
  require("core.mac")
end
