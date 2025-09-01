local util = require 'lspconfig.util'

local root_file = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
}

return {
  default_config = {
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'vue',
      'svelte',
      'astro',
    },
    -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
    root_dir = function(fname)
      root_file = util.insert_package_json(root_file, 'eslintConfig', fname)
      return util.root_pattern(unpack(root_file))(fname)
    end,
    flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 1000,
    },
    settings = {
      useESLintClass = true,
      codeActionOnSave = {
        enable = false,
        mode = "all",
      },
      quiet = false,
      onIgnoredFiles = "off",
      rulesCustomizations = {},
      run = "onSave",
      codeAction = {
        disableRuleComment = { enable = true, location = "separateLine" },
        showDocumentation = { enable = true },
      },
      packageManager = "bun",
    }
  }
}
