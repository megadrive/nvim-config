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

  -- themes
  {
    'pineapplegiant/spaceduck',
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd([[colorscheme spaceduck]])
    end,
    dependencies = {
      'sheerun/vim-polyglot'
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd([[colorscheme tokyonight-night]])
    end
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme catppuccin-mocha]])
    end
  },

  {
    'nyoom-engineering/oxocarbon.nvim',
    config = function()
      vim.opt.background = "dark"
      -- vim.cmd([[colorscheme oxocarbon]])
    end
  },

  -- lsp
  {
    'VonHeikemen/lsp-zero.nvim',
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

      -- If you want insert `(` after select function or method item
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )

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
    config = true,
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
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

