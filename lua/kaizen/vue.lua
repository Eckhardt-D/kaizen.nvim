local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
-- local tsserver_path = "/home/kaizen/.bun/install/global/node_modules/typescript-language-server/lib/cli.mjs"
-- local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

--local ts_ls_config = {
--  cmd = { 'node', tsserver_path, '--stdio' },
--  root_dir = require('lspconfig.util').root_pattern('.git'),
--  init_options = {
--    plugins = { vue_plugin },
--  },
--  filetypes = tsserver_filetypes,
--}

local vue_ls_config = {
  cmd = { 'node', vue_language_server_path, '--stdio' },
}

vim.lsp.config('vtsls', {
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
})

return {
  -- ts_ls_config = ts_ls_config,
  vue_ls_config = vue_ls_config,
}


