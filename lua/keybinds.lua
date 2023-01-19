
local M = {}

M.setup = function()
  local set = vim.keymap.set

  set("n", "<leader>q", "<cmd>bd<CR>"); -- close a buffer
  set("n", "<leader>Q", "<cmd>bd|e#<CR>"); -- close all buffers but the open one

  -- netrw
  set("n", "<leader>pv", vim.cmd.Ex)

  -- Telescope
  set("n", "<leader>ff", "<cmd>Telescope git_files<CR>");
  set("n", "<leader>fF", "<cmd>Telescope find_files<CR>");
  set("n", "<leader>fb", "<cmd>Telescope buffers<CR>");
  set("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<CR>");
end

return M
