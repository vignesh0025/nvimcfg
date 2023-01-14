local path, mod = pcall(require, 'paths')
if not path then
    print("Path Not Available")
end

local M = {}

M.plugin = {}

M.plugin.mason_enabled = (path and mod.mason_enabled) or false
M.plugin.neodev_enabled = (path and mod.neodev_enabled) or false

return M
