local M = {}

local commands = require("request.commands")
local ui = require("request.ui")

local param_request_methods = { "POST", "PUT", "PATCH" }

local parse_auth = function(auth_str)
	local auth_info = {}

	auth_str = auth_str:gsub("^%s+", ""):gsub("%s+$", "")

	if auth_str:find("Username:") and auth_str:find("Password:") then
		local username = auth_str:match("Username:%s*['\"](.-)['\"]")
		local password = auth_str:match("Password:%s*['\"](.-)['\"]")

		if username and password then
			auth_info.type = "basic auth"
			auth_info.username = username
			auth_info.password = password
			return auth_info
		else
			error("Invalid basic auth format. Expected format:\nUsername: '<username>'\nPassword: '<password>'")
		end
	end

	auth_info.type = "bearer"
	auth_info.token = auth_str
	return auth_info
end

local get_auth = function()
	if ui.auth.buffer and vim.api.nvim_buf_is_valid(ui.auth.buffer) then
		local auth_lines = vim.api.nvim_buf_get_lines(ui.auth.buffer, 0, -1, false)
		local auth_str = table.concat(auth_lines, "\n")
		return parse_auth(auth_str)
	else
		return {}
	end
end

local is_param_request_method = function(request_method)
	for _, value in ipairs(param_request_methods) do
		if value == request_method then
			return true
		end
	end
	return false
end

local get_url = function()
	local url_lines = vim.api.nvim_buf_get_lines(ui.request.buffer, 4, -1, false)
	return url_lines[1]
end

local get_param_string = function()
	local params_lines = vim.api.nvim_buf_get_lines(ui.params.buffer, 0, -1, false)
	return table.concat(params_lines, "\n")
end

M.perform_request = function()
	local url = get_url()
	if url == "" or url == nil then
		error("URL is empty. Please enter a valid URL before making a request.")
	end
	local params = ""
	local auth = {}

	if is_param_request_method(ui.state.request_method) then
		params = get_param_string()
	end

	auth = get_auth()

	local callback = function(lines)
		vim.api.nvim_buf_set_lines(ui.response.buffer, 0, -1, false, lines)
	end

	if ui.state.request_method == "GET" then
		commands.get(url, auth, callback)
	elseif ui.state.request_method == "POST" then
		commands.post(url, params, auth, callback)
	elseif ui.state.request_method == "PUT" then
		commands.put(url, params, auth, callback)
	elseif ui.state.request_method == "PATCH" then
		commands.patch(url, params, auth, callback)
	elseif ui.state.request_method == "DELETE" then
		commands.delete(url, auth, callback)
	else
		error("Invalid request method:" .. ui.state.request_method)
	end
end

return M
