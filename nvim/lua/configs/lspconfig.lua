-- load defaults i.e lua_lsp

-- EXAMPLE
local servers = { "html", "cssls" }

-- lsps with default config

-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
