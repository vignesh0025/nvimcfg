local ts = require'nvim-treesitter.ts_utils'

function i(arg)
	vim.print(arg)
end

local q = require'vim.treesitter'
local node = q.get_node();
if node == nil then
	error("No Treesitter parser found")
end

if node:type() == "comment" then
	-- ts.update_selection(0, node)
	local comment_string = q.get_node_text(node, 0)
	local start_row, start_col, end_row, end_col = q.get_node_range(node)
	-- 3rd param: start from position 0
	-- 4th param: plain text search, don't use reg exp in pattern
	s, e = string.find(comment_string, "/*", 0, true)
	-- print(s, e)
	if s ~= nil then
		-- Its a block comment
		res = string.gsub(comment_string, "/%*(.-)%*/", "/* TODO: %1 */")
		vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {res})
		-- print(res)

	end
	-- vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {"/* Summa Comment */"})
end

-- print(vim.inspect(getmetatable(node)))
-- print(node:type())
-- print(n:sexpr())
-- print(n:start())
-- ts.update_selection(0, node)
-- print(q.get_node_text(node, 0))

-- local language_tree = vim.treesitter.get_parser(bufnr, 'c')
local language_tree = vim.treesitter.get_parser()
local syntax_tree = language_tree:parse()
local root = syntax_tree[1]:root()

local query = vim.treesitter.query.parse('c', [[
	((comment) @comment)
]])

-- i(query)

for _, captures, metadata in query:iter_matches(root, bufnr) do
	-- print("RDR")
	-- print(vim.inspect(getmetatable(vim.inspect(captures[1]))))
--[[ 	i(captures[2])
	i(q.get_node_text(captures[2], bufnr)) ]]
end
