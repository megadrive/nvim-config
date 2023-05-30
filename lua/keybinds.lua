local M = {}

local set = vim.keymap.set
local wk = require("which-key")

M.setup = function()
  set("i", "jk", "<C-c>"); -- jk to leave insert mode

  wk.register({
    p = {
      name = "Project",
      v = { "<cmd>Ex<CR>", "Open NetRW" },
    },

    f = {
      name = "Telescope",
      f = { "<cmd>Telescope find_files<CR>", "Fuzzy-find all files" },
      F = { "<cmd>Telescope git_files<CR>", "Fuzzy-find git files" },
      b = { "<cmd>Telescope buffers<CR>", "Fuzzy-find buffer" },
      B = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy-find in current buffer" },
      d = { "<cmd>Telescope diagnostics<CR>", "Fuzzy-find diagnostics" },
    },

    d = {
      name = "Diagnostics",
      f = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Diagnostic forward" },
      b = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Diagnostic backward" },
    },

    F = { "<cmd>LspZeroFormat<CR>", "LSP Format" },

    h = {
      name = "Harpoon",
      a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add file to marks" },
      l = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "List marks" },
      n = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "Next mark" },
      p = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "Previous mark" },
      c = {
        name = "Clear all marks (confirm)",
        c = { "<cmd>lua require('harpoon.mark').clear_all()<cr>", "Clear all marks" },
      },
      f = { "<cmd>Telescope harpoon marks<cr>", "Find marks" },
    },

    w = {
      "<C-w>", "Window",
    },
  }, { prefix = '<leader>' })

  wk.register({
    K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover" },
    g = {
      name = "Goto",
      d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
      t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition" },
      i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
    }
  })
end

return M
