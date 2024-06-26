(lambda map [mode lhs rhs ?opts]
  (let [default-opts {:noremap true :silent true}]
    (let [merged-opts (if ?opts (vim.tbl_extend :force default-opts ?opts) default-opts)]
      (vim.keymap.set mode lhs rhs merged-opts))))

(lambda on-attach [client bufnr]
  ;; Enable completion triggered by <c-x><c-o>
  (vim.api.nvim_buf_set_option bufnr :omnifunc "v:lua.vim.lsp.omnifunc")

  (vim.cmd "command! LspDef lua vim.lsp.buf.definition()")
  (vim.cmd "command! LspFormatting lua vim.lsp.buf.format { async = true}")
  (vim.cmd "command! LspCodeAction lua vim.lsp.buf.code_action()")
  (vim.cmd "command! LspHover lua vim.lsp.buf.hover()")
  (vim.cmd "command! LspRename lua vim.lsp.buf.rename()")
  (vim.cmd "command! LspRefs lua vim.lsp.buf.references()")
  (vim.cmd "command! LspTypeDef lua vim.lsp.buf.type_definition()")
  (vim.cmd "command! LspImplementation lua vim.lsp.buf.implementation()")
  (vim.cmd "command! LspDiagPrev lua vim.diagnostic.goto_prev()")
  (vim.cmd "command! LspDiagNext lua vim.diagnostic.goto_next()")
  (vim.cmd "command! LspDiagLine lua vim.diagnostic.open_float()")
  (vim.cmd "command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

  (let [opts {:buffer bufnr}]
    (map :n :gd ":LspDef<CR>" opts)
    ;; map("n", "gr", ":LspRename<CR>")
    ;; map("n", "gy", ":LspTypeDef<CR>")
    (map :n :K ":LspHover<CR>" opts)
    (map :n "[d" ":LspDiagPrev<CR>" opts)
    (map :n "]d" ":LspDiagNext<CR>" opts)
    (map :n :ga ":LspCodeAction<CR>" opts)
    ;; map("n", "<Leader>a", ":LspDiagLine<CR>")
    ;; map("i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")
    (when client.server_capabilities.document_formatting
      (vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.format()"))))

{: map
: on-attach}
