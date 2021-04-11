-------------------------------------------------------------
-- LUA
-------------------------------------------------------------

-- Aliases
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables

-- Scope function due to difficulty setting values
-- Can be deleted if this functionality is implemented:
-- https://github.com/neovim/neovim/pull/13479
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

-- Helper functions
local function opt(scope, key, value, append)
  if append then
    scopes[scope][key] = scopes[scope][key] .. value
    if scope ~= 'o' then scopes['o'][key] = scopes['o'][key] .. value end
  else
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
  end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------------------------------------------------
-- PLUGINS
-------------------------------------------------------------

-- Paq
-------------------------------------------------------------
-- Install paq by running the following command, then run :PaqInstall
-- git clone https://github.com/savq/paq-nvim.git \
--     "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim

cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself

-- Display plugins
paq 'hoob3rt/lualine.nvim'
paq 'gcmt/taboo.vim'
paq 'norcalli/nvim-base16.lua'

-- Functionality plugins
paq 'neovim/nvim-lspconfig'
paq 'nvim-treesitter/nvim-treesitter'
paq 'nvim-telescope/telescope.nvim'
paq 'hrsh7th/nvim-compe'
paq 'lewis6991/gitsigns.nvim'
paq 'tpope/vim-sleuth'
paq 'tpope/vim-surround'
paq 'tpope/vim-commentary'
paq 'tpope/vim-vinegar'
paq 'tpope/vim-repeat'
paq 'tpope/vim-obsession'
paq 'tpope/vim-eunuch'
-- paq 'tpope/vim-fugitive'
paq 'junegunn/goyo.vim'
paq 'junegunn/vim-peekaboo'
paq 'junegunn/rainbow_parentheses.vim'

-- Language specific plugins
paq 'ap/vim-css-color'
paq 'pangloss/vim-javascript'
paq 'mxw/vim-jsx'
paq {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
-- paq 'leafgarland/typescript-vim'

-- Utility plugins
paq 'nvim-lua/popup.nvim'
paq 'nvim-lua/plenary.nvim'

-- Plugin configuration
-------------------------------------------------------------
-- Taboo
g['taboo_modified_tab_flag'] = " +"
g['taboo_renamed_tab_format'] = " %l%m "

-- Treesitter
-- Need to run :TSInstall to set up each language
require'nvim-treesitter.configs'.setup {
  highlight = {enable = true}
}

-- Telescope
-- Need to install ripgrep separately
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {'node_modules/*', 'ios/*'},
    mappings = {
      i = {
        ["<Esc>"] = actions.close
      }
    }
  }
}

