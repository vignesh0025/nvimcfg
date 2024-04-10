local M = {}

local map = function(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

local has = function(plugin)
	return require("lazy.core.config").plugins[plugin] ~= nil
end

local get_root = function()
	local root_patterns = { ".git", "lua" }

	---@type string?
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil
	---@type string[]
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace and vim.tbl_map(function(ws)
				return vim.uri_to_fname(ws.uri)
			end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	---@type string?
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		---@type string?
		root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end
	---@cast root string
	return root
end

M.telescope_keymaps = function()
	local builtin = require('telescope.builtin')

	--	Leader based Keymaps
	vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = "Telescope: Help"})
	vim.keymap.set('n', '<leader>p', function() builtin.find_files { follow = true } end, { desc = "Telescope: File Files"})
	vim.keymap.set('n', '<leader>r', builtin.oldfiles, { desc = "Telescope: Old Files"})
	vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "Telescope: Buffers"})
	vim.keymap.set('n', '<leader>o', builtin.lsp_document_symbols, { desc = "Telescope: Lsp Documents Symbols"})
	vim.keymap.set('n', '<leader>g', builtin.grep_string, { desc = "Telescope: Grep String under cursor"})
	vim.keymap.set('n', '<leader>d', function() builtin.diagnostics { bufnr = 0, layout_strategy = 'vertical' } end, { desc = "Telescope: Diagnostics"})
	vim.keymap.set('n', '<leader>t', builtin.colorscheme, { desc = "Telescope: Color Scheme"})
	vim.keymap.set('n', '<leader><cr>', builtin.resume, { desc = "Telescope: Resume Last"})

	-- Extension Keymaps
	local extensions = require('telescope').extensions

	vim.keymap.set('n', '<c-p>f', extensions.file_browser.file_browser, {})
	-- This actually maps <c-/> to fb at current open file directory
	-- vim.keymap.set('n', '<c-_>', function() extensions.file_browser.file_browser{cwd=vim.fn.expand("%:p:h")} end, {})
	vim.keymap.set('n', '<c-_>', function() extensions.file_browser.file_browser { path = "%:p:h" } end, {desc = "Telescope: File Browser"})
	vim.keymap.set('n', '<c-Bslash>', extensions.live_grep_args.live_grep_args, {desc = "Telescope: Live Grep with Args"})

	vim.keymap.set('n', '<leader>f', extensions.file_browser.file_browser, {desc = "Telescope: File Browser"})
	vim.keymap.set('n', '<leader>.',
		function() extensions.file_browser.file_browser { path = "%:p:h", select_buffer = true } end, {desc = "Telescope: File Browser under current file"})
	vim.keymap.set('n', '<leader>/', extensions.live_grep_args.live_grep_args, {desc = "Telescope: Live Grep"})

	local bufopts = { noremap = true, silent = true, desc = "Telescope: Find-file Nvim Config"}
	vim.keymap.set("n", "<leader>ev", function() builtin.fd { cwd = "~/.config/nvim/" } end, bufopts)

	vim.keymap.set("n", "<leader><leader>", function()
		vim.api.nvim_command [[Telescope]]
	end, {desc = "Telescope: Show all"})
end

M.tmux_keymaps = function()
	vim.keymap.set('n', '<m-j>', require("tmux").move_bottom, {})
	vim.keymap.set('n', '<m-h>', require("tmux").move_left, {})
	vim.keymap.set('n', '<m-k>', require("tmux").move_top, {})
	vim.keymap.set('n', '<m-l>', require("tmux").move_right, {})

	vim.keymap.set('n', '<m-Down>', require("tmux").move_bottom, {})
	vim.keymap.set('n', '<m-Left>', require("tmux").move_left, {})
	vim.keymap.set('n', '<m-Up>', require("tmux").move_top, {})
	vim.keymap.set('n', '<m-Right>', require("tmux").move_right, {})
end

M.lazy_keymaps = function()
	local set_term_cmd_keymap = function(key, cmd, term_opts, key_opts)
		local _opts = vim.tbl_deep_extend("force", {
			close_on_exit = true,
			cwd = get_root(),
			size = { width = 0.9, height = 0.9 },
			terminal = true,
			enter = true,
		}, term_opts or {})
		vim.keymap.set('n', key, function()
			require("lazy.util").float_term(cmd, _opts)
		end, key_opts or {})
	end

	set_term_cmd_keymap(",gg", { "lazygit" }, nil, { desc = "LazyGit" })
	set_term_cmd_keymap(",gl", { "lazygit", "log" }, nil, { desc = "LazyGit Log" })
	set_term_cmd_keymap(",gs", { "lazygit", "status" }, nil, { desc = "LazyGit Status" })
	set_term_cmd_keymap(",gb", { "lazygit", "branch" },  nil, { desc = "LazyGit Breanches" })

	set_term_cmd_keymap(",tf", nil, { cwd = get_root() }, { desc = "Term: Open floating terminal"})
	vim.keymap.set("n", ",t.", function()
		local _opts = {
			close_on_exit = true,
			cwd = vim.fn.expand("%:p:h"),
			size = { width = 0.9, height = 0.9 },
			terminal = true,
			enter = true,
		}
		require("lazy.util").float_term(nil, _opts)
	end, { desc = "Term: OPen floating terminal in current folder"})
end

M.gitsigns_keymaps = function()

	local gs = require('gitsigns')
	vim.keymap.set("n", "]g", gs.next_hunk, { desc = "Gitsigns: Next Hunk" })
	vim.keymap.set("n", "[g", gs.prev_hunk, { desc = "Gitsigns: Previous Hunk" })
	vim.keymap.set("n", ",gR", gs.reset_hunk, { desc = "Gitsigns: Reset Hunk" })
	vim.keymap.set("n", ",gp", gs.preview_hunk, { desc = "Gitsigns: Preview Hunk" })
	vim.keymap.set("n", ",gi", gs.preview_hunk_inline, { desc = "Gitsigns: Preview Hunk Inline" })
	vim.keymap.set("n", ",gd", gs.diffthis, { desc = "Gitsigns: Diff this file" })
	vim.keymap.set("n", ",ga", gs.stage_hunk, { desc = "Gitsigns: Stage Hunk" })

	vim.keymap.set("v", ",ga", function()
		gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, {desc = "Gitsigns: Stage Selected Hunk"})

	vim.keymap.set("v", ",gR", function()
		gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, {desc = "Gitsigns: Reset Selected Hunk"})

end

M.diffview_keymaps = function()
	return {
		{ ",go", "<cmd>DiffviewOpen<CR>",          desc = "Open diffview" },
		{ "ig",  ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" },   desc = "GitSigns Select Hunk" }
	}
end

M.general_keymaps = function()
	vim.keymap.set("n", ",k", vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })

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

	if has("neo-tree.nvim") then
		map("n", ",nf", "<cmd>Neotree filesystem float reveal=false<cr>", { desc = "Neotree FS Float" })
		map("n", ",nn", "<cmd>Neotree filesystem float reveal<cr>", { desc = "Neotree FS Current file Float" })
		map("n", ",ns", "<cmd>Neotree git_status float<cr>", { desc = "Neotree Git status Float" })
		map("n", ",nb", "<cmd>Neotree buffers float reveal<cr>", { desc = "Neotree Buffers Float" })
	end
end

M.conform_keymaps = function(conform)
	vim.keymap.set({ "n", "v" }, "<leader>=", function()
		conform.format({
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		})
	end, { desc = "Format file or range (in visual mode)" })
end

return M
