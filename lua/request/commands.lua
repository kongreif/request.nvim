local M = {}

local ui = require("request.ui")

local function build_auth_flag(auth)
	if not auth or auth == "" then
		return ""
	end

	if auth.type == "bearer" then
		return "Authorization: Bearer " .. auth.token
	elseif auth.type == "basic auth" then
		return auth.username .. ":" .. auth.password
	end

	error("Unsupported auth type")
end

M._build_command = function(method, url, data, auth)
	local cmd_parts = { "curl", "-s" }

	if method ~= "GET" then
		table.insert(cmd_parts, "-X")
		table.insert(cmd_parts, method)
	end

	if data then
		table.insert(cmd_parts, "-H")
		table.insert(cmd_parts, "Content-Type: application/json")
		table.insert(cmd_parts, "--data")
		table.insert(cmd_parts, data)
	end

	local auth_flag = build_auth_flag(auth)
	if auth_flag ~= "" then
		if auth.type == "bearer" then
			table.insert(cmd_parts, "-H")
			table.insert(cmd_parts, auth_flag)
		else
			table.insert(cmd_parts, "-u")
			table.insert(cmd_parts, auth_flag)
		end
	end

	table.insert(cmd_parts, url)

	return cmd_parts
end

M._handle_response = function(command, callback)
	ui.response.show_loading()
	vim.cmd("redraw")

	vim.fn.jobstart(command, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data and data[1] ~= "" then
				callback(data)
			end
		end,
		on_stderr = function(_, err)
			if err and err[1] ~= "" then
				callback(err)
			end
		end,
	})
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

M.get = function(url, auth, callback)
	local command = M._build_command("GET", url, nil, auth)
	M._handle_response(command, callback)
end

M.post = function(url, params, auth, callback)
	local curl_params = M._handle_params(params)
	local command = M._build_command("POST", url, curl_params, auth)
	M._handle_response(command, callback)
end

M.put = function(url, params, auth, callback)
	local curl_params = M._handle_params(params)
	local command = M._build_command("PUT", url, curl_params, auth)
	M._handle_response(command, callback)
end

M.patch = function(url, params, auth, callback)
	local curl_params = M._handle_params(params)
	local command = M._build_command("PATCH", url, curl_params, auth)
	M._handle_response(command, callback)
end

M.delete = function(url, auth, callback)
	local command = M._build_command("DELETE", url, nil, auth)
	M._handle_response(command, callback)
end

return M
