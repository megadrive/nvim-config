local M = {}

M.setup = function()
  local set = vim.keymap.set
  set("i", "jk", "<C-c>"); -- jk to leave insert mode

  set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
  set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })
  set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })

  local wk = require("which-key")
  wk.register({
    q = { "<cmd>db<CR>", "Close current buffer" },
    Q = { "<cmd>db|e#<CR>", "Close all other buffers" },
    p = {
      name = "Project",
      v = { "<cmd>Ex<CR>", "Open netrw" },
    },

    f = {
      name = "Telescope",
      f = { "<cmd>Telescope find_files<CR>", "Fuzzy-find all files" },
      F = { "<cmd>Telescope git_files<CR>", "Fuzzy-find git files" },
      b = { "<cmd>Telescope buffers<CR>", "Fuzzy-find buffer" },
      F = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy-find in current buffer" },
      d = { "<cmd>Telescope diagnostics<CR>", "Fuzzy-find diagnostics" },
    },

    d = {
      name = "Trouble diagnostics",
      f = { "lua vim.diagnostic.goto_next()<CR>", "Diagnostic forward" },
      b = { "lua vim.diagnostic.goto_prev()<CR>", "Diagnostic backward" },
      t = { "<cmd>TroubleToggle<CR>", "Toggle Trouble" },
      r = { "<cmd>TroubleRefresh<CR>", "Refresh Trouble" },
    },

    F = { "<cmd>LspZeroFormat<CR>", "LSP Format" },
  }, { prefix = '<leader>' })

  -- Trouble
  local trouble_opts = { silent = true, noremap = true }
  set("n", "<leader>tt", "<cmd>TroubleToggle<CR>", trouble_opts)
  set("n", "<leader>tr", "<cmd>TroubleRefresh<CR>", trouble_opts)
end

return M
