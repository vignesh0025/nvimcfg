local telescope_keymaps = function()
	local builtin = require('telescope.builtin')

	vim.keymap.set('n', '<c-p>h', builtin.help_tags, {})
	vim.keymap.set('n', '<c-p><c-p>', function() builtin.find_files{follow=true} end, {})
	vim.keymap.set('n', '<c-p>r', builtin.oldfiles, {})
	vim.keymap.set('n', '<c-p>b', builtin.buffers, {})
	vim.keymap.set('n', '<c-p>o', builtin.lsp_document_symbols, {})
	vim.keymap.set('n', '<c-p>g', builtin.grep_string, {})
	vim.keymap.set('n', '<c-p>d', function() builtin.diagnostics{bufnr=0} end, {})
	vim.keymap.set('n', '<c-p>t', builtin.colorscheme)

--	Leader based Keymaps
	vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
	vim.keymap.set('n', '<leader>p', function() builtin.find_files{follow=true} end, {})
	vim.keymap.set('n', '<leader>r', builtin.oldfiles, {})
	vim.keymap.set('n', '<leader>b', builtin.buffers, {})
	vim.keymap.set('n', '<leader>o', builtin.lsp_document_symbols, {})
	vim.keymap.set('n', '<leader>g', builtin.grep_string, {})
	vim.keymap.set('n', '<leader>d', function() builtin.diagnostics{bufnr=0} end, {})
	vim.keymap.set('n', '<leader>t', builtin.colorscheme)
	vim.keymap.set('n', '<leader><cr>', builtin.resume, {})

-- Extension Keymaps
	local extensions = require('telescope').extensions

	vim.keymap.set('n', '<c-p>f',extensions.file_browser.file_browser, {})
	-- This actually maps <c-/> to fb at current open file directory
	-- vim.keymap.set('n', '<c-_>', function() extensions.file_browser.file_browser{cwd=vim.fn.expand("%:p:h")} end, {})
	vim.keymap.set('n', '<c-_>', function() extensions.file_browser.file_browser{path="%:p:h"} end, {})
	vim.keymap.set('n', '<c-Bslash>', extensions.live_grep_args.live_grep_args, {})

	vim.keymap.set('n', '<leader>f',extensions.file_browser.file_browser, {})
	vim.keymap.set('n', '<leader>.', function() extensions.file_browser.file_browser{path="%:p:h"} end, {})
	vim.keymap.set('n', '<leader>/', extensions.live_grep_args.live_grep_args, {})

	local bufopts = { noremap=true, silent=true}
	vim.keymap.set("n", "<leader>ev", function() builtin.fd{cwd="~/.config/nvim/"} end, bufopts)

	vim.keymap.set("n", "<leader><leader>", function ()
		vim.api.nvim_command[[Telescope]]
	end)
end

return {
	telescope_keymaps = telescope_keymaps
}
