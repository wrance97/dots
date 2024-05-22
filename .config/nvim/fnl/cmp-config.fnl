(local cmp (require :cmp))
(local luasnip (require :luasnip))
(local cmp_autopairs (require :nvim-autopairs.completion.cmp))

(local mapping {
       :<CR> (cmp.mapping (fn [fallback]
        (if (cmp.visible)
            (if (luasnip.expandable)
		(luasnip.expand)
                (cmp.confirm {:select true}))
            (fallback))))
    :<Tab> (cmp.mapping (fn [fallback]
      (if (cmp.visible)
	  (cmp.select_next_item)
	  (luasnip.locally_jumpable 1)
	  (luasnip.jump 1)
	  (fallback)))
    [:i :s])
    :<S-Tab> (cmp.mapping (fn [fallback]
      (if (cmp.visible)
	  (cmp.select_prev_item)
	  (luasnip.locally_jumpable -1)
	  (luasnip.jump -1)
	  (fallback)))
    [:i :s])})

(lambda setup []
  (cmp.setup {:snippet {
      ;; REQUIRED - you must specify a snippet engine
      :expand (fn [args] (let [luasnip (require :luasnip)]
	(luasnip.lsp_expand args.body))) ;; For `luasnip` users.
      ; :expand (fn [args] (vim.snippet.expand args.body) ;; For native neovim snippets (Neovim v0.10+)),
    }
    :window {
      ;; completion = cmp.config.window.bordered(),
      ;; documentation = cmp.config.window.bordered(),
    }
    : mapping
    :sources (cmp.config.sources [{:name :nvim_lsp} {:name :luasnip}] [{:name :buffer}])
  })
  (cmp.setup.cmdline ["/" "?"] {
    :mapping (cmp.mapping.preset.cmdline)
    :sources [{:name :buffer}]
  })
  (cmp.setup.cmdline ":" {
    :mapping (cmp.mapping.preset.cmdline)
    :sources (cmp.config.sources [{:name :path}] [{:name :cmdline}])
    :matching {:disallow_symbol_nonprefix_matching false}
  })
  (cmp.event:on :confirm_done (cmp_autopairs.on_confirm_done {:map_char {:tex ""}}))
  (set vim.opt.completeopt "menu,menuone,noselect"))

{: setup}
