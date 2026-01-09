return {
	'akinsho/bufferline.nvim',
	version = "*",
	dependencies = 'kyazdani42/nvim-web-devicons',
	opts = {
		-- Options are passed as require('bufferline').setup(opts)
		options = {
			separator_style = "slant",
			numbers = "ordinal",
			diagnostics = "nvim_lsp"
		}
	}
}

