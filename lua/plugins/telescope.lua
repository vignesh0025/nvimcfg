return {
	'nvim-telescope/telescope.nvim',
	tag = 'v0.2.0',
	dependencies = {
		'nvim-lua/plenary.nvim',
		"nvim-telescope/telescope-file-browser.nvim"
	},
	opts = {
		defaults = {
			mappings = {
				i = {
					["<esc>"] = require("telescope.actions").close
				},
			}
		},
		extensions = {
			-- ["ui-select"] = {
			-- 	require("telescope.themes").get_dropdown {}
			-- },
			["file_browser"] = {
				depth = 1,
				display_stat = false
			}
		}
	},
	config = function(_, opts)
		require("telescope").setup(opts)
		require("telescope").load_extension("file_browser")
		require("telescope").load_extension("notify")
	end,
	keys = {
		{ "<leader>p",        function() require("telescope.builtin").find_files { follow = true } end,                                          desc = "Telescope: Find files" },
		{ "<leader>h",        require("telescope.builtin").help_tags,                                                                            desc = "Telescope: Help" },
		{ "<leader>b",        require("telescope.builtin").buffers,                                                                              desc = "Telescope: Buffers" },
		{ "<leader>t",        require("telescope.builtin").colorscheme,                                                                          desc = "Telescope: Colorscheme" },
		{ "<leader>g",        require("telescope.builtin").grep_string,                                                                          desc = "Telescope: grep string under cursor" },
		{ "<leader><cr>",     require("telescope.builtin").resume,                                                                               desc = "Telescope: Resume Last" },

		{ "<leader>f",        function() require('telescope').extensions.file_browser.file_browser() end,                                        desc = "Telescope: File Browser" },
		{ "<leader>.",        function() require('telescope').extensions.file_browser.file_browser { path = "%:p:h", select_buffer = true } end, desc = "Telescope: File Browser" },

		{ "<leader>ev",       function() require("telescope.builtin").fd { cwd = "~/.config/nvim/" } end,                                        noremap = true,                              silent = true, desc = "Telescope: Find-file Nvim Config" },
		{ "<leader><leader>", function() vim.api.nvim_command [[Telescope]] end,                                                                 desc = "Telescope: Show all" },

		{ "<leader>d",        require("telescope.builtin").diagnostics,                                                                          desc = "Telescope: diagnostics" },
		{ "<leader>o",        require("telescope.builtin").lsp_document_symbols,                                                                 desc = "Telescope: diagnostics" },
	},
}
