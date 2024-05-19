;; Lualine configuration
(fn custom-tabs []
  (accumulate [display-string ""
			      nr id (ipairs (vim.api.nvim_list_tabpages))]
    (if (= nr (vim.fn.tabpagenr))
	(.. display-string " ● ")
	(.. display_string " ○ "))))

(fn setup []
  (let [lualine (require :lualine)]
    (lualine.setup {:options {:theme :catppuccin :icons_enabled false}
		   :sections {:lualine_b {} :lualine_x [:filetype]}
		   :tabline {:lualine_a [(fn [] (vim.fn.fnamemodify (vim.fn.getcwd) ":t"))]
		   :lualine_b [:branch]
		   :lualine_z [{1 custom-tabs
				  :color "lualine_transitional_lualine_a_normal_to_lualine_c_normal"
				  :separator {:left "" :right ""}}]}
		   :extensions [:toggleterm]})))

{: setup}
