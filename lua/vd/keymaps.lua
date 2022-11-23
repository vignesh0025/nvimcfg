local telescope_keymaps = function()
	local builtin = require('telescope.builtin')

	vim.keymap.set('n', '<c-p>h', builtin.help_tags, {})
	-- vim.keymap.set('n', '<c-Bslash>', builtin.live_grep, {})
	vim.keymap.set('n', '<c-p><c-p>', function() builtin.find_files{follow=true} end, {})
	vim.keymap.set('n', '<c-p>r', builtin.oldfiles, {})
	vim.keymap.set('n', '<c-p>b', builtin.buffers, {})
	vim.keymap.set('n', '<c-p>o', builtin.lsp_document_symbols, {})
	vim.keymap.set('n', '<c-p>g', builtin.grep_string, {})
	vim.keymap.set('n', '<c-p>d', function() builtin.diagnostics{bufnr=0} end, {})

	local bufopts = { noremap=true, silent=true}
	vim.keymap.set("n", "<leader>ev", function() builtin.fd{cwd="~/.config/nvim/"} end, bufopts)

	local extensions = require('telescope').extensions
	vim.keymap.set('n', '<c-p>f',extensions.file_browser.file_browser, {})
	-- This actually maps <c-/> to fb at current open file directory
	vim.keymap.set('n', '<c-_>', function() extensions.file_browser.file_browser({cwd=vim.fn.expand("%:h")}) end, {})
	vim.keymap.set('n', '<c-Bslash>', extensions.live_grep_args.live_grep_args, {})
end

local tmux_keymaps = function ()
	vim.keymap.set('n', '<m-j>', require("tmux").move_bottom, {})
	vim.keymap.set('n', '<m-h>', require("tmux").move_left, {})
	vim.keymap.set('n', '<m-k>', require("tmux").move_top, {})
	vim.keymap.set('n', '<m-l>', require("tmux").move_right, {})

	vim.keymap.set('n', '<m-Down>', require("tmux").move_bottom, {})
	vim.keymap.set('n', '<m-Left>', require("tmux").move_left, {})
	vim.keymap.set('n', '<m-Up>', require("tmux").move_top, {})
	vim.keymap.set('n', '<m-Right>', require("tmux").move_right, {})
end

return {
	telescope_keymaps = telescope_keymaps,
	tmux_keymaps = tmux_keymaps
}
