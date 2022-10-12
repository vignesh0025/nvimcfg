  
--vim.lsp.set_log_level("debug")
require('paths')

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

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<c-p>h', builtin.help_tags, {})
vim.keymap.set('n', '<c-Bslash>', builtin.live_grep, {})
vim.keymap.set('n', '<c-p><c-p>', function() builtin.find_files{follow=true} end, {})
vim.keymap.set('n', '<c-p>r', builtin.oldfiles, {})
vim.keymap.set('n', '<c-p>b', builtin.buffers, {})
vim.keymap.set('n', '<c-p>o', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<c-p>d', function() builtin.diagnostics{bufnr=0} end, {})


local testsuite_group = vim.api.nvim_create_augroup("TestSuiteGroup", {
	clear = false
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	pattern = {"*.test_suite", "*.testsuite"},
	group = testsuite_group,
	callback = function() vim.bo.filetype = "xml"  end,
})
