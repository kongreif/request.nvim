local M = {}

local commands = require('request.commands')
local ui = require('request.ui')

-- M.setup = function(opts)
--   print("Options:", opts)
-- end

vim.api.nvim_create_user_command('Request', ui.open_request_view, {})

M.get = commands.get
M.post = commands.post

return M
