local ui = {}

ui.layout = require("request.ui.layout")
ui.request = require("request.ui.request")
ui.response = require("request.ui.response")
ui.params = require("request.ui.params")
ui.auth = require("request.ui.auth")
ui.state = require("request.ui.state")

function ui.open_ui()
	ui.request.open_request_window()
	ui.response.open_response_window()
	if ui.params.should_open() then
		ui.params.open_params_window()
	end
	if ui.auth.should_open() then
		ui.auth.open_auth_window()
	end
	vim.api.nvim_set_current_win(ui.request.win)
	vim.api.nvim_win_set_cursor(ui.request.win, { 1, 0 })
end

ui.hide = function()
	vim.api.nvim_win_hide(ui.request.win)
	vim.api.nvim_win_hide(ui.response.win)
	if ui.params.win then
		vim.api.nvim_win_hide(ui.params.win)
	end
	if ui.auth.win then
		vim.api.nvim_win_hide(ui.auth.win)
	end
end

ui.quit = function()
	if ui.request.win and vim.api.nvim_win_is_valid(ui.request.win) then
		vim.api.nvim_win_close(ui.request.win, true)
	end
	if ui.response.win and vim.api.nvim_win_is_valid(ui.response.win) then
		vim.api.nvim_win_close(ui.response.win, true)
	end
	if ui.params.win and vim.api.nvim_win_is_valid(ui.params.win) then
		vim.api.nvim_win_close(ui.params.win, true)
	end
	if ui.auth.win and vim.api.nvim_win_is_valid(ui.auth.win) then
		vim.api.nvim_win_close(ui.auth.win, true)
	end

	if ui.request.buffer and vim.api.nvim_buf_is_valid(ui.request.buffer) then
		vim.api.nvim_buf_delete(ui.request.buffer, { force = true })
		ui.request.buffer = nil
	end
	if ui.response.buffer and vim.api.nvim_buf_is_valid(ui.response.buffer) then
		vim.api.nvim_buf_delete(ui.response.buffer, { force = true })
		ui.response.buffer = nil
	end
	if ui.params.buffer and vim.api.nvim_buf_is_valid(ui.params.buffer) then
		vim.api.nvim_buf_delete(ui.params.buffer, { force = true })
		ui.params.buffer = nil
	end
	if ui.auth.buffer and vim.api.nvim_buf_is_valid(ui.auth.buffer) then
		vim.api.nvim_buf_delete(ui.auth.buffer, { force = true })
		ui.auth.buffer = nil
	end

	ui.request_method = "GET"
	ui.auth_method = ""
end

ui.reset = function()
	ui.state.request_method = "GET"
	ui.state.auth_method = ""
	if ui.params.buffer and vim.api.nvim_buf_is_valid(ui.params.buffer) then
		vim.api.nvim_buf_delete(ui.params.buffer, { force = true })
		ui.params.buffer = nil
	end
	if ui.auth.buffer and vim.api.nvim_buf_is_valid(ui.auth.buffer) then
		vim.api.nvim_buf_delete(ui.auth.buffer, { force = true })
		ui.auth.buffer = nil
	end

	ui.request.update_request_window()

	if ui.request.win and vim.api.nvim_win_is_valid(ui.request.win) then
		vim.api.nvim_set_current_win(ui.request.win)
	end
end

return ui
