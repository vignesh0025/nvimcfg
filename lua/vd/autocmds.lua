local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.setup = function()

-- Update autocmds to use this augroup
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Clears the group if present
local filetype_group = vim.api.nvim_create_augroup("FileTypeGroup", {clear = false})
local ui_group = vim.api.nvim_create_augroup("UIGroup", {clear = false})

autocmd('VimResized', {
	desc = 'Keep windows equally resized',
	command = 'tabdo wincmd =',
	group = ui_group,
})

autocmd('BufEnter', {
	desc = 'Quit nvim if nvim-tree is the last buffer',
	command = 'if winnr("$") == 1 && bufname() == "NvimTree_" . tabpagenr() | quit | endif',
	group = ui_group
})

vim.cmd[[match ExtraWhitespace /\s\+\%#\@<!$/]]

autocmd('ColorScheme', {
	pattern = "*",
	desc = 'Highlight trailing whitespace wigh ExtraWhiteSpace group',
	command = 'highlight ExtraWhitespace ctermbg=red guibg=red',
	group = ui_group
})

local yh_group = vim.api.nvim_create_augroup("yank_highlight", {})

autocmd("TextYankPost", {
	group = yh_group,
	pattern = '*',
	callback = function()
		vim.highlight.on_yank { higroup='IncSearch', timeout=700 }
	end,
})

autocmd({ 'BufWritePre' }, {
	desc = 'trim buffer whitespaces',
	pattern = '*',
	command = [[%s/\s\+$//e]],
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

end

-- vim.api.nvim_create_autocmd('LspAttach', {
--   desc = 'LSP actions',
--   callback = function()
-- 	  print("LspStarted")
--   end
-- })

M.au_session = function ()
	local session_grp = vim.api.nvim_create_augroup("SessionGrp", {clear = true})
	autocmd('VimEnter', {
		desc = 'Source .session file if it exists',
		pattern = "*",
		group = session_grp,
		nested = true,
		callback = function ()
			local args = vim.fn.argv()
			if #args == 0 then
				require("sessions").load(nil, { silent = true })
			end
		end
	})
end

M.setup_commands =  function ()
	vim.api.nvim_create_user_command('VDDisableDiagnostics', function ()
		vim.diagnostic.disable()
	end, {})

	vim.api.nvim_create_user_command('VDEnableDiagnostics', function ()
		vim.diagnostic.enable()
	end, {})
end

return M
