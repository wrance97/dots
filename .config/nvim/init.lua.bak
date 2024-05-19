-------------------------------------------------------------
-- LUA
-------------------------------------------------------------
-- Aliases
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- a table to access options

-- Helper functions
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------------------------------------------------
-- PLUGINS
-------------------------------------------------------------

-- Packer
-------------------------------------------------------------
-- If bootstrap fails, install by running the following command, then run :PackerSync
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim\
--     "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/packer/start/packer.nvim

-- Bootstrap
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

cmd([[packadd packer.nvim]])

require("packer").startup(function()
	use("wbthomason/packer.nvim")

	-- Display plugins
	use({ "hoob3rt/lualine.nvim" })
	-- use("norcalli/nvim-base16.lua")
	use("folke/zen-mode.nvim")
	use("folke/twilight.nvim")
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	})
	use("folke/lsp-colors.nvim")
	use({
		"projekt0n/circles.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})
	use({
		"catppuccin/nvim",
		as = "catppuccin"
	})
	use({"rcarriga/nvim-notify"})

	-- Functionality plugins
	use("neovim/nvim-lspconfig")
	use("nvim-treesitter/nvim-treesitter")
	use("jose-elias-alvarez/null-ls.nvim")
	use("nvim-telescope/telescope.nvim")
	use("lewis6991/gitsigns.nvim")
	use {
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			vim.g["neo_tree_remove_legacy_commands"] = 1
		end
	}
	use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })
	use("tpope/vim-sleuth")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("tpope/vim-obsession")
	use("tpope/vim-eunuch")
	-- use 'tpope/vim-fugitive'
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("folke/which-key.nvim")
	use("ggandor/leap.nvim")
	use("nvim-neorg/neorg")
	use("akinsho/toggleterm.nvim")
	use({"TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim"})

	-- Language specific plugins
	use("rafcamlet/nvim-luapad")
	use("ap/vim-css-color")
	use("pangloss/vim-javascript")
	use("mxw/vim-jsx")
	use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install", cmd = "MarkdownPreview" })
	-- use 'leafgarland/typescript-vim'

	-- Completion plugins
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")
	use("windwp/nvim-autopairs")

	-- Utility plugins
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use("tweekmonster/startuptime.vim")

	-- Autosync after bootstrap
	if packer_bootstrap then
		require("packer").sync()
	end
end)

-- Plugin configuration
-------------------------------------------------------------

-- Treesitter
-- Need to run :TSInstall to set up each language
local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.norg_meta = {
	install_info = {
		url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
		files = { "src/parser.c" },
		branch = "main",
	},
}
parser_configs.norg_table = {
	install_info = {
		url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
		files = { "src/parser.c" },
		branch = "main",
	},
}
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	ensure_installed = { "norg", "norg_meta", "norg_table", "markdown" },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	}
})

-- Telescope
-- Need to install ripgrep separately
local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		file_ignore_patterns = { "node_modules/*", "ios/*" },
		mappings = {
			i = {
				["<Esc>"] = actions.close,
			},
		},
	},
})

-- Cmp
require("nvim-autopairs").setup({})

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

opt.completeopt = { "menu", "menuone", "noselect" }

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").load()
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		-- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		-- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		-- ['<C-e>'] = cmp.mapping({
		--   i = cmp.mapping.abort(),
		--   c = cmp.mapping.close(),
		-- }),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Gitsigns
