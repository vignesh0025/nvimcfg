vim.opt.updatetime = 400

local highlight_symbol = function(event)
	local id = vim.tbl_get(event, 'data', 'client_id')
	local client = id and vim.lsp.get_client_by_id(id)
	if client == nil or not client.supports_method('textDocument/documentHighlight') then
		return
	end

	local group = vim.api.nvim_create_augroup('highlight_symbol', { clear = false })

	vim.api.nvim_clear_autocmds({ buffer = event.buf, group = group })

	vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
		group = group,
		buffer = event.buf,
		callback = function()
			vim.lsp.buf.document_highlight()
		end
	})

	vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
		group = group,
		buffer = event.buf,
		callback = vim.lsp.buf.clear_references,
	})
end

return {
	"neovim/nvim-lspconfig",
	dependencies = { 'saghen/blink.cmp' },
	opts = {
		servers = {
			lua_ls = {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath('config')
							and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
						runtime = {
							version = 'LuaJIT',
							path = {
								'lua/?.lua',
								'lua/?/init.lua',
							},
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME
								-- Depending on the usage, you might want to add additional paths here.
								-- '${3rd}/luv/library'
								-- '${3rd}/busted/library'
							}
						}
					})
				end,
				settings = {
					Lua = {}
				}
			},
			rust_analyzer = {},
		}
	},
	config = function(_, opts)
		for server, config in pairs(opts.servers) do
			-- Add additional capabilities supported by blink.cmp here
			config.capabilities = require('blink.cmp').get_lsp_capabilities()
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end

		vim.lsp.inlay_hint.enable(true);

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = '✘',
					[vim.diagnostic.severity.WARN] = '▲',
					[vim.diagnostic.severity.HINT] = '⚑',
					[vim.diagnostic.severity.INFO] = '»',
				},
			},
		})

		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'Setup highlight symbol',
			callback = highlight_symbol,
		})
	end

}
