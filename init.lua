--vim.lsp.set_log_level("debug")
pcall(require, 'paths')

local ok, ret = pcall(require, 'plenary.reload')
if not ok then
    print("Planery Not Available"..ret)
else
    ret.reload_module("vd.", true)
end

-- load lua/plugins.lua
require('vd.plugins')

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

-- Clears the group if present
local testsuite_group = vim.api.nvim_create_augroup("TestSuiteGroup", {})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	pattern = {"*.test_suite", "*.testsuite"},
	group = testsuite_group,
	callback = function() vim.bo.filetype = "xml"  end,
})
