local M = {}

local commands = require("request.commands")
local ui = require("request.ui")

local param_request_methods = { "POST", "PUT", "PATCH" }

M.handle_request = function()
	local url = M._get_url()
	local params = ""
	local auth = ""

	if M._is_param_request_method(ui.request_method) then
		params = M._get_param_string()
	end

	auth = M._get_auth()

	local result

	if ui.request_method == "GET" then
		result = commands.get(url, auth)
	elseif ui.request_method == "POST" then
		result = commands.post(url, params)
	elseif ui.request_method == "PUT" then
		result = commands.put(url, params)
	elseif ui.request_method == "PATCH" then
		result = commands.patch(url, params)
	elseif ui.request_method == "DELETE" then
		result = commands.delete(url)
	else
		error("Invalid request method:" .. ui.request_method)
	end

	local print_result = M._format_result(result)

	vim.api.nvim_buf_set_lines(ui.buffer_response, 0, -1, false, print_result)
end

M._is_param_request_method = function(request_method)
	for _, value in ipairs(param_request_methods) do
		if value == request_method then
			return true
		end
	end
	return false
end

M._get_url = function()
	local url_lines = vim.api.nvim_buf_get_lines(ui.buffer_ui, 4, 5, false)
	return url_lines[1]
end

M._format_result = function(result)
	local formatted_result = {}
	if result == "" then
		table.insert(formatted_result, "The response was empty")
	else
		for line in result:gmatch("[^\r\n]+") do
			table.insert(formatted_result, line)
		end
	end

	return formatted_result
end

M._get_param_string = function()
	local params_lines = vim.api.nvim_buf_get_lines(ui.buffer_params, 0, -1, false)
	return table.concat(params_lines, "\n")
end

M._get_auth = function()
	local auth_lines = vim.api.nvim_buf_get_lines(ui.buffer_auth, 0, -1, false)
	return table.concat(auth_lines, "\n")
end

return M
