local path, mod = pcall(require, 'paths')
if not path then
    print("Path Not Available")
end

local M = {}

M.plugin = {}

M.plugin.mason_enabled = (path and mod.mason_enabled) or false
M.plugin.neodev_enabled = (path and mod.neodev_enabled) or false
M.plugin.rust_analyzer = (path and mod.rust_analyzer) or false

M.get_addn_nulls_srcs = function()
	if mod.enbl_nulls_addn_srcs then
		local null_ls = require("null-ls")
		local add_srcs = {
			null_ls.builtins.diagnostics.luacheck,
			null_ls.builtins.formatting.stylua
		}
		return add_srcs
	else
		return nil
	end
end

return M
