local M = {}

local remaps = require("request.remaps")

local width = vim.o.columns
local height = vim.o.lines
local input_fields = {
	url = { row = 5, start_col = 0 },
}

M.request_method = "GET"
M.auth_method = ""
M.param_methods = { "POST", "PUT", "PATCH" }

M.toggle_request_method = function()
	if M.request_method == "GET" then
		M.request_method = "POST"
		M.open_params_window()
	elseif M.request_method == "POST" then
		M.request_method = "PUT"
	elseif M.request_method == "PUT" then
		M.request_method = "PATCH"
	elseif M.request_method == "PATCH" then
		M.request_method = "DELETE"
		M.hide_params_window()
	elseif M.request_method == "DELETE" then
		M.request_method = "GET"
	else
		M.request_method = "GET"
		M.hide_params_window()
	end

	vim.api.nvim_buf_set_lines(M.buffer_request, 1, 2, false, { "Request Method: " .. M.request_method .. " [M]" })
end

M.toggle_auth_method = function()
	if M.auth_method == "" then
		M.auth_method = "Basic Auth "
		M.open_auth_window()
		M.set_basic_auth()
	elseif M.auth_method == "Basic Auth " then
		M.auth_method = "Bearer "
		M.clear_auth_window()
	elseif M.auth_method == "Bearer " then
		M.auth_method = ""
		M.close_auth_window()
	else
		M.auth_method = ""
		M.close_auth_window()
	end

	vim.api.nvim_buf_set_lines(M.buffer_request, 2, 3, false, { "Auhtentication: " .. M.auth_method .. "[A]" })
end

M.activate_url_insert = function(row, start_col)
	vim.api.nvim_win_set_cursor(M.window_request, { row, start_col })
	vim.cmd("startinsert")
end

M.activate_params_insert = function()
	if M.window_params then
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
		vim.cmd("startinsert")
	end
end

M.reset = function()
	vim.api.nvim_buf_set_lines(M.buffer_request, 3, 4, false, { "" })
	vim.api.nvim_buf_set_lines(M.buffer_request, 6, -1, false, { "" })
end

M.open_params_window = function()
	local window_height = math.floor(height * 0.38)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor((height - height * 0.8) / 2)
	local window_top_edge_col = math.floor(width / 2)

	if not (M.buffer_params and vim.api.nvim_buf_is_valid(M.buffer_params)) then
		M.buffer_params = vim.api.nvim_create_buf(false, true)

		vim.bo[M.buffer_params].bufhidden = "hide"
		vim.bo[M.buffer_params].filetype = "json"

		remaps.set_ui_keymaps(M.buffer_params, input_fields)
	end

	M.window_params = vim.api.nvim_open_win(M.buffer_params, true, {
		relative = "editor",
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
		border = "single",
		title = "Params",
	})

	vim.wo[M.window_params].number = false
	vim.wo[M.window_params].relativenumber = false
	vim.wo[M.window_params].signcolumn = "no"
	vim.wo[M.window_params].fillchars = "eob: "
end

M.hide_params_window = function()
	if M.window_params then
		vim.api.nvim_win_hide(M.window_params)
	end
end

M.open_response_window = function()
	local window_height = math.floor(height * 0.4)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor(height / 2)
	local window_top_edge_col = math.floor((width - (width * 0.8)) / 2)

	if not (M.buffer_response and vim.api.nvim_buf_is_valid(M.buffer_response)) then
		M.buffer_response = vim.api.nvim_create_buf(false, true)

		vim.bo[M.buffer_response].bufhidden = "hide"
		vim.bo[M.buffer_response].filetype = "json"

		remaps.set_ui_keymaps(M.buffer_response, input_fields)
	end

	vim.api.nvim_buf_set_lines(M.buffer_response, 0, -1, false, { "" })

	M.window_response = vim.api.nvim_open_win(M.buffer_response, true, {
		relative = "editor",
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
		border = "single",
		title = "Response",
	})

	vim.wo[M.window_response].number = false
	vim.wo[M.window_response].relativenumber = false
	vim.wo[M.window_response].signcolumn = "no"
	vim.wo[M.window_response].fillchars = "eob: "
end

M.open_auth_window = function()
	local window_height = math.floor(height * 0.4)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor(height / 2)
	local window_top_edge_col = math.floor(width / 2)

	if not (M.buffer_auth and vim.api.nvim_buf_is_valid(M.buffer_auth)) then
		M.buffer_auth = vim.api.nvim_create_buf(false, true)

		vim.bo[M.buffer_auth].bufhidden = "wipe"
		vim.bo[M.buffer_auth].filetype = "json"
	end

	vim.api.nvim_buf_set_lines(M.buffer_auth, 0, -1, false, { "" })

	remaps.set_ui_keymaps(M.buffer_auth, input_fields)

	M.window_auth = vim.api.nvim_open_win(M.buffer_auth, true, {
		relative = "editor",
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
		border = "single",
		title = "Auth",
	})

	vim.wo[M.window_auth].number = false
	vim.wo[M.window_auth].relativenumber = false
	vim.wo[M.window_auth].signcolumn = "no"
	vim.wo[M.window_auth].fillchars = "eob: "
