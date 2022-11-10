local autocmd = vim.api.nvim_create_autocmd

local setup = function()

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

end

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

local au_session = function ()
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

return {
	setup = setup,
	au_session = au_session,
}
