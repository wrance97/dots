" -----------------------------------------------------------
" PLUGINS
" -----------------------------------------------------------

" Plugin variables
" -----------------------------------------------------------
" fzf
" fzf must be installed outside of vim
" It can be found here: https://github.com/junegunn/fzf
set rtp+=/usr/local/opt/fzf
let g:fzf_layout = { 'down': '~20%' }

" Ack
" Ag must be installed outside of vim before Ack can be used
" It can be found here: https://github.com/ggreer/the_silver_searcher
let g:ackprg = 'ag --vimgrep'

" Taboo
let g:taboo_modified_tab_flag = " +"
let g:taboo_renamed_tab_format = " %l%m "

" Goyo/Limelight combo
" autocmd! User GoyoEnter Limelight0.8 
" autocmd! User GoyoLeave Limelight! 

" Prevent default git gutter mappings
let g:gitgutter_map_keys = 0

" Base16
" Base16 Shell must be installed outside of vim
" It can be found here: https://github.com/chriskempson/base16-shell
let base16colorspace = 256

" Vim-plug
" -----------------------------------------------------------
" Install vim-plug by running the following command, then run :PlugInstall
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

filetype off
call plug#begin('~/.config/vim-plug')

" Display plugins
Plug 'itchyny/lightline.vim'
Plug 'gcmt/taboo.vim'
Plug 'chriskempson/base16-vim'
Plug 'mike-hearn/base16-vim-lightline'

" Functionality plugins
Plug 'neoclide/coc.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-fugitive'

" THE LEGEND
Plug 'junegunn/vim-slash'
Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
" Plug 'junegunn/vim-journal'
" Plug 'junegunn/vim-peekaboo'

" Language specific plugins
Plug 'ap/vim-css-color'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
" Plug 'leafgarland/typescript-vim'
" Plug 'posva/vim-vue'

" Good to keep around
" Plug 'tpope/vim-sensible'

call plug#end()
filetype plugin indent on

" Statusline & colors
" -----------------------------------------------------------
" Coc function for lightline
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

" Lightline configuration
" This must be set before the the vim colorscheme
" Note that base16 lightline colorschemes use snake_case
let g:lightline = {
    \   'colorscheme': 'base16_tomorrow_night',
    \   'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ],
    \     'right': [ [ 'lineinfo' ],
    \                [ 'percent' ],
    \                [ 'filetype' ] ]
    \   },
    \   'component_function': {
    \     'cocstatus': 'coc#status',
    \     'currentfunction': 'CocCurrentFunction'
    \   },
    \ }

" Set the vim colorscheme
" Note that base16 vim colorschemes use kebab-case
colorscheme base16-default-dark

" -----------------------------------------------------------
" MAPPINGS
" -----------------------------------------------------------

" Map <leader> for all future mappings
:let mapleader = ","

" Exit insert mode
inoremap jk <Esc>

" Map Y to yank to EOL instead of full line
map Y y$

" Standard copy to clipboard binding
" * is a register which accesses the clipboard on most systems
vnoremap <C-C> "*y

" For writing prose
nnoremap <silent> <leader>p :call ProseMode()<CR>

" Manually resync syntax highlighting
nnoremap <silent> <leader>s :syntax sync fromstart<CR>

" Remove all trailing whitespace
nnoremap  <leader>w :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Edit config
nnoremap <silent> <leader>c :e ~/.config/nvim/init.vim<CR>

