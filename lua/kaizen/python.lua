-- Python format on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { "*.py" },
    callback = function()
      vim.lsp.buf.format { async = false }
    end,
    group = vim.api.nvim_create_augroup("MyAutoPyFormatter", {}),
})

vim.lsp.config('ruff', {
  init_options = {
    settings = {
      fixAll = true,
      configurationPreferences = "filesystemFirst",
      lint = {
        preview = true
      },
      format = {
        preview = true
      }
    }
  }
})

vim.lsp.config('basedpyright', {
  init_options = {
    settings = {
      basedpyright = {
        disableOrganizeImports = true
      },
      python = {
        analysis = {
          diagnosticMode = "workspace",
          typeCheckinMode = "off",
        },
        venPath = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV or vim.env.PYENV_ROOT,
      }
    }
  }
})

vim.lsp.enable('ruff')
vim.lsp.enable('basedpyright')
