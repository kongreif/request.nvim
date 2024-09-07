local M = {}

local remaps = require('request.remaps')
local commands = require('request.commands')

M.toggle_request_method = function()
  if M.request_method == "GET" then
    M.request_method = "POST"
  else
    M.request_method = "GET"
  end

  vim.api.nvim_buf_set_lines(M.buffer, 1, 2, false, {"Request Method: " .. M.request_method .. " [M]"})
end

M.activate_url_insert = function(buffer, row, start_col)
  vim.api.nvim_win_set_cursor(0, { row, start_col })
  vim.cmd("startinsert")
end

M.handle_get_request = function()
  local url_lines = vim.api.nvim_buf_get_lines(M.buffer, 3, 4, false)
  local url = url_lines[1]

  local result = commands.get(url)

  local lines = {}
  for line in result:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  vim.api.nvim_buf_set_lines(M.buffer, 6, -1, false, lines)
end

M.reset = function()
  vim.api.nvim_buf_set_lines(M.buffer, 3, 4, false, {""})
  vim.api.nvim_buf_set_lines(M.buffer, 6, -1, false, {""})
end

M.open_request_view = function()
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local window_width = math.floor(width * 0.8)
  local window_height = math.floor(height * 0.8)
  local window_left_edge_row = math.floor((height - window_height) / 2)
  local window_top_edge_col = math.floor((width - window_width) / 2)

  M.buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(M.buffer, 'bufhidden', 'wipe')

  local window = vim.api.nvim_open_win(M.buffer, true, {
    relative = 'editor',
    width = window_width,
    height = window_height,
    row = window_left_edge_row,
    col = window_top_edge_col,
    border = 'single',
    title = 'request.nvim [Q]',
  })

  vim.api.nvim_win_set_option(window, 'number', false)
  vim.api.nvim_win_set_option(window, 'relativenumber', false)
  vim.api.nvim_win_set_option(window, 'signcolumn', 'no')
  vim.api.nvim_win_set_option(window, 'fillchars', 'eob: ')

  local input_fields = {
    url = { row = 4, start_col = 0 },
  }

  M.request_method = "GET"
  vim.api.nvim_buf_set_lines(M.buffer, 0, -1, false, { "Perform request [CR] Reset [X]"})
  vim.api.nvim_buf_set_lines(M.buffer, 1, -1, false, { "Request Method: " .. M.request_method .. " [M]" })
  vim.api.nvim_buf_set_lines(M.buffer, 2, -1, false, { "URL [U]:" })
  vim.api.nvim_buf_set_lines(M.buffer, 3, -1, false, { "" })
  vim.api.nvim_buf_set_lines(M.buffer, 4, -1, false, { "" })
  vim.api.nvim_buf_set_lines(M.buffer, 5, -1, false, { "Response:" })

  remaps.set_keymaps(M.buffer, input_fields)
end

return M
