local M = {}

local layout = require("request.ui.layout")
local params = require("request.ui.params")
local auth = require("request.ui.auth")
local state = require("request.ui.state")
local remaps = require("request.remaps")

M.buffer = nil
M.win = nil

local input_fields = {
	url = { row = 5, start_col = 0 },
}

M.update_request_window = function()
	state.URL = vim.api.nvim_buf_get_lines(M.buffer, 4, -1, false)

	if M.buffer and vim.api.nvim_buf_is_valid(M.buffer) then
		local lines = {
			"Perform request [CR] Reset [X]",
			"Request Method: " .. state.request_method .. " [M]",
			"Authentication: " .. state.auth_method .. "[A]",
			"URL [U]:",
		}
		if #state.URL > 0 then
			vim.list_extend(lines, state.URL)
		else
			table.insert(lines, "")
		end
		vim.api.nvim_buf_set_lines(M.buffer, 0, -1, false, lines)
	end
end

M.open_request_window = function()
	local dimensions = layout.get_request_window_dims()

	if not (M.buffer and vim.api.nvim_buf_is_valid(M.buffer)) then
		M.buffer = vim.api.nvim_create_buf(false, true)
		vim.bo[M.buffer].bufhidden = "hide"

		remaps.set_ui_keymaps(M.buffer, input_fields)

		M.update_request_window()
	end

	M.win = vim.api.nvim_open_win(M.buffer, true, {
		relative = "editor",
		width = dimensions.width,
		height = dimensions.height,
		row = dimensions.row,
		col = dimensions.col,
		border = "single",
		title = "request.nvim [Q]it [H]ide",
	})

	vim.wo[M.win].number = false
	vim.wo[M.win].relativenumber = false
	vim.wo[M.win].signcolumn = "no"
	vim.wo[M.win].fillchars = "eob: "
end

M.toggle_request_method = function()
	if state.request_method == "GET" then
		state.request_method = "POST"
	elseif state.request_method == "POST" then
		state.request_method = "PUT"
	elseif state.request_method == "PUT" then
		state.request_method = "PATCH"
	elseif state.request_method == "PATCH" then
		state.request_method = "DELETE"
	elseif state.request_method == "DELETE" then
		state.request_method = "GET"
	else
		state.request_method = "GET"
	end

	M.update_request_window()

	if params.should_open() then
		params.open_params_window()
	else
		params.hide_params_window()
	end
end

M.toggle_auth_method = function()
	if state.auth_method == "" then
		state.auth_method = "Basic Auth "
		auth.set_basic_auth()
	elseif state.auth_method == "Basic Auth " then
		state.auth_method = "Bearer "
		auth.set_bearer_auth()
	elseif state.auth_method == "Bearer " then
		state.auth_method = ""
	else
		state.auth_method = ""
	end

	M.update_request_window()

	if state.auth_method == "" then
		auth.close_auth_window()
	end
end

M.activate_url_insert = function(row, start_col)
	if M.win and vim.api.nvim_win_is_valid(M.win) then
		vim.api.nvim_set_current_win(M.win)
		vim.api.nvim_win_set_cursor(M.win, { row, start_col })
		vim.cmd("startinsert")
	end
end

return M
