local M = {}

local remaps = require("request.remaps")
local commands = require("request.commands")

M.toggle_request_method = function()
	if M.request_method == "GET" then
		M.request_method = "POST"
		M.open_post_window()
	else
		M.request_method = "GET"
		M.hide_post_window()
	end

	vim.api.nvim_buf_set_lines(M.buffer_ui, 1, 2, false, { "Request Method: " .. M.request_method .. " [M]" })
end

M.activate_url_insert = function(row, start_col)
	vim.api.nvim_win_set_cursor(0, { row, start_col })
	vim.cmd("startinsert")
end

M.activate_post_params_insert = function()
	vim.api.nvim_win_set_cursor(0, { 1, 0 })
	vim.cmd("startinsert")
end

M.handle_request = function()
	if M.request_method == "GET" then
		M.handle_get_request()
	elseif M.request_method == "POST" then
		M.handle_post_request()
	end
end

M.handle_get_request = function()
	local url_lines = vim.api.nvim_buf_get_lines(M.buffer_ui, 3, 4, false)
	local url = url_lines[1]

	local result = commands.get(url)
	local print_result = {}

	if result == nil then
		print_result = { "There was a problem with the request" }
	elseif result == "" then
		print_result = { "The response was empty" }
	else
		for line in result:gmatch("[^\r\n]+") do
			table.insert(print_result, line)
		end
	end

	vim.api.nvim_buf_set_lines(M.buffer_ui, 6, -1, false, print_result)
end

M.handle_post_request = function()
	local url_lines = vim.api.nvim_buf_get_lines(M.buffer_ui, 3, 4, false)
	local url = url_lines[1]

	local post_params_lines = vim.api.nvim_buf_get_lines(M.buffer_post_params, 0, -1, false)
	local post_params_string = table.concat(post_params_lines, "\n")

	local result = commands.post(url, post_params_string)

	local print_result = {}

	if result == nil then
		print_result = { "There was a problem with the request" }
	elseif result == "" then
		print_result = { "The response was empty" }
	else
		for line in result:gmatch("[^\r\n]+") do
			table.insert(print_result, line)
		end
	end

	vim.api.nvim_buf_set_lines(M.buffer_ui, 6, -1, false, print_result)
end

M.reset = function()
	vim.api.nvim_buf_set_lines(M.buffer_ui, 3, 4, false, { "" })
	vim.api.nvim_buf_set_lines(M.buffer_ui, 6, -1, false, { "" })
end

M.open_post_window = function()
	local width = vim.o.columns
	local height = vim.o.lines

	local window_height = math.floor(height * 0.8)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor((height - window_height) / 2)
	local window_top_edge_col = math.floor(width / 2)

	M.buffer_post_params = vim.api.nvim_create_buf(false, true)
	vim.bo[M.buffer_post_params].bufhidden = "wipe"

	M.window_post_params = vim.api.nvim_open_win(M.buffer_post_params, true, {
		relative = "editor",
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
		border = "single",
		title = "Set post params [P]",
	})

	vim.wo[M.window_post_params].number = false
	vim.wo[M.window_post_params].relativenumber = false
	vim.wo[M.window_post_params].signcolumn = "no"
	vim.wo[M.window_post_params].fillchars = "eob: "

	vim.api.nvim_buf_set_lines(M.buffer_post_params, 0, -1, false, { "" })

	remaps.set_post_params_keymaps(M.buffer_post_params)
end

M.hide_post_window = function()
	if M.window_post_params then
		vim.api.nvim_win_close(M.window_post_params, false)
	end
end

M.open_request_view = function()
	local width = vim.o.columns
	local height = vim.o.lines

	local window_height = math.floor(height * 0.8)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor((height - window_height) / 2)
	local window_top_edge_col = math.floor((width - (width * 0.8)) / 2)

	M.buffer_ui = vim.api.nvim_create_buf(false, true)
	vim.bo[M.buffer_ui].bufhidden = "wipe"

	M.window_ui = vim.api.nvim_open_win(M.buffer_ui, true, {
		relative = "editor",
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
		border = "single",
		title = "request.nvim [Q]",
	})

	vim.wo[M.window_ui].number = false
	vim.wo[M.window_ui].relativenumber = false
	vim.wo[M.window_ui].signcolumn = "no"
	vim.wo[M.window_ui].fillchars = "eob: "

	local input_fields = {
		url = { row = 3, start_col = 0 },
	}

	M.request_method = "GET"
	vim.api.nvim_buf_set_lines(M.buffer_ui, 0, -1, false, { "Perform request [CR] Reset [X]" })
	vim.api.nvim_buf_set_lines(M.buffer_ui, 1, -1, false, { "Request Method: " .. M.request_method .. " [M]" })
	vim.api.nvim_buf_set_lines(M.buffer_ui, 2, -1, false, { "URL [U]:" })
	vim.api.nvim_buf_set_lines(M.buffer_ui, 3, -1, false, { "" })
	vim.api.nvim_buf_set_lines(M.buffer_ui, 4, -1, false, { "" })
	vim.api.nvim_buf_set_lines(M.buffer_ui, 5, -1, false, { "Response:" })

	remaps.set_ui_keymaps(M.buffer_ui, input_fields)
end

return M
