local M = {}

local commands = require("request.commands")
local ui = require("request.ui")

-- M.setup = function(opts)
--   print("Options:", opts)
-- end

vim.api.nvim_create_user_command("Request", ui.open_ui, {})

M.get = commands.get
M.post = commands.post
M.delete = commands.delete
M.put = commands.put
M.patch = commands.patch

return M
