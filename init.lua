require("kaizen")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "horizon",
                component_separators = "|",
                section_separators = "",
            }
        }
    },
    --{
    --    "rose-pine/neovim",
    --    name = "rose-pine",
    --    config = function ()
    --        require("rose-pine").setup {
    --            variant = "moon"
    --        }
    --        vim.cmd("colorscheme rose-pine")
    --    end
    --},
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function ()
          vim.cmd("colorscheme tokyonight")
        end
    },
    {
        "folke/trouble.nvim",
        config = function ()
            require("trouble").setup {
                icons = false,
            }
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        run = function ()
            local ts_update = require("nvim-treesitter.install").update({
                with_sync = true
            })
            ts_update()
        end
    },
    "nvim-treesitter/playground",
    "theprimeagen/harpoon",
    "mbbill/undotree",
    "tpope/vim-fugitive",
    "nvim-treesitter/nvim-treesitter-context",
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "rafamadriz/friendly-snippets",
    {
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    "VonHeikemen/lsp-zero.nvim",
    "folke/zen-mode.nvim",
    "github/copilot.vim",
    "laytan/cloak.nvim",

    -- For developing in Docker containers
    {
      "amitds1997/remote-nvim.nvim",
      version = "*", -- Pin to GitHub releases
      dependencies = {
        "nvim-lua/plenary.nvim", -- For standard functions
        "MunifTanjim/nui.nvim", -- To build the plugin UI
        "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
      },
      config = true,
    },

    -- Leetcode in nvim
--    {
--      "kawre/leetcode.nvim",
--      build = ":TSUpdate html",
--      dependencies = {
--          "nvim-telescope/telescope.nvim",
--          "nvim-lua/plenary.nvim", -- required by telescope
--          "MunifTanjim/nui.nvim",
--
--          -- optional
--          "nvim-treesitter/nvim-treesitter",
--          "rcarriga/nvim-notify",
--          "nvim-tree/nvim-web-devicons",
--      },
--      opts = {
--          -- configuration goes here
--          lang = "typescript",
--      },
--    },
--
    -- git status signs on lines
    "lewis6991/gitsigns.nvim",
})

require("kaizen.plugins")

-- Eslint format on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { "*.tsx", "*.ts", "*.js", "*.jsx", "*.vue" },
    command = "silent! EslintFixAll",
    group = vim.api.nvim_create_augroup("MyAutoJSFormatter", {}),
})
