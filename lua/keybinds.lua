local M = {}

M.setup = function()
  local set = vim.keymap.set
  vim.keymap.set("i", "jk", "<C-c>"); -- jk to leave insert mode

  local wk = require("which-key")
  wk.register({
    q = { "<cmd>db<CR>", "Close current buffer"},
    Q = { "<cmd>db|e#<CR>", "Close all other buffers"},
    p = {
      v = { "<cmd>Ex<CR>", "Open netrw" },
    },

    f = {
      name = "Telescope",
      f = {"<cmd>Telescope find_files<CR>", "Fuzzy-find all files"},
      F = {"<cmd>Telescope git_files<CR>", "Fuzzy-find git files"},
      b = {"<cmd>Telescope buffers<CR>", "Fuzzy-find buffer"},
      F = {"<cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy-find in current buffer"},
    },

    t = {
      name = "Trouble diagnostics",
      t = {"<cmd>TroubleToggle<CR>", "Toggle Trouble"},
      r = {"<cmd>TroubleRefresh<CR>", "Refresh Trouble"},
    },

    F = { "<cmd>LspZeroFormat<CR>", "LSP Format" },
  }, { prefix = '<leader>' })

  -- Trouble
  local trouble_opts = { silent = true, noremap = true }
  set("n", "<leader>tt", "<cmd>Trouble<CR>", trouble_opts)
  set("n", "<leader>tr", "<cmd>TroubleRefresh<CR>", trouble_opts)
end

return M
