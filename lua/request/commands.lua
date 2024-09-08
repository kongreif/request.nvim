local M = {}

M.get = function(url)
	local command = "curl -s " .. url
	return M._handle_response(command)
end

M.post = function(url, params)
	local curl_params = ""

	if type(params) == "string" then
		curl_params = params
	elseif type(params) == "table" then
		local param_pairs = {}
		for key, value in pairs(params) do
			table.insert(param_pairs, string.format('"%s": "%s"', key, tostring(value)))
		end
		curl_params = "{" .. table.concat(param_pairs, ", ") .. "}"
	else
		error("Invalid params: expected a table or a JSON string")
	end

	local command = "curl -s -X POST -H 'Content-Type: application/json' --data '" .. curl_params .. "' " .. url

	return M._handle_response(command)
end

M.delete = function(url)
	local command = "curl -s -X DELETE " .. url
	return M._handle_response(command)
end

M._handle_response = function(command)
	local handle = io.popen(command)
	if handle == nil then
		error("Nil response for command: " .. command)
	end
	local result = handle:read("*a")
	handle:close()

	return result
end

return M
