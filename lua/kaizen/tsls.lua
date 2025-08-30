local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local tsserver_path = vim.fn.stdpath('data') .. "/mason/packages/typescript-language-server/node_modules/typescript-language-server/lib/cli.mjs"
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
  enableForWorkspaceTypeScriptVersions = true,
}

local ts_ls_config = {
  cmd = { 'node', '--max-old-space-size=2048', tsserver_path, '--stdio' },
  root_dir = require('lspconfig.util').root_pattern('.git'),
  init_options = {
    maxTsServerMemory = 2048, -- 2GB
    plugins = {
      vue_plugin,
    },
  },
  filetypes = tsserver_filetypes,
}

-- If you are on most recent `nvim-lspconfig`
local vue_ls_config = {
  cmd = { 'node', '--max-old-space-size=2048', vue_language_server_path, '--stdio' },
}

-- nvim 0.11 or above
vim.lsp.config('ts_ls', ts_ls_config)
vim.lsp.config('vue_ls', vue_ls_config)
vim.lsp.enable({'ts_ls', 'vue_ls'}) -- If using `ts_ls` replace `vtsls` to `ts_ls`

return {
  ts_ls_config = ts_ls_config,
  vue_ls_config = vue_ls_config,
}

