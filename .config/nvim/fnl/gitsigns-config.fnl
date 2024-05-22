(local gs (require :gitsigns))
(local util (require :util))
(local map util.map)

(lambda on_attach [bufnr]
  (let [buf-map (lambda [mode lhs rhs]
		  (map mode lhs rhs {:buffer bufnr}))]
    ;; Actions
    (buf-map :n "]c" (fn []
		   (if vim.wo.diff
		       (vim.cmd.normal {1 "]c" :bang true})
		       (gs.nav_hunk :next))))
    (buf-map :n "[c" (fn []
		   (if vim.wo.diff
		       (vim.cmd.normal {1 "[c" :bang true})
		       (gs.nav_hunk :prev))))

    ;; Actions
    (buf-map :n :ghs gs.stage_hunk)
    (buf-map :n :ghr gs.reset_hunk)
    (buf-map :v :ghs (fn [] (gs.stage_hunk {(vim.fn.line ".")  (vim.fn.line :v)})))
    (buf-map :v :ghr (fn [] (gs.reset_hunk {(vim.fn.line ".")  (vim.fn.line :v)})))
    (buf-map :n :ghS gs.stage_buffer)
    (buf-map :n :ghu gs.undo_stage_hunk)
    (buf-map :n :ghR gs.reset_buffer)
    (buf-map :n :ghp gs.preview_hunk)
    (buf-map :n :ghb (fn [] (gs.blame_line {:full true})))
    ; (buf-map :n :gtb gs.toggle_current_line_blame)
    (buf-map :n :ghd gs.diffthis)
    (buf-map :n :ghD (fn [] (gs.diffthis "~")))
    ; (buf-map :n :gtd gs.toggle_deleted)

    ;; Text object
    (buf-map {:o :x} :ih ":<C-U>Gitsigns select_hunk<CR>")))

(lambda setup []
  (gs.setup {: on_attach}))

{: setup}
