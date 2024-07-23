local M = {}

local commands = require('request.commands')

-- M.setup = function(opts)
--   print("Options:", opts)
-- end

M.get = commands.get
M.post = commands.post

return M
