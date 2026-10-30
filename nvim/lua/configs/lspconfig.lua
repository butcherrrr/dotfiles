-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- lsps with default config (install binaries via :Mason)
local servers = { "html", "cssls", "ts_ls", "pyright", "gopls", "bashls" }
vim.lsp.enable(servers)

-- configuring single server, example: typescript
-- vim.lsp.config("ts_ls", {
--   settings = { ... },
-- })
