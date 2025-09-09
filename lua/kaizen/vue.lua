local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

local vue_ls_config = {
  cmd = { 'node', vue_language_server_path, '--stdio' },
}

local ts_ls_config = {
  root_dir = require('lspconfig.util').root_pattern('.git'),
  init_options = {
    plugins = { vue_plugin },
  },
  filetypes = {
    'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue'
  },
}

vim.lsp.config('ts_ls', ts_ls_config)
vim.lsp.config('vue_ls', vue_ls_config)
vim.lsp.enable({'ts_ls', 'vue_ls'})

return {
  ts_ls = ts_ls_config,
}


