; ;; LSP related configuration
; (local util (require :util))
; (local on-attach util.on-attach)
;
; ;; Use a loop to conveniently both setup defined servers
; ;; and map buffer local keybindings when the language server attaches
; (let [servers [:fennel_ls]]
;   (each [_ server-name (ipairs servers)]
;     (let [lsp (. (require :lspconfig) server-name)]
;       (lsp.setup {:on_attach on-attach : capabilities}))))
;
; ; (nvim_lsp.tsserver.setup {
; ; 	on_attach = function(client, bufnr)
; ; 		client.server_capabilities.document_formatting = false
; ; 		client.server_capabilities.document_range_formatting = false
; ; 		on_attach(client, bufnr)
; ; 	end,
; ; 	capabilities = capabilities,
; ; 	init_options = {
; ; 		hostInfo = "neovim",
; ; 		preferences = {
; ; 			importModuleSpecifierPreference = "non-relative",
; ; 		},
; ; 	},
; ; })
