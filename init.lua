require("config.lazy")
require("config.autocmds").setup()

vim.opt.number = true
vim.opt.signcolumn = "yes" -- always have signcolumn so text doesn't move right
vim.opt.colorcolumn = "120"
vim.opt.hidden = true
vim.opt.showbreak = "↪"
vim.opt.smartindent = true
vim.opt.shiftround = true
vim.opt.scrolloff = 3
vim.opt.splitkeep = "screen"

vim.opt.title = true

-- Tab options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
-- set expandtab -- Use spaces when Tab is inserted
-- :retab changes tab to space if expandtab is set or vice versa

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- TODO: Depreciate this as not required anymore
-- vim.opt.grepprg
-- vim.opt.grepfmt
-- vim.opt.joinspaces = false -- Default is false

-- Go to File under curser(gf) mapping
vim.opt.isfname:remove({ '=' })

vim.opt.list = true -- Show non printable chars like trailing spaces and tabs
vim.opt.listchars:append({ trail = "~", extends = "»", precedes = "«", nbsp = "␣" })

-- Don't create swapfile
vim.opt.swapfile = false

-- Search within selected blocks in visual mode
vim.keymap.set("x", '/', '<Esc>/\\%V')
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Escape to normal mode with jk insert mode
vim.keymap.set('i', "jk", "<esc>")

if vim.g.neovide then
	vim.o.guifont = "FiraCode Nerd Font:h20"
end

-- nohup nvim --listen /tmp/nvim.pipe --headless > /dev/null 2>&1 0< /dev/null &!

