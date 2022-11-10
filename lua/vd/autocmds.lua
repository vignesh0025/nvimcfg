local autocmd = vim.api.nvim_create_autocmd

-- Clears the group if present
local filetype_group = vim.api.nvim_create_augroup("FileTypeGroup", {clear = false})
local ui_group = vim.api.nvim_create_augroup("UIGroup", {clear = false})

autocmd({"BufEnter", "BufWinEnter"}, {
	pattern = {"*.test_suite", "*.testsuite"},
	callback = function() vim.bo.filetype = "xml"  end,
	group = filetype_group,
})

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

local yh_group = vim.api.nvim_create_augroup("yank_highlight", {})

autocmd("TextYankPost", {
	group = yh_group,
	pattern = '*',
	callback = function()
		vim.highlight.on_yank { higroup='IncSearch', timeout=700 }
	end,
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--   desc = 'LSP actions',
--   callback = function()
-- 	  print("LspStarted")
--   end
-- })

-- autocmd({ 'BufWritePre' }, {
-- 	desc = 'trim buffer whitespaces',
-- 	pattern = '*',
-- 	command = 'TrimTrailingWhitespace',
-- 	group = filetype_group
-- })


