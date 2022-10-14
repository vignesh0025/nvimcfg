--vim.lsp.set_log_level("debug")
pcall(require, 'paths')

-- load lua/plugins.lua
require('plugins')

vim.o.number = true
vim.o.signcolumn = "yes" -- always have signcolumn so text doesn't move right
vim.o.colorcolumn = 120
vim.o.hidden = true
vim.o.tabstop = 4
vim.o.shiftwidth=4
vim.o.softtabstop=4
-- set expandtab

-- filetype plugin indent on

vim.g.mapleader=","
vim.g.maplocalleader=[[\<space>]]

local testsuite_group = vim.api.nvim_create_augroup("TestSuiteGroup", {
	clear = false
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	pattern = {"*.test_suite", "*.testsuite"},
	group = testsuite_group,
	callback = function() vim.bo.filetype = "xml"  end,
})