-- Compe
opt('o', 'completeopt', 'menuone,noselect')
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    -- spell = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- Gitsigns
require("gitsigns").setup {
    signs = {
      add          = {hl = 'DiffAdded'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = {hl = 'DiffLine', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'DiffRemoved', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'DiffRemoved', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'DiffLine', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    numhl = false,
    keymaps = {
        -- Default keymap options
        noremap = true,
        buffer = true,
        ["n ]c"] = {expr = true, '&diff ? \']c\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''},
        ["n [c"] = {expr = true, '&diff ? \'[c\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''},
        ["n ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ["n ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ["n ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ["n ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ["n ghb"] = '<cmd>lua require"gitsigns".blame_line()<CR>'
    },
    watch_index = {
        interval = 100
    },
    sign_priority = 5,
    status_formatter = nil -- Use default
}

-- Markdown Preview
g['mkdp_auto_close'] = 0

-- Peekaboo
-- g['peekaboo_delay'] = 1000

-- Statusline & colors
-------------------------------------------------------------
-- Lualine
require'lualine'.setup {
  options = {
    theme = 'onedark',
    icons_enabled = false
  },
  sections = {
    lualine_x = {'filetype'}
  }
}

-- Base16
-- Base16 Shell must be installed outside of vim
-- It can be found here: https://github.com/chriskempson/base16-shell
local base16 = require 'base16'
base16(base16.themes['onedark'], true)

-- Use GUI colors instead of (very limited) TUI colors
opt('o', 'termguicolors', true)

-- Manual color changes
cmd 'highlight! LineNr guibg=NONE'
cmd 'highlight! CursorLineNr guibg=NONE'
cmd 'highlight! SignColumn guibg=NONE'
cmd 'highlight! TabLine guibg=NONE'
cmd 'highlight! TabLineFill guibg=NONE'
cmd 'highlight! TabLineSel guibg=NONE'
cmd 'highlight! VertSplit guibg=NONE'

-------------------------------------------------------------
-- MAPPINGS
-------------------------------------------------------------

-- Map <leader> for all future mappings
g['mapleader'] = " "

-- Easier to reach window management
map('n', '<BS>', '<C-W>', {noremap = false})

-- Exit insert mode
map('i', 'jk', '<Esc>')

-- Map Y to yank to EOL instead of full line
map('', 'Y', 'y$', {noremap = false})

-- Standard copy to clipboard binding
-- * is a register which accesses the clipboard on most systems
map('', '<C-C>', '"*y')

-- Open terminal in new tab
map('n', '<leader>ot', ':tabe<CR>:term<CR>:TabooRename term<CR>i')

-- For writing prose
-- FIXME: how to call lua function from mapping
-- map('n', '<leader>p', ':call ProseMode()<CR>')

-- Manually resync syntax highlighting
map('n', '<leader>r', ':syntax sync fromstart<CR>')

-- Remove all trailing whitespace
map('n', '<leader>t', ':let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>')

-- Edit config
map('n', '<leader>c', ':e ~/.config/nvim/init.lua<CR>')

-- Run a shell command
map('n', '<leader>z', ':! ', {silent = false})

-- Open notes.md in the project root directory
map('n', '<leader>n', ':e notes.md<CR>')

-- Erase search highlighting
map('n', '<leader>h', ':nohl<CR>')

-- Plugin dependent
-------------------------------------------------------------
-- Search using Telescope
map('n', '<leader>/', ':Telescope live_grep<CR>')
map('n', '<leader>*', ':Telescope grep_string<CR>')
map('n', '<leader><Space>', ':Telescope find_files<CR>')

-- Make a todo comment (vim-commentary)
map('n', 'gcT', 'OTODO: <Esc>gccA', {noremap = false})
map('n', 'gct', 'oTODO: <Esc>gccA', {noremap = false})

-------------------------------------------------------------
-- TERMINAL SPECIFICS
-------------------------------------------------------------

-- set shell=zsh
opt('o', 'shell', 'zsh')

-- Exit terminal mode
map('t', 'dk', '<C-\\><C-N>')

-------------------------------------------------------------
-- LANGUAGE SPECIFICS
-------------------------------------------------------------

-- Javascript
-------------------------------------------------------------
-- Append ; at end of line
map('n', '<leader>;', 'A;<Esc>')

-- console.log mappings
-- map('i', 'cll', 'console.log(\'\');<Esc>hhi')
-- map('n', '<Leader>L' '"ayiwOconsole.log(\'<C-R>a:\', <C-R>a);<Esc>')
-- map('x', '<Leader>L', '"ayOconsole.log(\'<C-R>a:\', <C-R>a);<Esc>')
-- map('n', '<Leader>l' '"ayiwoconsole.log(\'<C-R>a:\', <C-R>a);<Esc>')
-- map('x', '<Leader>l' '"ayoconsole.log(\'<C-R>a:\', <C-R>a);<Esc>')

-- Change js filetype to jsx (React)
cmd 'autocmd BufNewFile,BufRead *.js set ft=javascript.jsx'

-- Format JSON
map('n', '<Leader>j', ':%!python -m json.tool<CR>', {silent = false})

-------------------------------------------------------------
-- MISC
-------------------------------------------------------------

-- Set tabs to appear 4 spaces wide
-- Does not impact vim-sleuth
local indent = 4
opt('b', 'tabstop', indent)
opt('b', 'shiftwidth', indent)

-- Prevent wrapping
opt('w', 'wrap', false)

-- Use case insensitive search, except when using caps
opt('o', 'ignorecase', true)
opt('o', 'smartcase', true)

-- Stop certain movements from always going to first
-- character of the line
opt('o', 'startofline', false)

-- Instead of failing a command because of unsaved changes,
-- prompt to save
opt('o', 'confirm', true)

-- Enable use of mouse for all modes
opt('o', 'mouse', 'a')

-- Set command window height to 2 lines
opt('o', 'cmdheight', 2)

-- Display line numbers on left
opt('w', 'number', true)
opt('w', 'relativenumber', true)

-- Prevent resizing when closing splits
opt('o', 'equalalways', false)

-- Give more time on key sequences
opt('o', 'timeout', false)
opt('o', 'ttimeoutlen', 200)

-- Save tab info between sessions
opt('o', 'sessionoptions', ',globals', true)

-- Display only absolute line numbers when window is not focused
-- (still buggy with nvim terminal)
-- augroup numbertoggle
--     autocmd!
--     autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
--     autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
-- augroup END

-- Folding
-------------------------------------------------------------
-- Establish folds based on indentation
opt('w', 'foldmethod', 'indent')

-- Start with folds open
cmd 'autocmd BufWinEnter * let &foldlevel = max(map(range(1, line(\'$\')), \'foldlevel(v:val)\'))'

-- Whitespace
-------------------------------------------------------------
--  Show whitespace markings initially
opt('w', 'list', true)
opt('o', 'listchars', '')

-- Don't show whitespace in insert mode
cmd 'autocmd InsertLeave * set list'
cmd 'autocmd InsertEnter * set nolist'

-- Trailing whitespace char
opt('o', 'listchars', 'trail:~', true)

-- Tab chars
opt('o', 'listchars', ',tab:| ', true)

-- Sidescroll char
opt('o', 'listchars', ',extends:>', true)

-------------------------------------------------------------
-- CUSTOM FUNCTIONS
-------------------------------------------------------------

-- For writing prose
local function prose()
  -- Maps for moving within lines
  map('n', 'j', 'gj')
  map('n', 'k', 'gk')
  map('v', 'j', 'gj')
  map('v', 'k', 'gk')
  cmd 'Goyo'
  opt('w', 'lbr', true)
end

-------------------------------------------------------------
-- LSP
-------------------------------------------------------------
-- Need to globally install a language server for each language
-- and list the language server at the bottom of this block

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
