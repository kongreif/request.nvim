local M = {}

-- Returns dimensions and position for the request window.
function M.get_request_window_dims()
	local width = vim.o.columns
	local height = vim.o.lines

	local window_height = math.floor(height * 0.38)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor((height - (height * 0.8)) / 2)
	local window_top_edge_col = math.floor((width - (width * 0.8)) / 2)

	return {
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
	}
end

-- Returns dimensions and position for the response window.
function M.get_response_window_dims()
	local width = vim.o.columns
	local height = vim.o.lines

	local window_height = math.floor(height * 0.4)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor(height / 2)
	local window_top_edge_col = math.floor((width - (width * 0.8)) / 2)

	return {
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
	}
end

-- Returns dimensions and position for the parameters window.
function M.get_params_window_dims()
	local width = vim.o.columns
	local height = vim.o.lines

	local window_height = math.floor(height * 0.38)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor((height - (height * 0.8)) / 2)
	local window_top_edge_col = math.floor(width / 2)

	return {
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
	}
end

-- Returns dimensions and position for the authentication window.
function M.get_auth_window_dims()
	local width = vim.o.columns
	local height = vim.o.lines

	local window_height = math.floor(height * 0.4)
	local window_width = math.floor(width * 0.4)
	local window_left_edge_row = math.floor(height / 2)
	local window_top_edge_col = math.floor(width / 2)

	return {
		width = window_width,
		height = window_height,
		row = window_left_edge_row,
		col = window_top_edge_col,
	}
end

return M
