local vconfig = require("config_enable")

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, vim.tbl_deep_extend("force", opts, {desc = "VimDiagnostic: List"}))

local config_lspconfig = function()

	vim.lsp.inlay_hint.enable();
	if vconfig.plugin.mason_enabled then
		require("mason").setup()
		require("mason-lspconfig").setup()
	end

	local lspconfig = require("lspconfig")

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	-- function(client, bufnr)
	local on_attach = function(client, bufnr)

				-- Enable completion triggered by <c-x><c-o>

		-- print(vim.inspect(client.name))
		-- print(vim.inspect(client.server_capabilities))

		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		local e = function (o, desc)
			return vim.tbl_deep_extend("force", o, desc)
		end
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, e(bufopts, {desc = "VimLsp: Goto Declaration"}))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, e(bufopts, {desc = "VimLsp: Goto Definition"}))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, e(bufopts, {desc = "VimLsp: Show Hover"}))
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, e(bufopts, {desc = "VimLsp: Goto Implementation"}))
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, e(bufopts, {desc = "VimLsp: Show Signature"}))
		vim.keymap.set("n", ",wa", vim.lsp.buf.add_workspace_folder, e(bufopts, {desc = "VimLsp: Add Workspace Folder"}))
		vim.keymap.set("n", ",wr", vim.lsp.buf.remove_workspace_folder, e(bufopts, {desc = "VimLsp: Remove Worksapce Folder"}))
		vim.keymap.set("n", ",wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, e(bufopts, {desc = "VimLsp: Goto Declaration"}))
		vim.keymap.set("n", ",D", vim.lsp.buf.type_definition, e(bufopts, {desc = "VimLsp: Goto Type Definition"}))
		vim.keymap.set("n", ",rn", vim.lsp.buf.rename, e(bufopts, {desc = "VimLsp: Rename Symbol"}))
		vim.keymap.set({"n", "v"}, ",ca", vim.lsp.buf.code_action, e(bufopts, {desc = "VimLsp: Code Action"}))
		vim.keymap.set({"n", "v"}, ",=", function()
			vim.lsp.buf.format({ async = true })
		end, e(bufopts, {desc = "VimLsp: Format"}))

		local ret, builtin = pcall(require, "telescope.builtin")
		if ret then
			vim.keymap.set("n", "gr", builtin.lsp_references, e(bufopts, {desc = "VimLsp: Find References"}))
		else
			vim.keymap.set("n", "gr", vim.lsp.buf.references, e(bufopts, {desc = "VimLsp: Find References"}))
		end

	end

	local use_coq = false

	-- We are modifying default capabilities by appending our own.
	-- So no need to pass it to config
	local lsp_defaults = lspconfig.util.default_config
	lsp_defaults.capabilities =
	vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

	local setup_config = { on_attach = on_attach }

	lspconfig.basedpyright.setup(setup_config)
	lspconfig.clangd.setup(vim.tbl_deep_extend("force", setup_config, {
		cmd = {
			"clangd",
			"--header-insertion=never"
		}
	}))
	lspconfig.lua_ls.setup({
		on_attach = on_attach,
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim", "describe", "it" } },
				workspace = { library = vim.api.nvim_get_runtime_file("", true) },
				telemetry = { enable = false },
				checkThirdParty = false
			},
		},
	})

	if vconfig.plugin.rust_analyzer then
		lspconfig.rust_analyzer.setup(setup_config)
	end
end

local config_nvimcmp = function()
	local kind_icons = {
		Text = " ",
		Method = " ",
		Function = " ",
		Constructor = " ",
		Field = "ﰠ ",
		Variable = " ",
		Class = " ",
		Interface = " ",
		Module = " ",
		Property = " ",
		Unit = " ",
		Value = " ",
		Enum = " ",
		Keyword = " ",
		Snippet = "﬌",
		Color = " ",
		File = " ",
		Reference = " ",
		Folder = " ",
		EnumMember = " ",
		Constant = " ",
		Struct = " ",
		Event = "⌘ ",
		Operator = " ",
		TypeParameter = " ",
	}


	local has_words_before = function()
		unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local cmp = require("cmp")
	local luasnip = require("luasnip")
	local lspkind = require('lspkind') --Icons for LSP

	vim.keymap.set("n", "<leader>se", function ()
		require("luasnip.loaders").edit_snippet_files()
	end, { desc = "LuaSnip: Edit Snippet for current filetype"})

	vim.keymap.set({"i", "s" }, "<C-j>", function ()
		if luasnip.choice_active() then
			luasnip.change_choice(1)
		end
	end, {})

	vim.keymap.set({"i", "s" }, "<C-k>", function ()
		if luasnip.choice_active() then
			luasnip.change_choice(-1)
		end
	end, {})

	vim.keymap.set({"i", "s" }, "<C-l>", function ()
		if luasnip.choice_active() then
			luasnip.change_choice(-1)
		end
	end, {noremap=true,})

	vim.opt.completeopt = { "menu", "menuone", "noselect" }

	local select_opts = { behavior = cmp.SelectBehavior.Select }
	cmp.setup({
		snippet = {
			expand = function(args)
				require('luasnip').lsp_expand(args.body)
			end,
		},
		window = {
			documentation = cmp.config.window.bordered(),
		},
		formatting = {
			format = lspkind.cmp_format({
				before = function (entry,  vim_item)
					-- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

					-- vim_item.menu = ({
					-- 	buffer = "[Buffer]",
					-- 	nvim_lsp = "[LSP]",
					-- 	luasnip = "[LuaSnip]",
					-- 	nvim_lua = "[Lua]",
					-- })[entry.source.name]
					return vim_item
				end
			})
		},
		mapping = cmp.mapping.preset.insert({
			['<C-u>'] = cmp.mapping.scroll_docs(-4),
			['<C-d>'] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = false }),
			["<Up>"] = cmp.mapping.select_prev_item(select_opts),
			["<Down>"] = cmp.mapping.select_next_item(select_opts),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item(select_opts)
				elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item(select_opts)
				elseif luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{name = 'nvim_lsp_signature_help'}
		},{
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
		},{
			{ name = "path" },
		},
		{
			{ name = "buffer" },
		}),
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})
end

local setup_coq = function()
	-- vim.g.coq_settings = {["auto_start"] = "shut-up"}
end

return {
	config_lspconfig = config_lspconfig,
	config_nvimcmp = config_nvimcmp,
	setup_coq = setup_coq,
}
