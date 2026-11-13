require 'mason'.setup {}

vim.lsp.config("ruff", {})
vim.lsp.config("ty", {})
vim.lsp.enable({"ruff", "ty",})
