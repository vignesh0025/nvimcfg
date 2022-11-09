vim.g.kind_icons = {
    Text = ' ',
    Method = ' ',
    Function = ' ',
    Constructor = ' ',
    Field = 'ﰠ ',
    Variable = ' ',
    Class = ' ',
    Interface = ' ',
    Module = ' ',
    Property = ' ',
    Unit = ' ',
    Value = ' ',
    Enum = ' ',
    Keyword = ' ',
    Snippet = '﬌',
    Color = ' ',
    File = ' ',
    Reference = ' ',
    Folder = ' ',
    EnumMember = ' ',
    Constant = ' ',
    Struct = ' ',
    Event = '⌘ ',
    Operator = ' ',
    TypeParameter = ' ',
}

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
-- function(client, bufnr)
vim.g.on_attach = function(_, bufnr)

	-- Enable completion triggered by <c-x><c-o>

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

	local ret, builtin = pcall(require, 'telescope.builtin')
	if ret then
		vim.keymap.set('n', 'gr', builtin.lsp_references, bufopts)
	else
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	end

end


local config_lspconfig = function ()
	local lspconfig = require('lspconfig')

	local use_coq = false

	if use_coq == true then
		local ret,coq = pcall(require, "coq")
	else
		-- We are modifying default capabilities by appending our own.
		-- So no need to pass it to config
		local lsp_defaults = lspconfig.util.default_config
		lsp_defaults.capabilities = vim.tbl_deep_extend('force',
		lsp_defaults.capabilities,
		require('cmp_nvim_lsp').default_capabilities()
		)
	end

	local setup_config = ret and coq.lsp_ensure_capabilities({on_attach = vim.g.on_attach}) or {on_attach = vim.g.on_attach}

	lspconfig.pyright.setup(setup_config)
	lspconfig.clangd.setup(setup_config)
	lspconfig.sumneko_lua.setup({
		on_attach = vim.g.on_attach,
		settings = { Lua = {
			runtime = { version = 'LuaJIT', },
			diagnostics = { globals = {'vim'}, },
			workspace = { library = vim.api.nvim_get_runtime_file("", true), },
			telemetry = { enable = false, },
		}, },
	})
end

local config_nvimcmp = function ()
	-- Set up nvim-cmp.
	local cmp = require'cmp'

	vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

	local select_opts = {behavior = cmp.SelectBehavior.Select}
	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		window = {
			documentation = cmp.config.window.bordered()
		},
		formatting = {
			format = function(entry, vim_item)
				-- vim_item.kind = string.format('%s %s', vim.g.kind_icons[vim_item.kind], vim_item.kind)
				vim_item.kind = string.format('%s', vim.g.kind_icons[vim_item.kind])

				-- Source
				vim_item.menu = ({
					buffer = "[Buffer]",
					nvim_lsp = "[LSP]",
					luasnip = "[LuaSnip]",
					nvim_lua = "[Lua]",
				})[entry.source.name]
				return vim_item
			end
		},
		mapping = cmp.mapping.preset.insert({
			-- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
			-- ['<C-u>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = false }),
			['<Up>'] = cmp.mapping.select_prev_item(select_opts),
			['<Down>'] = cmp.mapping.select_next_item(select_opts),
			['<Tab>'] = cmp.mapping(function(fallback)
				local col = vim.fn.col('.') - 1
				if cmp.visible() then
					cmp.select_next_item(select_opts)
				elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
					fallback()
				else
					cmp.complete()
				end
			end, {'i', 's'}),
			['<S-Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item(select_opts)
				else
					fallback()
				end
			end, {'i', 's'}),
		}),
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
		}, {
			{ name = 'buffer' },
		})
	})

	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})
end

local setup_coq = function ()
	-- vim.g.coq_settings = {["auto_start"] = "shut-up"}
end

return {
	config_lspconfig = config_lspconfig,
	config_nvimcmp = config_nvimcmp,
	setup_coq = setup_coq
}