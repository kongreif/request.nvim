local M = {}

M.toggle_request_method = function()
  if M.request_method == "GET" then
    M.request_method = "POST"
  else
    M.request_method = "GET"
  end

  vim.api.nvim_buf_set_lines(M.buffer, 0, 1, false, {"Request Method: " .. M.request_method .. " [M]"})
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

  M.request_method = "GET"
  vim.api.nvim_buf_set_lines(M.buffer, 0, -1, false, {
    "Request Method: " .. M.request_method .. " [M]"
  })

  vim.api.nvim_buf_set_keymap(M.buffer, 'n', 'M', ':lua require("request.ui").toggle_request_method()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(M.buffer, 'n', 'Q', ":close<CR>", {noremap = true, silent = true})
end

return M
