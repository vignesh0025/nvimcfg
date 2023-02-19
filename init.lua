vim.g.mapleader=" "
vim.g.maplocalleader=[[\<space>]]

--vim.lsp.set_log_level("debug")
pcall(require, 'paths')

require('globals')
require('vd')

local ok, mod = pcall(require, 'plenary.reload')
if not ok then
	print("Planery Not Available"..mod)
else
	mod.reload_module("vd.", true)
end
vim.o.number = true
vim.o.signcolumn = "yes" -- always have signcolumn so text doesn't move right
vim.o.colorcolumn = "120"
vim.o.hidden = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.showbreak = "↪"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.list = true
vim.o.shiftround = true
vim.o.scrolloff = 3
-- set expandtab
-- filetype plugin indent on
vim.opt.isfname:append({'{', '}'})
vim.opt.isfname:remove({'='})
vim.opt.listchars:append({trail="~"})
vim.opt.swapfile = false

vim.keymap.set("x",'/','<Esc>/\\%V')
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set('i', "jk", "<esc>")

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " } for type, icon in pairs(signs) do local hl = "DiagnosticSign" .. type vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" }) end
