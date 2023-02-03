local M = {}

M.setup = function()
  local set = vim.keymap.set

  set("i", "jk", "<C-c>"); -- jk to leave insert mode

  set("n", "<leader>q", "<cmd>bd<CR>"); -- close a buffer
  set("n", "<leader>Q", "<cmd>bd|e#<CR>"); -- close all buffers but the open one

  -- netrw
  set("n", "<leader>pv", "<cmd>Ex<CR>");

  -- Telescope
  set("n", "<leader>fF", "<cmd>Telescope git_files<CR>");
  set("n", "<leader>ff", "<cmd>Telescope find_files<CR>");
  set("n", "<leader>fb", "<cmd>Telescope buffers<CR>");
  set("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<CR>");

  -- Trouble
  local trouble_opts = { silent = true, noremap = true }
  set("n", "<leader>tt", "<cmd>Trouble<CR>", trouble_opts)
  set("n", "<leader>tr", "<cmd>TroubleRefresh<CR>", trouble_opts)
end

return M
