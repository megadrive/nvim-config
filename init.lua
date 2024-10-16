-- Note for future me: if you are getting shitloads of errors,
-- make neovim from source.
--
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
  -- {
  --   "zbirenbaum/copilot.lua",
  --   dependencies = {
  --     "zbirenbaum/copilot-cmp",
  --   },
  --   config = function()
  --     require('copilot').setup({
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --     })
  --
  --     require('copilot_cmp').setup()
  --   end,
  -- },

  -- leap.nvim, easier movements
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end,
  },

  -- themes
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = false,
    config = function()
      -- vim.cmd [[colorscheme kanagawa]]
    end,
  },

  {
    "ayu-theme/ayu-vim",
    lazy = false,
    priority = false,
    config = function()
      -- vim.cmd [[colorscheme ayu]]
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

  {
    "hardhackerlabs/theme-vim",
    name = "hardhacker",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.hardhacker_darker = 0
      vim.g.hardhacker_hide_tilde = 1
      vim.g.hardhacker_keyword_italic = 1
    end,
    config = function()
      vim.cmd("colorscheme hardhacker")
    end,
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

  -- lsp
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = "v2.x",
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
      local cmp = require("cmp")

      -- lsp.preset("recommended")
      lsp.set_preferences({
        setup_servers_on_start = true,
        configure_diagnostics = true,
        manage_nvim_cmp = true,
        call_servers = 'local',
      })

      lsp.default_keymaps()

      lsp.setup_nvim_cmp({
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp', keyword_length = 1 },
          { name = 'buffer',   keyword_length = 1 },
          { name = 'luasnip',  keyword_length = 2 },
          { name = 'copilot' },
        },
        mapping = {
          ['<Tab>'] = cmp.mapping.confirm({
            -- documentation says this is important.
            -- I don't know why.
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ['<C-j>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ['<C-k>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        }
      })

      lsp.on_attach(function(_, bufnr)
        local opts = { buffer = bufnr }
        local bind = vim.keymap.set

        bind('i', '<C-Space>', require('cmp').mapping.complete(), opts)
        bind('v', '=', '<cmd>LspZeroFormat<CR><C-C>')
        bind('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
      end)

      lsp.set_sign_icons({
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I',
      })

      lsp.setup()
    end
  },

  {
    'MunifTanjim/prettier.nvim',
    dependencies = {
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
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

  -- Devicons, used as a dependency for various plugins
  "nvim-tree/nvim-web-devicons",

  {
    -- Highlight, edit, and navigate code
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
    "ojroques/nvim-hardline",
    config = true,
  },

  -- colors and highlights
  {
    'NvChad/nvim-colorizer.lua',
    config = true,
  },

  -- minimap
  -- {
  --   'gorbit99/codewindow.nvim',
  --   config = function()
  --     local codewindow = require('codewindow')
  --     codewindow.setup({
  --       auto_enable = true,
  --       minimap_width = 4,
  --       width_multiplier = 8,
  --     })
  --     codewindow.apply_default_keybinds()
  --   end,
  -- },
  {
    'dstein64/nvim-scrollview',
    config = function()
      require("scrollview").setup()
    end,
  },

  -- Add indentation guides even on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
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
      -- local actions = require("telescope.actions")

      local telescope = require("telescope")

      telescope.setup {
        defaults = {
          mappings = {},
        },
      }
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        preset = "modern"
      })
    end
  },

  {
    "windwp/nvim-autopairs",
    config = true,
  },

  -- harpoon - marks
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("harpoon").setup()
      require("telescope").load_extension("harpoon")
    end,
  },

  -- markdown support
  {
    "OXY2DEV/markview.nvim",
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
