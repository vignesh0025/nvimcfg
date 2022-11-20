
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

	use { "EdenEast/nightfox.nvim",
		config = function ()
			vim.cmd("colorscheme nightfox")
		end
	}
	use { "folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup({
				style = "storm",
					theme = 'tokyonight'
			})
			-- vim.cmd[[colorscheme tokyonight]]
		end
	}

	use {'kyazdani42/nvim-web-devicons'}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons'},
		config = function()
			require('lualine').setup{
				options =  {
					globalstatus = true,
				}
			}
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

	use { "ms-jpq/coq_nvim", setup = require('vd.lspsetup').setup_coq }
	use { 'hrsh7th/nvim-cmp', requires = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-vsnip',
			'hrsh7th/vim-vsnip',
		},
		config = require('vd.lspsetup').config_nvimcmp
	}
	use { "neovim/nvim-lspconfig", config = require('vd.lspsetup').config_lspconfig }

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

	-- SessionLoad
	-- SessionSave
	-- SessionStop
	use {'natecraddock/sessions.nvim', config = function ()
		require("sessions").setup({
			session_filepath = "./.session",
		})

		require("vd.autocmds").au_session()
	end}

end)
