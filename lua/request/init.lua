local M = {}

-- M.setup = function(opts)
--   print("Options:", opts)
-- end

M.get = function(url)
    local command = "curl " .. url
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

return M
