local vautocmd = vim.api.nvim_create_autocmd

local vaugroup = function(name)
	return vim.api.nvim_create_augroup("vd_" .. name, { clear = true })
end

local setup_commands =  function ()
	vim.api.nvim_create_user_command('VDDisableDiagnostics', function ()
		vim.diagnostic.enable(false)
	end, {})

	vim.api.nvim_create_user_command('VDEnableDiagnostics', function ()
		vim.diagnostic.enable(true)
	end, {})
end

local M = {}

M.setup = function()
	local filetype_group = vim.api.nvim_create_augroup("FileTypeGroup", {clear = false})
	local ui_group = vim.api.nvim_create_augroup("UIGroup", {clear = false})

	vautocmd('VimResized', {
		desc = 'Keep Windows Equally resized',
		command = 'tabdo wincmd =',
		group = ui_group
	})

	-- Maps pattern to ExtraWhiteSpace
	vim.cmd[[match ExtraWhitespace /\s\+\%#\@<!$/]]
	vautocmd('ColorScheme', {
		pattern = "*",
		desc = 'Highlight trailing whitespace wigh ExtraWhiteSpace group',
		command = 'highlight ExtraWhitespace ctermbg=red guibg=red',
		group = ui_group
	})

	local yh_group = vim.api.nvim_create_augroup("yank_highlight", {})

	vautocmd("TextYankPost", {
		group = yh_group,
		pattern = '*',
		callback = function()
			vim.highlight.on_yank { higroup='IncSearch', timeout=700 }
		end,
	})

	vautocmd('BufWritePre', {
		desc = 'trim buffer whitespaces',
		pattern = '*',
		command = [[%s/\s\+$//e]],
	})

	vautocmd("BufReadPost", {
		group = vaugroup("last_loc"),
		callback = function()
			local mark = vim.api.nvim_buf_get_mark(0, '"')
			local lcount = vim.api.nvim_buf_line_count(0)
			if mark[1] > 0 and mark[1] <= lcount then
				pcall(vim.api.nvim_win_set_cursor, 0, mark)
			end
		end,
	})

	vautocmd("InsertLeave", {
		group = vaugroup("diagnostic_virtual_line_leave"),
		callback = function()
			vim.diagnostic.config({ virtual_text = true })
		end
	})

	vautocmd("InsertEnter", {
		group = vaugroup("diagnostic_virtual_line_enter"),
		callback = function()
			vim.diagnostic.config({ virtual_text = false })
		end
	})

	setup_commands()
end



M.setup_commands = setup_commands

return M

