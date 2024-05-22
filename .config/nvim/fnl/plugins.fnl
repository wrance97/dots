(local util (require :util))
(local map util.map)

(local plugins-to-install
       [;; Display plugins
	{1 :nvim-lualine/lualine.nvim
	:dependencies [:nvim-tree/nvim-web-devicons]
	:config (fn []
		  (let [lualine-config (require :lualine_config)]
		    (lualine-config.setup)))}
	:folke/zen-mode.nvim
	:folke/twilight.nvim
	{1 :folke/todo-comments.nvim
	:dependencies [:numToStr/Comment.nvim]
	:config (fn []
		  (let [comments (require :todo-comments)] (comments.setup))
		  (map :n :gcT "OTODO: <Esc>gcc==A" {:noremap false})
		  (map :n :gct "oTODO: <Esc>gcc==A" {:noremap false}))}
	{1 :folke/lsp-colors.nvim :config true}
	:stevearc/dressing.nvim
	{1 :j-hui/fidget.nvim
	:opts {:notification {:override_vim_notify true}}}

	;; Colorschemes
	{1 :catppuccin/nvim
	:priority 1000
	:config (fn []
		  (set vim.o.termguicolors true)
		  (set vim.o.background :dark)
		  (vim.cmd.colorscheme :catppuccin))}

	;; Functionality plugins
	{1 :neovim/nvim-lspconfig
	:dependencies [:hrsh7th/cmp-nvim-lsp]
	:config (fn []
		  (let [servers [:fennel_ls :pyright]]
		    (each [_ server-name (ipairs servers)]
		      (let [lsp (. (require :lspconfig) server-name)
				cmp-nvim-lsp (require :cmp_nvim_lsp)]
			(lsp.setup {:on_attach util.on-attach :capabilities cmp-nvim-lsp.default_capabilities})))))}
	{1 :nvim-treesitter/nvim-treesitter
	:config (fn []
		  (let [configs (require :nvim-treesitter.configs)]
		    (configs.setup {:highlight {:enable true}}))
		  ;; Establish fold level based on treesitter
		  (set vim.o.foldmethod :expr)
		  (vim.cmd "set foldexpr=nvim_treesitter#foldexpr()")
		  (set vim.o.foldlevelstart 99))}
	{1 :nvimtools/none-ls.nvim
	:dependencies [:nvimtools/none-ls-extras.nvim]
	:config (fn []
		  (let [null-ls (require :null-ls)]
		    (null-ls.setup {:source [null-ls.builtins.formatting.stylua
					      null-ls.builtins.completion.spell
					      (require :none-ls.diagnostics.eslint)]
				   :on_attach util.on-attach})))}
	{1 :nvim-telescope/telescope.nvim
	:config (fn []
		  (let [actions (require :telescope.actions)
				telescope (require :telescope)]
		    (telescope.setup {:defaults {:file_ignore_patters [:node_modules/*]
				     :mappings {:i {:<Esc> actions.close}}}}))
		  (map :n :<leader>/ ":Telescope live_grep<CR>")
		  (map :n :<leader>* ":Telescope grep_string<CR>")
		  (map :n :<leader><Space> ":Telescope find_files<CR>"))}
	{1 :lewis6991/gitsigns.nvim
	:config (fn []
		  (let [gitsigns-config (require :gitsigns-config)]
		    (gitsigns-config.setup)))}
	{1 :kylechui/nvim-surround :event :VeryLazy :config true}
	:tpope/vim-sleuth
	:tpope/vim-repeat
	;; tpope/vim-obsession
	:tpope/vim-eunuch
	:tpope/vim-vinegar
	{1 :ggandor/leap.nvim
	:config (fn []
		  (let [leap (require :leap)] (leap.set_default_keymaps)))}
	{1 :numToStr/Comment.nvim :config true :lazy false}
	;; Language specific plugins
	:ap/vim-css-color
	;; :pangloss/vim-javascript

	;; Completion plugins
	{1 :windwp/nvim-autopairs :config true}
	:hrsh7th/cmp-nvim-lsp
	:hrsh7th/cmp-buffer
	:hrsh7th/cmp-path
	:hrsh7th/cmp-cmdline
	{1 :hrsh7th/nvim-cmp
	:dependencies [:L3MON4D3/LuaSnip :windwp/nvim-autopairs]
	:config (fn []
		  (let [cmp-config (require :cmp-config)]
		    (cmp-config.setup)))}
	{1 :L3MON4D3/LuaSnip
	:build "make install_jsregexp"
	:config (fn []
		  (let [loaders (require :luasnip.loaders.from_vscode)]
		    (loaders.lazy_load)))}
	{1 :saadparwaiz1/cmp_luasnip
	:dependencies [:rafamadriz/friendly-snippets]}

	;; Utility plugins
	:rktjmp/hotpot.nvim
	:nvim-lua/popup.nvim
	:nvim-lua/plenary.nvim])

(fn setup []
  (let [lazy (require :lazy)]
    (lazy.setup plugins-to-install)))

{: setup}
