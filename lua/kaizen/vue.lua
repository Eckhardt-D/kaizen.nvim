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

local vtsls_config = {
  root_dir = require('lspconfig.util').root_pattern('.git'),
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = {
    'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue'
  },
}

vim.lsp.config['vtsls'] = vtsls_config
vim.lsp.enable('vtsls')

return {
  vtsls_config = vtsls_config,
  vue_ls_config = vue_ls_config,
}