require("gitsigns").setup({
	signs = {
		add = { hl = "DiffAdded", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "DiffLine", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "DiffRemoved", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "DiffRemoved", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "DiffLine", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
	numhl = false,
	keymaps = {
		-- Default keymap options
		noremap = true,
		buffer = true,
		["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
		["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
		["n ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
		["n ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
		["n ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
		["n ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
		["n ghb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
	},
	watch_gitdir = {
		interval = 100,
	},
	sign_priority = 5,
	status_formatter = nil, -- Use default
})

-- Markdown Preview
g["mkdp_auto_close"] = 0

-- Zen Mode
require("zen-mode").setup({
	window = {
		options = {
			number = false,
			relativenumber = false,
		},
	},
})

require("neorg").setup({
	-- Tell Neorg what modules to load
	load = {
		["core.defaults"] = {}, -- Load all the default modules
		-- ["core.norg.concealer"] = {}, -- Allows for use of icons
		-- ["core.norg.dirman"] = { -- Manage your directories with Neorg
		-- config = {
		--   workspaces = {
		--     my_workspace = "~/neorg"
		--   }
		-- }
	},
})

-- Peekaboo
-- g['peekaboo_delay'] = 1000

require("todo-comments").setup({})
require("lsp-colors").setup({})
require("trouble").setup({
	action_keys = {
		next = "k",
		previous = "l",
	},
})

require("circles").setup({
	icons = {
		empty = "○",
		filled = "●",
		lsp_prefix = "⎈",
	},
})

require("toggleterm").setup({
	open_mapping = [[<space>t]],
	terminal_mappings = false,
	insert_mappings = false,
	direction = "horizontal",
})

require("neogit").setup({})

require("Comment").setup({
	---@param ctx Ctx
	pre_hook = function(ctx)
		-- Only calculate commentstring for tsx filetypes
		if vim.bo.filetype == 'typescriptreact' then
			local U = require('Comment.utils')

			-- Determine whether to use linewise or blockwise commentstring
			local type = ctx.ctype == U.ctype.line and '__default' or '__multiline'

			-- Determine the location where to calculate commentstring from
			local location = nil
			if ctx.ctype == U.ctype.block then
				location = require('ts_context_commentstring.utils').get_cursor_location()
			elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				location = require('ts_context_commentstring.utils').get_visual_start_location()
			end

			return require('ts_context_commentstring.internal').calculate_commentstring({
				key = type,
				location = location,
			})
		end
	end,
})

require("which-key").setup({
	plugins = {
		operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
		motions = false, -- adds help for motions
		text_objects = false, -- help for text objects triggered after entering an operator
		windows = false, -- default bindings on <c-w>
		nav = false, -- misc bindings to work with windows
		z = false, -- bindings for folds, spelling and others prefixed with z
		g = false, -- bindings for prefixed with g
	}
})

vim.notify = require("notify")

-- Statusline & colors
-------------------------------------------------------------
-- Lualine
local function custom_tabs()
	local display_string = ""
	for nr, id in ipairs(vim.api.nvim_list_tabpages()) do
		if nr == vim.fn.tabpagenr() then
			display_string = display_string .. " ● "
		else
			display_string = display_string .. " ○ "
		end
	end
	return display_string
end
require("lualine").setup({
	options = {
		theme = "catppuccin",
		icons_enabled = false,
		-- section_separators = '',
		-- component_separators = ''
	},
	sections = {
		lualine_x = { "filetype" },
	},
	tabline = {
		lualine_a = { function()
			return fn.fnamemodify(fn.getcwd(), ":t")
		end },
		lualine_b = { "branch" },
		lualine_z = { {custom_tabs, color = "lualine_transitional_lualine_a_normal_to_lualine_c_normal"} },
	},
	extensions = { "toggleterm"}
})

-- Base16
-- Base16 Shell must be installed outside of vim
-- It can be found here: https://github.com/chriskempson/base16-shell
-- local base16 = require("base16")
-- base16(base16.themes["atelier-cave"], true)

-- Use GUI colors instead of (very limited) TUI colors
opt.termguicolors = true

-- Manual color changes
vim.api.nvim_create_autocmd({ "ColorScheme"}, {
	callback = function()
		vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" })
	end
})

cmd("colorscheme catppuccin")

-------------------------------------------------------------
-- CUSTOM FUNCTIONS
-------------------------------------------------------------

-- For writing prose
function prose()
	-- Maps for moving within lines
	map("n", "k", "gj")
	map("n", "l", "gk")
	map("v", "k", "gj")
	map("v", "l", "gk")
	-- cmd ':ZenMode'
	opt.wrap = true
	opt.lbr = true
end

-------------------------------------------------------------
-- MAPPINGS
-------------------------------------------------------------

-- Map <leader> for all future mappings
g["mapleader"] = " "

-- El Greco bindings
map("", "j", "h")
map("", "k", "j")
map("", "l", "k")
map("", ";", "l")
map("n", "'", "l")
map("v", "'", "l")
map("n", "<C-W>j", "<C-W>h")
map("n", "<C-W>k", "<C-W>j")
map("n", "<C-W>l", "<C-W>k")
map("n", "<C-W>'", "<C-W>l")
map("n", "<C-W>;", "<C-W>l")
map("n", "<C-W>J", "<C-W>H")
map("n", "<C-W>K", "<C-W>J")
map("n", "<C-W>L", "<C-W>K")
map("n", '<C-W>"', "<C-W>L")
-- map('n', 'h', '<C-W>')

-- Easier to reach window management
map("n", "<BS>", "<C-W>", { noremap = false })
map("n", "<Left>", "<C-W>h")
map("n", "<Down>", "<C-W>j")
map("n", "<Up>", "<C-W>k")
map("n", "<Right>", "<C-W>l")
map("n", "<End>", "<C-W>v")
map("n", "<Home>", "<C-W>s")

-- Exit insert mode
map("i", "kl", "<Esc>")

-- Standard copy to clipboard binding
-- * is a register which accesses the clipboard on most systems
map("", "<C-C>", '"*y')

-- Always yank to r for easy putting in insert mode
map("n", "y", '"ry')
map("v", "y", '"ry')

-- Open terminal
-- map("n", "<leader>tt", ":tabe<CR>:term<CR>:TabooRename term<CR>i")
-- map("n", "<leader>ti", ":term<CR>i")
-- map("n", "<leader>tj", ":vsplit<CR>:term<CR>i")
-- map("n", "<leader>t'", ":vsplit<CR><C-W>l:term<CR>i")
-- map("n", "<leader>t;", ":vsplit<CR><C-W>l:term<CR>i")
-- map("n", "<leader>tl", ":split<CR>:term<CR>i")
-- map("n", "<leader>tk", ":split<CR><C-W>j:term<CR>i")

-- For writing prose
map("n", "<leader>p", "<cmd> lua prose()<CR>")

-- Manually resync syntax highlighting
map("n", "<leader>r", ":syntax sync fromstart<CR>")

-- Remove all trailing whitespace
map("n", "<leader>w", ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>")

-- Edit config
map("n", "<leader>c", ":e ~/.config/nvim/init.lua<CR>")

-- Run a shell command
map("n", "<leader>z", ":! ", { silent = false })

-- Open notes.norg in the project root directory
map("n", "<leader>n", ":e notes.norg<CR>")

-- Erase search highlighting
map("n", "<leader>h", ":nohl<CR>")

-- Write
map("n", "<leader>s", ":w<CR>")

-- Write and quit
map("n", "<leader>q", ":wq<CR>")

-- Plugin dependent
-------------------------------------------------------------
-- Search using Telescope
map("n", "<leader>/", ":Telescope live_grep<CR>")
map("n", "<leader>*", ":Telescope grep_string<CR>")
map("n", "<leader><Space>", ":Telescope find_files<CR>")

-- Make a todo comment (vim-commentary)
map("n", "gcT", "OTODO: <Esc>gccA", { noremap = false })
map("n", "gct", "oTODO: <Esc>gccA", { noremap = false })

-- Open Neotree
map("n", "-", ":Neotree<CR>")

-------------------------------------------------------------
-- TERMINAL SPECIFICS
-------------------------------------------------------------

-- set shell=zsh
opt.shell = "zsh"

-- Exit terminal mode
map("t", "dk", "<C-\\><C-N>")

-------------------------------------------------------------
-- LANGUAGE SPECIFICS
-------------------------------------------------------------

-- Javascript
-------------------------------------------------------------
-- Append ; at end of line
map("n", "<leader>;", "A;<Esc>")

-- console.log mappings
map("i", "cll", "console.log('');<Esc>hhi")
map("n", "<leader>L", "\"ayiwOconsole.log('<C-R>a:', <C-R>a);<Esc>")
map("x", "<leader>L", "\"ayOconsole.log('<C-R>a:', <C-R>a);<Esc>")
map("n", "<leader>l", "\"ayiwoconsole.log('<C-R>a:', <C-R>a);<Esc>")
map("x", "<leader>l", "\"ayoconsole.log('<C-R>a:', <C-R>a);<Esc>")

-- Change js filetype to jsx (React)
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.js",
	callback = function() opt.filetype = "typescriptreact" end,
})

-- Format JSON
map("n", "<Leader>j", ":%!python -m json.tool<CR>:set filetype=json<CR>", { silent = false })

-- Open Neorg files in prose mode
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.norg",
	callback = prose,
})

-------------------------------------------------------------
-- MISC
-------------------------------------------------------------

-- Set tabs to appear 4 spaces wide
-- Does not impact vim-sleuth
local indent = 4
opt.tabstop = indent
opt.shiftwidth = indent

-- Prevent wrapping
opt.wrap = false

-- Use case insensitive search, except when using caps
opt.ignorecase = true
opt.smartcase = true

-- Stop certain movements from always going to first
-- character of the line
opt.startofline = false

-- Instead of failing a command because of unsaved changes,
-- prompt to save
opt.confirm = true

-- Enable use of mouse for all modes
opt.mouse = "a"

-- Set command window height to 2 lines
opt.cmdheight = 2

-- Display line numbers on left
-- Still trying to figure out how to hide in terminal
opt.number = true
opt.relativenumber = true
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FocusGained" }, {
	callback = function()
		buf_type = vim.api.nvim_buf_get_option(0, "buftype")
		if (buf_type ~= "terminal" and buf_type ~= "help") then
			opt.number = true
			opt.relativenumber = true
		end
	end
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
	callback = function() opt.relativenumber = false end
})
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
	callback = function()
		opt.relativenumber = false
		opt.number = false
	end
})

-- Prevent resizing when closing splits
opt.equalalways = false

-- Give more time on key sequences
opt.timeout = false
opt.ttimeoutlen = 200

-- Save tab info between sessions
opt.sessionoptions:append({ "globals" })

-- Folding
-------------------------------------------------------------
-- Establish folds based on indentation
-- opt.foldmethod = 'indent'

-- Start with folds open
-- cmd 'autocmd BufWinEnter * let &foldlevel = max(map(range(1, line(\'$\')), \'foldlevel(v:val)\'))'

-- List Chars
-------------------------------------------------------------
--  Show list chars initially
opt.list = true
opt.listchars = {
	trail = "~",
	tab = "| ",
	extends = ">",
}

-- Don't show list chars in insert mode
cmd("autocmd InsertLeave * set list")
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function() opt.list = true end
})
cmd("autocmd InsertEnter * set nolist")
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function() opt.list = false end
})

