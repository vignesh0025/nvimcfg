local M = {}

M.setup = function ()
	if vim.g.neovide then
	vim.g.neovide_scroll_animation_length = 0
	end
end

return M

