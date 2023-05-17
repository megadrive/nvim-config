-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
local plugins = {
  -- github copilot
  {
    'github/copilot.vim',
  },

  -- leap.nvim, easier movements
  {
    'ggandor/leap.nvim',
  },

  -- themes
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = false,
    config = function()
      vim.cmd[[colorscheme kanagawa]]
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd([[colorscheme tokyonight-moon]])
    end
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd([[colorscheme catppuccin]])
    end
  },

  {
    'sainnhe/sonokai',
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd([[colorscheme sonokai]])
    end
  },

  -- surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },

  --
  -- lsp
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = "v1.x",
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
      local lsp = require("lsp-zero")

      -- lsp.preset("recommended")
      lsp.set_preferences({
        suggest_lsp_servers = true,
        setup_servers_on_start = true,
        set_lsp_keymaps = true,
        configure_diagnostics = false, -- use trouble instead
        cmp_capabilities = true,
        manage_nvim_cmp = true,
        call_servers = 'local',
        sign_icons = {
          error = '✘',
          warn = '▲',
          hint = '⚑',
          info = ''
        }
      })

      lsp.setup_nvim_cmp({
        sources = {
          {name = 'path'},
          {name = 'nvim_lsp', keyword_length = 1},
          {name = 'buffer', keyword_length = 1},
          {name = 'luasnip', keyword_length = 1},
        }
      })

      lsp.on_attach(function(_, bufnr)
        local opts = { buffer = bufnr }
        local bind = vim.keymap.set

        bind('i', '<C-Space>', require('cmp').mapping.complete(), opts)
        bind('v', '=', '<cmd>LspZeroFormat<CR><C-C>')
        bind('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
      end)

      lsp.nvim_workspace()

      lsp.setup()
    end
  },

  {
    'MunifTanjim/prettier.nvim',
    dependencies = {
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function ()
      local prettier = require("prettier")
      prettier.setup({
        filetypes = {
          "css",
          "html",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "json",
          "yaml",
        },
        config_precedence = "prefer-file",
      })

      local null_ls = require("null-ls")

      local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
      local event = "BufWritePre" -- or "BufWritePost"
      local async = event == "BufWritePost"

      null_ls.setup({
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<Leader>f", function()
              vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd(event, {
              buffer = bufnr,
              group = group,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, async = async })
              end,
              desc = "[lsp] format on save",
            })
          end

          if client.supports_method("textDocument/rangeFormatting") then
            vim.keymap.set("x", "<Leader>f", function()
              vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })
          end
        end,
      })
    end
  },

  "nvim-tree/nvim-web-devicons",

  -- Diagnostics
  {
    "folke/trouble.nvim",
    dependencies = {
      { "folke/lsp-colors.nvim", config = true, },
    },
    config = true,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "tsx", "typescript", "lua", "vim" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
        additional_vim_regex_highlighting = false,
      })
    end
  },

  -- Fancier statusline
  {
    'nvim-lualine/lualine.nvim',
    config = true
  },

  {
    'NvChad/nvim-colorizer.lua',
    config = true,
  },

  {
    'gorbit99/codewindow.nvim',
    config = function()
      local codewindow = require('codewindow')
      codewindow.setup({
        auto_enable = true,
        minimap_width = 4,
        width_multiplier = 8,
      })
      codewindow.apply_default_keybinds()
    end,
  },

  -- Add indentation guides even on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
    config = true,
  },

  -- "<leader>gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    config = true,
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', lazy = false },
    config = function()
      local actions = require("telescope.actions")
      local trouble = require("trouble.providers.telescope")

      local telescope = require("telescope")

      telescope.setup {
        defaults = {
          mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
          },
        },
      }
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup()
    end
  },

  {
    "windwp/nvim-autopairs",
    config = true,
  },
}

-- vim settings
require("opts").setup()

-- lazy setup last
require("lazy").setup(plugins)

-- keybinds
require("keybinds").setup()

-- set the background, do last as colorschemes don't love it
vim.opt.background = "dark"
