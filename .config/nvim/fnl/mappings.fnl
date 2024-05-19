;; This module sets some default keymaps. Plugin specific keymaps should not be a part of this module
(local util (require :util))
(local map util.map)

(set vim.g.mapleader " ")

;; El Greco nav keys
(map "" :j :h)
(map "" :k :j)
(map "" :l :k)
(map [:n :v] ";" :l)
(map [:n :v] "'" :l)
(map :n :h "'")
(map :n :<C-W>j :<C-W>h)
(map :n :<C-W>k :<C-W>j)
(map :n :<C-W>l :<C-W>k)
(map :n "<C-W>'" :<C-W>l)
(map :n "<C-W>;" :<C-W>l)
(map :n "<C-W>J" :<C-W>H)
(map :n "<C-W>K" :<C-W>J)
(map :n "<C-W>L" :<C-W>K)
(map :n "<C-W>\"" :<C-W>L)
(map :n "<C-W>:" :<C-W>L)

;; Easier to reach window management
(map :n :<BS> :<C-W> {:noremap false})

;; Exit insert mode
(map :i :kl :<Esc>)

;; Standard copy to clipboard binding
;; * is a register which accesses the clipboard on most systems
(map "" :<C-C> "\"*y")

;; Always yank to r for easy pasting in insert mode
;; (map "" :y "\"ry")

;; For writing prose
(map :n :<leader>p "<cmd> lua prose()<CR>")
(lambda prose []
  (map [:n :v] :k :gj)
  (map [:n :v] :l :gk)
  (set vim.o.wrap true)
  (set vim.o.lbr true))

;; Manually resync syntax highlighting
(map :n :<leader>r ":syntax sync fromstart<CR>")

;; Remove all trailing whitespace
(map :n :<leader>s ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>")

;; Edit config
(map :n :<leader>c ":Ex ~/.config/nvim/fnl")

;; Run a shell command
(map :n :<leader>z ":! " {:silent false})

;; Open notes in the notes directory
;; CONVERT TO FENNEL
(map :n :<leader>nn "<cmd> lua notes('notes')<CR>")
(lambda notes [filename ?extension]
  (vim.fn.mkdir "notes" :p)
  (vim.cmd.e (.. "notes/" filename "." (or ?extension :md))))

;; Erase search highlighting
(map :n :<leader>h ":nohl<CR>")

;; Exit terminal mode
(map :t :dk :<C-\\><C-N>)
