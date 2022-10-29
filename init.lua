--vim.lsp.set_log_level("debug")
pcall(require, 'paths')

local ok, ret = pcall(require, 'plenary.reload')
if not ok then
    print("Planery Not Available"..ret)
else
    ret.reload_module("vd.", true)
end


vim.o.number = true
vim.o.signcolumn = "yes" -- always have signcolumn so text doesn't move right
vim.o.colorcolumn = '120'
vim.o.hidden = true
vim.o.tabstop = 4
vim.o.shiftwidth=4
vim.o.softtabstop=4
vim.o.showbreak = '↪'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.list = true
vim.o.shiftround = true
-- set expandtab

-- filetype plugin indent on

vim.g.mapleader=","
vim.g.maplocalleader=[[\<space>]]

-- load lua/plugins.lua
require('vd.filetype')
require('vd.autocmds')
require('vd.plugins')