-------------------------------------------------------------
-- LSP
-------------------------------------------------------------
-- Need to globally install a language server for each language
-- and list the language server at the bottom of this block

local nvim_lsp = require("lspconfig")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
-- map('n', '<leader>dp', '<cmd>lua vim.diagnostic.open_float()<CR>')
-- map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
-- map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
-- map('n', '<leader>dq', '<cmd>lua vim.diagnostic.setloclist()<CR>')
-- map('n', '<leader>df', '<cmd>lua vim.lsp.buf.format { async = true}<CR>')

-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--   -- Enable completion triggered by <c-x><c-o>
--   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

--   -- Mappings.
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--   -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>da', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
-- end

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
	vim.cmd("command! LspFormatting lua vim.lsp.buf.format { async = true}")
	vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
	vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
	vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
	vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
	vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
	vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
	vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
	vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
	vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
	vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

	local buf_map = vim.api.nvim_buf_set_keymap
	buf_map(bufnr, "n", "gd", ":LspDef<CR>", opts)
	-- buf_map(bufnr, "n", "gr", ":LspRename<CR>")
	-- buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>")
	buf_map(bufnr, "n", "K", ":LspHover<CR>", opts)
	buf_map(bufnr, "n", "[d", ":LspDiagPrev<CR>", opts)
	buf_map(bufnr, "n", "]d", ":LspDiagNext<CR>", opts)
	buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>", opts)
	-- buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>")
	-- buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")
	if client.server_capabilities.document_formatting then
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
	end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "elmls", "pyright" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

nvim_lsp.tsserver.setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
	init_options = {
		hostInfo = "neovim",
		preferences = {
			importModuleSpecifierPreference = "non-relative",
		},
	},
})

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.formatting.prettier,
	},
	on_attach = on_attach,
})