" Window management
" -----------------------------------------------------------
" Easier to reach
nnoremap [ <C-W>

" Delete buffer without losing window
nnoremap [d :bp\|bd #<CR>

" Toggle buffers
" nnoremap [[ <C-^>

" Plugin dependent
" -----------------------------------------------------------
" Search using Ack
nnoremap <leader>a :Ack!<Space>

" Open fzf
nnoremap <silent> <leader>f :FZF<CR>

" Make a todo comment (vim-commentary)
nmap gct OTODO: <Esc>gccA

" Git gutter navigation
nmap <silent> ghn :call GitGutterNextHunkCycle()<CR>
nmap ghN <Plug>(GitGutterPrevHunk)
nmap ghs <Plug>(GitGutterStageHunk)
xmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
xmap ghu <Plug>(GitGutterUndoHunk)
nmap ghe <Plug>(GitGutterPreviewHunk)
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" -----------------------------------------------------------
" TERMINAL SPECIFICS
" -----------------------------------------------------------

set shell=zsh

" Exit terminal mode
tnoremap dk <C-\><C-N>

" -----------------------------------------------------------
" LANGUAGE SPECIFICS
" -----------------------------------------------------------

" Javascript
" -----------------------------------------------------------
" Append ; at end of line
" nnoremap <leader>; A;<Esc>

" console.log mappings for normal and visual mode
" nnoremap <Leader>L "ayiwOconsole.log('<C-R>a:', <C-R>a);<Esc>
" xnoremap <Leader>L "ayOconsole.log('<C-R>a:', <C-R>a);<Esc>
" nnoremap <Leader>l "ayiwoconsole.log('<C-R>a:', <C-R>a);<Esc>
" xnoremap <Leader>l "ayoconsole.log('<C-R>a:', <C-R>a);<Esc>

" Change js filetype to jsx (React)
" autocmd BufNewFile,BufRead *.js set ft=javascript.jsx

" -----------------------------------------------------------
" MISC
" -----------------------------------------------------------

" Allows using multiple files in the same window without 
" splits or tabs by allowing one to hide a buffer without
" saving it first.
set hidden
" Alternatives include
" set autowriteall

" Show partial commands in the last line of the screen
set showcmd

" Use case insensitive search, except when using caps
set ignorecase
set smartcase

" When opening a new line without filetype-specific
" indentation, keep the same indent as the line you're
" currently on
set autoindent

" Stop certain movements from always going to first
" character of the line
set nostartofline

" Display the cursor position in the status line
set ruler

" Highlight the 101st char of lines
" highlight ColorColumn guibg=#303030
" call matchadd('ColorColumn', '\%101v', 100)

" Always display the status line, even with one window
set laststatus=2

" Instead of failing a command because of unsaved changes,
" prompt to save
set confirm

" Enable use of mouse for all modes
set mouse=a

" Set command window height to 2 lines to prevent excessive
" scrolling
set cmdheight=2

" Display line numbers on left
set number relativenumber

" Display only absolute line numbers when window is not focused
" (still buggy with nvim terminal)
" augroup numbertoggle
"     autocmd!
"     autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"     autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
" augroup END

" Quickly timeout on keycodes, but never on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" Folding
" -----------------------------------------------------------
" Establish folds based on indentation
set foldmethod=indent

" Start with folds open
autocmd BufWinEnter * let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))

" -----------------------------------------------------------
" CUSTOM FUNCTIONS
" -----------------------------------------------------------

" For writing prose
function! ProseMode()
  " Maps for moving within lines
  nnoremap j gj
  nnoremap k gk
  vnoremap j gj
  vnoremap k gk
  Goyo
  set lbr
endfunction

" Makes git gutter cycle back to top hunk
function! GitGutterNextHunkCycle()
  let line = line('.')
  silent! GitGutterNextHunk
  if line('.') == line
    1
    GitGutterNextHunk
  endif
endfunction

" -----------------------------------------------------------
" COC
" -----------------------------------------------------------

" Configuration in place of coc-setting.json
let g:coc_user_config = {
      \  'diagnostic.enable': v:true,
      \  'python.jediEnabled': v:false
      \ }

" Speed up for diagnostic messages
set updatetime=300

" Some servers have issues with backup files
set nobackup
set nowritebackup

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>rf  <Plug>(coc-format-selected)
nmap <leader>rf  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
