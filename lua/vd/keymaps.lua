local M = {}

M.telescope_keymaps = function()
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

M.tmux_keymaps = function ()
	vim.keymap.set('n', '<m-j>', require("tmux").move_bottom, {})
	vim.keymap.set('n', '<m-h>', require("tmux").move_left, {})
	vim.keymap.set('n', '<m-k>', require("tmux").move_top, {})
	vim.keymap.set('n', '<m-l>', require("tmux").move_right, {})

	vim.keymap.set('n', '<m-Down>', require("tmux").move_bottom, {})
	vim.keymap.set('n', '<m-Left>', require("tmux").move_left, {})
	vim.keymap.set('n', '<m-Up>', require("tmux").move_top, {})
	vim.keymap.set('n', '<m-Right>', require("tmux").move_right, {})
end

M.lazy_keymaps = function ()

	local set_term_cmd_keymap = function (key, cmd, close_on_exit)
		vim.keymap.set('n',key, function ()
			require("lazy.util").float_term(cmd, {
				cwd = "./",
				terminal = true,
				close_on_exit = close_on_exit or true,
				enter = true,
			})
		end, {})
	end

	set_term_cmd_keymap(",gg", {"lazygit"})
	set_term_cmd_keymap(",gl", {"lazygit", "log"})
	set_term_cmd_keymap(",gs", {"lazygit", "status"})
	set_term_cmd_keymap(",gb", {"lazygit", "branch"})
	set_term_cmd_keymap(",gt", {"lazygit", "stash"})

end

return M
