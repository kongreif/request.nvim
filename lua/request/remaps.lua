local M = {}

M.set_keymaps = function(buffer, input_fields)
  vim.api.nvim_buf_set_keymap(buffer, 'n', 'M', ':lua require("request.ui").toggle_request_method()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(buffer, 'n', 'Q', ":close<CR>", {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(buffer, 'n', 'U', string.format(":lua require('request.ui').activate_url_insert(%d, %s, %s)<CR>", buffer, input_fields.url.row, input_fields.url.start_col), {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(buffer, 'n', '<CR>', ':lua require("request.ui").handle_get_request()<CR>', {noremap = true, silent = false})
  vim.api.nvim_buf_set_keymap(buffer, 'n', 'X', ':lua require("request.ui").reset()<CR>', {noremap = true, silent = true})
end

return M
