local M = {}

M.get = function(url)
  local command = "curl -s " .. url
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

M.post = function(url, params)
  local curl_params = ''
  if params then
    for key, value in pairs(params) do
      curl_params = curl_params .. key .. '=' .. value .. '&'
    end
  end
  local command = "curl -X POST --data \"" .. curl_params .. "\" " .. url
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

return M
