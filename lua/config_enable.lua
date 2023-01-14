local path, mod = pcall(require, 'paths')
if not path then
    print("Path Not Available")
end

M = {}

M.plugin = {}

M.plugin.mason_enabled = (path and mod.mason_enabled) or false

return M
