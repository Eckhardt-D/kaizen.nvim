-- Snippets
require("luasnip")
require("luasnip.loaders.from_vscode").load({
  paths = { "~/.config/nvim/snippets/" }
})

-- LuaLine
require("lualine").setup({
  options = {
    theme = "tokyonight",
    component_separators = "|",
    section_separators = "",
  }
})

-- Cloak
require("cloak").setup({
  enabled = true,
  cloak_character = "*",
  highlight_group = "Comment",
  patterns = {
    {
      file_pattern = ".env*",
      cloak_pattern = "=.+",
    },
  },
})

-- Vim Fugitive

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

local Kaizen_Fugitive = vim.api.nvim_create_augroup("Kaizen_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWinEnter", {
  group = Kaizen_Fugitive,
  pattern = "*",
  callback = function()
    if vim.bo.ft ~= "fugitive" then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "<leader>p", function()
      vim.cmd.Git('push')
    end, opts)

    -- rebase always
    vim.keymap.set("n", "<leader>P", function()
      vim.cmd.Git({ 'pull', '--rebase' })
    end, opts)

    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
    -- needed if i did not set the branch up correctly
    vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
  end,
})

-- Harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- LSP

local lspconfig_defaults = require('lspconfig').util.default_config;
local lspconfig = require('lspconfig');

lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- Function to jump to the next diagnostic
local function jump_to_next_diagnostic()
  local next_diagnostic = vim.diagnostic.get_next()
  if next_diagnostic then
    vim.diagnostic.jump({ diagnostic = next_diagnostic })
  else
    print("No next diagnostic found")
  end
end

-- Function to jump to the previous diagnostic
local function jump_to_prev_diagnostic()
  local prev_diagnostic = vim.diagnostic.get_prev()
  if prev_diagnostic then
    vim.diagnostic.jump({ diagnostic = prev_diagnostic })
  else
    print("No previous diagnostic found")
  end
end


autocmd("LspAttach", {
  desc = "LSP Actions",
  callback = function(event)
    local opts = { buffer = event.buf, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", jump_to_next_diagnostic, opts)
    vim.keymap.set("n", "]d", jump_to_prev_diagnostic, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  end,
})

-- Mason setup
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  automatic_installation = false
})

lspconfig.eslint.setup(require('kaizen.eslint').default_config)
lspconfig.gleam.setup({})
lspconfig.tailwindcss.setup({})
-- lspconfig.ts_ls.setup(require('kaizen.vue').ts_ls_config)
lspconfig.vue_ls.setup(require('kaizen.vue').vue_ls_config)

vim.diagnostic.config({
  virtual_text = true
})

-- Autocomplete
local cmp = require('cmp')

local cmp_select = { behavior = 'select' }
local cmp_mappings = cmp.mapping.preset.insert({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  mapping = cmp_mappings,
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})

-- Telescope

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

-- Treesitter

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "html", "vimdoc", "javascript", "typescript", "c", "lua", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- Git Signs
require("gitsigns").setup {}

-- END
