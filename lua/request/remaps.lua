local M = {}

M.set_ui_keymaps = function(buffer, input_fields)
	-- toggle request method
	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"M",
		':lua require("request.ui").toggle_request_method()<CR>',
		{ noremap = true, silent = true }
	)

	-- quit plugin
	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"Q",
		':lua require("request.ui").quit()<CR>',
		{ noremap = true, silent = true }
	)

	-- hide plugin
	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"H",
		':lua require("request.ui").hide()<CR>',
		{ noremap = true, silent = true }
	)

	-- activeate URL insert
	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"U",
		string.format(
			":lua require('request.ui').activate_url_insert(%s, %s)<CR>",
			input_fields.url.row,
			input_fields.url.start_col
		),
		{ noremap = true, silent = true }
	)

	-- perform request
	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"<CR>",
		':lua require("request.request_handling").perform_request()<CR>',
		{ noremap = true, silent = true }
	)

	-- reset
	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"X",
		':lua require("request.ui").reset()<CR>',
		{ noremap = true, silent = true }
	)

	-- activate params insert
	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"P",
		':lua require("request.ui").activate_params_insert()<CR>',
		{ noremap = true, silent = true }
	)

	-- toggle auth method
	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"A",
		':lua require("request.ui").toggle_auth_method()<CR>',
		{ noremap = true, silent = true }
	)
end

return M