end

M.set_basic_auth = function()
	vim.api.nvim_buf_set_lines(M.buffer_auth, 0, 2, false, { "Username: ''", "Password: ''" })
end

M.clear_auth_window = function()
	vim.api.nvim_buf_set_lines(M.buffer_auth, 0, 2, false, { "", "" })
end

M.close_auth_window = function()
	if M.window_auth then
		vim.api.nvim_win_close(M.window_auth, false)
	end
end

M.open_request_window = function()
	local window_height = math.floor(height * 0.38)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor((height - height * 0.8) / 2)
	local window_top_edge_col = math.floor((width - (width * 0.8)) / 2)

	if not (M.buffer_request and vim.api.nvim_buf_is_valid(M.buffer_request)) then
		M.buffer_request = vim.api.nvim_create_buf(false, true)

		vim.bo[M.buffer_request].bufhidden = "hide"

		remaps.set_ui_keymaps(M.buffer_request, input_fields)

		vim.api.nvim_buf_set_lines(M.buffer_request, 0, -1, false, { "Perform request [CR] Reset [X]" })
		vim.api.nvim_buf_set_lines(M.buffer_request, 1, -1, false, { "Request Method: " .. M.request_method .. " [M]" })
		vim.api.nvim_buf_set_lines(M.buffer_request, 2, -1, false, { "Authentication: " .. M.auth_method .. "[A]" })
		vim.api.nvim_buf_set_lines(M.buffer_request, 3, -1, false, { "URL [U]:" })
		vim.api.nvim_buf_set_lines(M.buffer_request, 4, -1, false, { "" })
	end

	M.window_request = vim.api.nvim_open_win(M.buffer_request, true, {
		relative = "editor",
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
		border = "single",
		title = "request.nvim [Q]it [H]ide",
	})

	vim.wo[M.window_request].number = false
	vim.wo[M.window_request].relativenumber = false
	vim.wo[M.window_request].signcolumn = "no"
	vim.wo[M.window_request].fillchars = "eob: "
end

M.open_ui = function()
	M.open_response_window()
	M.open_request_window()
	if
		vim.tbl_contains(M.param_methods, M.request_method)
		and M.buffer_params
		and vim.api.nvim_buf_is_valid(M.buffer_params)
	then
		M.open_params_window()
	end
	if M.auth_method ~= "" then
		M.open_auth_window()
	end
end

M.hide = function()
	vim.api.nvim_win_hide(M.window_request)
	vim.api.nvim_win_hide(M.window_response)
	if M.window_params then
		vim.api.nvim_win_hide(M.window_params)
	end
	if M.window_auth then
		vim.api.nvim_win_hide(M.window_auth)
	end
end

M.quit = function()
	if M.window_request and vim.api.nvim_win_is_valid(M.window_request) then
		vim.api.nvim_win_close(M.window_request, true)
	end
	if M.window_response and vim.api.nvim_win_is_valid(M.window_response) then
		vim.api.nvim_win_close(M.window_response, true)
	end
	if M.window_params and vim.api.nvim_win_is_valid(M.window_params) then
		vim.api.nvim_win_close(M.window_params, true)
	end
	if M.window_auth and vim.api.nvim_win_is_valid(M.window_auth) then
		vim.api.nvim_win_close(M.window_auth, true)
	end

	if M.buffer_request and vim.api.nvim_buf_is_valid(M.buffer_request) then
		vim.api.nvim_buf_delete(M.buffer_request, { force = true })
		M.buffer_request = nil
	end
	if M.buffer_response and vim.api.nvim_buf_is_valid(M.buffer_response) then
		vim.api.nvim_buf_delete(M.buffer_response, { force = true })
		M.buffer_response = nil
	end
	if M.buffer_params and vim.api.nvim_buf_is_valid(M.buffer_params) then
		vim.api.nvim_buf_delete(M.buffer_params, { force = true })
		M.buffer_params = nil
	end
	if M.buffer_auth and vim.api.nvim_buf_is_valid(M.buffer_auth) then
		vim.api.nvim_buf_delete(M.buffer_auth, { force = true })
		M.buffer_auth = nil
	end

	M.request_method = "GET"
	M.auth_method = ""
end

return M
