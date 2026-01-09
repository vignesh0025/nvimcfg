return {
		'nvim-lualine/lualine.nvim',
		dependencies = { 'kyazdani42/nvim-web-devicons' },
		opts = {
			extensions = { 'quickfix' },
			options = {
				globalstatus = true,
			},
			sections = {
				lualine_x = {
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = { fg = "#ff9e64" },
					},
				},
			}
		},
		config = function(_, opts)
			require('lualine').setup(opts)
			-- require("vd.autocmds").setup_dirchanged_autocmd()
		end
	}
