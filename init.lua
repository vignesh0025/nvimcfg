vim.loader.enable()

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
vim.o.showbreak = "↪"
vim.o.smartindent = true
vim.o.list = true
vim.o.shiftround = true
vim.o.scrolloff = 3
vim.opt.splitkeep = "screen"

-- title
vim.opt.title = true

-- Tab options
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
-- set expandtab
-- :retab changes tab to space if expandtab is set or vice versa

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = "%f:%l:%c:%m"

vim.opt.joinspaces = false

-- filetype plugin indent on
vim.opt.isfname:append({'{', '}'})
vim.opt.isfname:remove({'='})
vim.opt.listchars:append({trail="~", tab = " ", extends = "»", precedes = "«", nbsp = "␣"})
vim.opt.swapfile = false

vim.keymap.set("x",'/','<Esc>/\\%V')
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set('i', "jk", "<esc>")

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " } for type, icon in pairs(signs) do local hl = "DiagnosticSign" .. type vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" }) end

if vim.loop.os_uname().sysname == "Darwin" then
	vim.o.guifont = "FiraCode Nerd Font:h17"
else
	vim.o.guifont = "Hack Nerd Font:h11"
end
