local M = {}

local set = vim.keymap.set
local wk = require("which-key")

M.setup = function()
  set("i", "jk", "<C-c>"); -- jk to leave insert mode

  wk.add({
    { "<leader>F", "<cmd>LspZeroFormat<CR>", desc = "LSP Format" },
    { "<leader>d", group = "Diagnostics" },
    { "<leader>db", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Diagnostic backward" },
    { "<leader>df", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Diagnostic forward" },
    { "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Diagnostic forward" },
    { "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Diagnostic backward" },
    { "<leader>f", group = "Telescope" },
    { "<leader>fB", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy-find in current buffer" },
    { "<leader>fF", "<cmd>Telescope find_files<CR>", desc = "Fuzzy-find all files" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Fuzzy-find buffer" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Fuzzy-find diagnostics" },
    { "<leader>ff", "<cmd>Telescope git_files<CR>", desc = "Fuzzy-find git files" },
    { "<leader>h", group = "Harpoon" },
    { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add file to marks" },
    { "<leader>hc", group = "Clear all marks (confirm)" },
    { "<leader>hcc", "<cmd>lua require('harpoon.mark').clear_all()<cr>", desc = "Clear all marks" },
    { "<leader>hf", "<cmd>Telescope harpoon marks<cr>", desc = "Find marks" },
    { "<leader>hl", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "List marks" },
    { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "Next mark" },
    { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "Previous mark" },
    { "<leader>p", group = "Project" },
    { "<leader>pv", "<cmd>Ex<CR>", desc = "Open NetRW" },
    { "<leader>w", "<C-w>", desc = "Window" },
  })

  wk.add({
    {"K", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Show hover" },
    {"g", group = "Goto" },
    {"gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go to definition" },
    {"gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Go to type definition"},
    {"gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Go to implementation"},
  })
end

return M
