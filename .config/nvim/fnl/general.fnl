(set vim.g.laststatus 3)

;; Set tabs to appear 4 spaces wide
;; Does not impact vim-sleuth
(let [indent 4]
  (set vim.o.tabstop indent)
  (set vim.o.shiftwidth indent))

;; Prevent wrapping
(set vim.o.wrap false)

;; Use case insensitive search, except when using caps
(set vim.o.ignorecase true)
(set vim.o.smartcase true)

;; Instead of failing a command because of unsaved changes,
;; prompt to save
(set vim.o.confirm true)

;; Enable mouse use for all modes
(set vim.o.mouse :a)

;; Set command window height to 2 lines
(set vim.o.cmdheight 2)

;; Display line numbers
(set vim.o.number true)
(vim.api.nvim_create_autocmd :TermOpen {:callback (fn [] (set vim.o.number false))})

;; Prevent resizing when closing splits
;; (set vim.o.equalalways false)

;; Give more time on key sequences
(set vim.o.timeout false)
(set vim.o.ttimeoutlen 200)

;; Save tab info between sessions
;; (set vim.o.sessionoptions (.. vim.o.sessionoptions ",globals"))

;; Prevent vim from messing with EOF newlines
(set vim.o.fixendofline false)

;; Highlight cursor line
(set vim.o.cursorline true)
(vim.api.nvim_create_autocmd :WinLeave {:callback (fn [] (set vim.o.cursorline false))})
(vim.api.nvim_create_autocmd :WinEnter {:callback (fn [] (set vim.o.cursorline true))})

;; WHITESPACE
;; Show whitespace markings initially
(set vim.o.list true)
(set vim.o.listchars "trail:~,tab:| ,extends:>")

;; Don't show whitespace in insert mode
(vim.api.nvim_create_autocmd :InsertLeave {:callback (fn [] (set vim.o.list true))})
(vim.api.nvim_create_autocmd :InsertEnter {:callback (fn [] (set vim.o.list false))})
