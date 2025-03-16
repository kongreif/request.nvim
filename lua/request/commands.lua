local M = {}

M._build_command = function(method, url, data, auth)
	local cmd_parts = { "curl -s" }

	if method ~= "GET" then
		table.insert(cmd_parts, "-X " .. method)
	end

	if data then
		table.insert(cmd_parts, "-H 'Content-Type: application/json'")
		table.insert(cmd_parts, "--data '" .. data .. "'")
	end

	if auth and auth ~= "" then
		if method == "GET" then
			table.insert(cmd_parts, "--oauth2-bearer " .. auth)
		else
			table.insert(cmd_parts, auth)
		end
	end

	table.insert(cmd_parts, url)

	return table.concat(cmd_parts, " ")
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

M._handle_params = function(params)
	if type(params) == "string" then
		return params
	elseif type(params) == "table" then
		local param_pairs = {}
		for key, value in pairs(params) do
			table.insert(param_pairs, string.format('"%s": "%s"', key, tostring(value)))
		end
		return "{" .. table.concat(param_pairs, ", ") .. "}"
	else
		error("Invalid params: expected a table or a JSON string")
	end
end

M.get = function(url, auth)
	local command = M._build_command("GET", url, nil, auth)
	return M._handle_response(command)
end

M.post = function(url, params, auth)
	local curl_params = M._handle_params(params)
	local command = M._build_command("POST", url, curl_params, auth)
	return M._handle_response(command)
end

M.put = function(url, params, auth)
	local curl_params = M._handle_params(params)
	local command = M._build_command("PUT", url, curl_params, auth)
	return M._handle_response(command)
end

M.patch = function(url, params, auth)
	local curl_params = M._handle_params(params)
	local command = M._build_command("PATCH", url, curl_params, auth)
	return M._handle_response(command)
end

M.delete = function(url, auth)
	local command = M._build_command("DELETE", url, nil, auth)
	return M._handle_response(command)
end

return M
