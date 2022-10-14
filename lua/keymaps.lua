local telescope_keymaps = function()
	local builtin = require('telescope.builtin')

	vim.keymap.set('n', '<c-p>h', builtin.help_tags, {})
	-- vim.keymap.set('n', '<c-Bslash>', builtin.live_grep, {})
	vim.keymap.set('n', '<c-p><c-p>', function() builtin.find_files{follow=true} end, {})
	vim.keymap.set('n', '<c-p>r', builtin.oldfiles, {})
	vim.keymap.set('n', '<c-p>b', builtin.buffers, {})
	vim.keymap.set('n', '<c-p>o', builtin.lsp_document_symbols, {})
	vim.keymap.set('n', '<c-p>d', function() builtin.diagnostics{bufnr=0} end, {})

	local bufopts = { noremap=true, silent=true}
	vim.keymap.set("n", "<leader>ev", function() builtin.fd{cwd="~/.config/nvim/"} end, bufopts)

	local extensions = require('telescope').extensions
	vim.keymap.set('n', '<c-p>f', function() extensions.file_browser.file_browser() end, {})
	vim.keymap.set('n', '<c-Bslash>', extensions.live_grep_args.live_grep_args, {})
end

return {
	telescope_keymaps = telescope_keymaps
}
