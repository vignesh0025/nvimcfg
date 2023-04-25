local M = {}

local map = function (mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local has = function (plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

M.telescope_keymaps = function()
	local builtin = require('telescope.builtin')

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
	vim.keymap.set('n', '<leader>.', function() extensions.file_browser.file_browser{path="%:p:h", select_buffer=true} end, {})
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

M.gitsigns_keymaps = function ()
	vim.keymap.set("n", "]g", ":Gitsigns next_hunk<CR>", {})
	vim.keymap.set("n", "[g", ":Gitsigns prev_hunk<CR>", {})
	vim.keymap.set("n", ",gd", ":Gitsigns reset_hunk<CR>", {})
	vim.keymap.set("n", ",gp", ":Gitsigns preview_hunk<CR>", {})
	vim.keymap.set("n", ",gi", ":Gitsigns preview_hunk_inline<CR>", {})
end

M.general_keymaps = function ()
	vim.keymap.set("n", ",k", vim.diagnostic.open_float, {})

	-- tabs
	map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
	map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
	map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
	map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
	map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
	map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

	-- better up/down
	map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
	map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

	if has("bufferline.nvim") then
		vim.api.nvim_del_keymap("n", "]b")
		vim.api.nvim_del_keymap("n", "[b")
		map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
		map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
	end

	-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
	map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
	map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
	map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
	map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
	map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
	map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

end

return M
