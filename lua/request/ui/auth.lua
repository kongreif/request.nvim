local M = {}

local layout = require("request.ui.layout")
local state = require("request.ui.state")
local remaps = require("request.remaps")

M.buffer = nil
M.win = nil

local input_fields = {
	url = { row = 5, start_col = 0 },
}

M.open_auth_window = function()
	local dimensions = layout.get_auth_window_dims()

	if not (M.buffer and vim.api.nvim_buf_is_valid(M.buffer)) then
		M.buffer = vim.api.nvim_create_buf(false, true)

		vim.bo[M.buffer].bufhidden = "wipe"
		vim.bo[M.buffer].filetype = "json"

		remaps.set_ui_keymaps(M.buffer, input_fields)
	end

	vim.api.nvim_buf_set_lines(M.buffer, 0, -1, false, { "" })

	M.win = vim.api.nvim_open_win(M.buffer, true, {
		relative = "editor",
		width = dimensions.width,
		height = dimensions.height,
		row = dimensions.row,
		col = dimensions.col,
		border = "single",
		title = "Auth [F]",
	})

	vim.wo[M.win].number = false
	vim.wo[M.win].relativenumber = false
	vim.wo[M.win].signcolumn = "no"
	vim.wo[M.win].fillchars = "eob: "
end

M.should_open = function()
	return vim.tbl_contains(state.param_methods, state.request_method)
end

M.set_basic_auth = function()
	if not (M.win and vim.api.nvim_win_is_valid(M.win)) or not (M.buffer and vim.api.nvim_buf_is_valid(M.buffer)) then
		M.open_auth_window()
	end

	vim.api.nvim_buf_set_lines(M.buffer, 0, 2, false, { "Username: ''", "Password: ''" })
end

M.set_bearer_auth = function()
	if not (M.win and vim.api.nvim_win_is_valid(M.win)) or not (M.buffer and vim.api.nvim_buf_is_valid(M.buffer)) then
		M.open_auth_window()
	end

	vim.api.nvim_buf_set_lines(M.buffer, 0, 2, false, { "", "" })
end

M.close_auth_window = function()
	if M.win then
		vim.api.nvim_win_close(M.win, false)
		M.win = nil
	end
end

M.focus_auth = function()
	if M.win and vim.api.nvim_win_is_valid(M.win) then
		vim.api.nvim_set_current_win(M.win)
		vim.api.nvim_win_set_cursor(M.win, { 1, 0 })
	end
end

return M
