local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
-- function(client, bufnr)
vim.g.on_attach = function(_, bufnr)

	local builtin = require('telescope.builtin')

	vim.keymap.set('n', '<c-Bslash>', builtin.live_grep, {})
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
	-- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', 'gr', builtin.lsp_references, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

return require('packer').startup(function(use)

	-- Packer can manage itself
	use "wbthomason/packer.nvim"

	use 'wellle/targets.vim' -- Nice Plugin to add more selection

	use 'tpope/vim-unimpaired'

	use { "ellisonleao/gruvbox.nvim",
		disable = true,
		config = function()
			vim.o.background = "dark"
			-- vim.cmd([[colorscheme gruvbox]])
		end,
	}

	use {'navarasu/onedark.nvim',
		config = function()
			require('onedark').setup({ style = 'darker' })
			require('onedark').load()
		end
	}


	use {
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = {
			{"nvim-lua/plenary.nvim"},
			{ "vignesh0025/telescope-file-browser.nvim" },
			-- { "nvim-telescope/telescope-file-browser.nvim" },
			{'nvim-telescope/telescope-ui-select.nvim'},
			{'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
		config = function()
			require('telescope').setup{
				defaults = {
					winblend = 20,
					path_display = function(opts, path)
						local tutils = require("telescope.utils")
						local tail = tutils.path_tail(path)
						local head = vim.fn.fnamemodify(path, ":~:h")
						head = (head == '.') and '' or '('..head..')'
						return string.format("%s %s", tail, head)
					end,
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close
						},
					}
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {}
					},
					["file_browser"] = {
						depth = 4
					}
				}
			}
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("file_browser")
			require('telescope').load_extension('fzf')
			require("telescope").load_extension("live_grep_args")
			require('vd.keymaps').telescope_keymaps()
		end
	}

	use "tpope/vim-commentary"

	use "tpope/vim-surround"

	use "tpope/vim-fugitive"

	use {
		"TimUntersberger/neogit",
		config = function()
			require('neogit').setup{
				integrations = { diffview = true },
			}
		end
	}

	use "sindrets/diffview.nvim"

	use {
		'lewis6991/gitsigns.nvim',
		tag = 'release',
		config = function()
			require('gitsigns').setup()
		end
	}

	use {"ms-jpq/coq_nvim",
		disable = false,
		setup = function()
			vim.g.coq_settings = {["auto_start"] = "shut-up"}
		end
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			require('lualine').setup{
				options =  {
					globalstatus = true
				}
			}
		end
	}

	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		setup = function()
			    vim.g.loaded = 1
			    vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			require("nvim-tree").setup{
				view = {
					adaptive_size = false,
					side = "right",
				}
			}
			vim.keymap.set("n","<C-n>","<Cmd>NvimTreeToggle<CR>", {})
		end
	}

	use {
		'akinsho/bufferline.nvim',
		tag = "v2.*",
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			vim.opt.termguicolors = true
			require("bufferline").setup{
				options = {
					numbers = "ordinal",
					diagnostics = "nvim_lsp"
					}
				}
		end
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
		config = function()
			require'nvim-treesitter.configs'.setup {
				-- A list of parser names, or "all"
				ensure_installed = { "c", "lua", "python" },
				sync_install = false,
				highlight = {
					-- `false` will disable the whole extension
					enable = true,
				},
				fold = {
					enable = false
				}

			}
		end
	}

	use {
		"neovim/nvim-lspconfig",
		config = function()
			local ret,coq = pcall(require, "coq")

			local setup_config = ret and coq.lsp_ensure_capabilities({on_attach = vim.g.on_attach}) or {on_attach = vim.g.on_attach}

			require'lspconfig'.pyright.setup(setup_config)
			require'lspconfig'.clangd.setup(setup_config)
			require'lspconfig'.sumneko_lua.setup({
				on_attach = vim.g.on_attach,
				settings = { Lua = {
					runtime = { version = 'LuaJIT', },
					diagnostics = { globals = {'vim'}, },
					workspace = { library = vim.api.nvim_get_runtime_file("", true), },
					telemetry = { enable = false, },
				}, },
			})
		end	}

	use {
		"nvim-neorg/neorg",
		run = ":Neorg sync-parsers",
		config = function()
			require('neorg').setup {
				load = {
					["core.defaults"] = {}
				}
			}
		end,
	}

	use {
		"j-hui/fidget.nvim",
		config = function()
			require"fidget".setup{}
		end
	}

	use {
		"sbdchd/neoformat",
		setup = function()
			vim.g.neoformat_cpp_clangformat = { exe =  '/usr/intel/pkgs/clang/11.0.1/bin/clang-format', }
			vim.g.neoformat_enabled_cpp = {'clangformat'}
			vim.g.neoformat_enabled_c = {'clangformat'}
		end
	}

	use { "chrisbra/csv.vim", ft = { "csv" } }

end)
