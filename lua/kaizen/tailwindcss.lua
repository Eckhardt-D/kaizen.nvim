local tailwindcss_config = {
  filetypes = {
    "templ",
    "vue",
    "html",
    "astro",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "react",
    "htmlangular"
  }
}

vim.lsp.config("tailwindcss", tailwindcss_config)
vim.lsp.enable("tailwindcss")
