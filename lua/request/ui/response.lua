local M = {}

local layout = require("request.ui.layout")
local remaps = require("request.remaps")

M.buffer = nil
M.win = nil

local input_fields = {
	url = { row = 5, start_col = 0 },
}

M.open_response_window = function()
	local dimensions = layout.get_response_window_dims()

	if not (M.buffer and vim.api.nvim_buf_is_valid(M.buffer)) then
		M.buffer = vim.api.nvim_create_buf(false, true)

		vim.bo[M.buffer].bufhidden = "hide"
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
		title = "Response",
	})

	vim.wo[M.win].number = false
	vim.wo[M.win].relativenumber = false
	vim.wo[M.win].signcolumn = "no"
	vim.wo[M.win].fillchars = "eob: "
end

return M
