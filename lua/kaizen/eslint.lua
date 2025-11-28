local util = require('lspconfig.util')

local eslint_config_files = {
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

local function fix_all(opts)
  opts = opts or {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  vim.validate("bufnr", bufnr, "number")

  local client = opts.client or vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })[1]
  if not client then return end

  local request

  if opts.sync then
    request = function(buf, method, params) client:request_sync(method, params, nil, buf) end
  else
    request = function(buf, method, params) client:request(method, params, nil, buf) end
  end

  request(bufnr, "workspace/executeCommand", {
    command = "eslint.applyAllFixes",
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = vim.lsp.util.buf_versions[bufnr],
      },
    }
  })
end

local eslint_config = {

  on_init = function(client)
    vim.api.nvim_create_user_command('EslintFixAll', function() fix_all({ client = client, sync = true }) end, {})
  end,
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }

    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
    print("ESLint project root: " .. project_root)

    -- We know that the buffer is using ESLint if it has a config file
    -- in its directory tree.
    --
    -- Eslint used to support package.json files as config files, but it doesn't anymore.
    -- We keep this for backward compatibility.
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local eslint_config_files_with_package_json =
      util.insert_package_json(eslint_config_files, 'eslintConfig', filename)
    local is_buffer_using_eslint = vim.fs.find(eslint_config_files_with_package_json, {
      path = filename,
      type = 'file',
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_eslint then
      return
    end

    on_dir(project_root)
  end,
  settings = {
    useFlatConfig = false,
    experimental = {
      useFlatConfig = nil,
    }
  }
}

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("EslintAutoFix", { clear = true }),
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue" },
  command = "silent! EslintFixAll",
})

vim.lsp.config('eslint', eslint_config)
vim.lsp.enable('eslint')
