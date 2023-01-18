
local M = {}

M.setup = function()
  local set = vim.keymap.set

  set("n", "<leader>pv", vim.cmd.Ex)
  set("n", "<leader>ff", "<cmd>Telescope find_files<CR>");
end

return M
