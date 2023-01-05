local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)local plugins = {

	{ "EdenEast/nightfox.nvim", lazy = true },

	'wellle/targets.vim', -- Nice Plugin to add more selection

	'tpope/vim-unimpaired',

	{ "ellisonleao/gruvbox.nvim",
		enabled = false,
		config = function()
			vim.o.background = "dark"
			-- vim.cmd([[colorscheme gruvbox]])
		end,
	},

	 { "folke/tokyonight.nvim",
		enabled = false,
		config = function()
			require("tokyonight").setup({
				style = "storm",
					theme = 'tokyonight'
			})
			-- vim.cmd[[colorscheme tokyonight]]
		end
	},

	 -- {'kyazdani42/nvim-web-devicons'}

	 {
		'nvim-lualine/lualine.nvim',
		dependencies = { 'kyazdani42/nvim-web-devicons'},
		config = function()
			require('lualine').setup{
				options =  {
					globalstatus = true,
				}
			}
		end
	},

	-- you can use the VeryLazy event for things that can
	-- load later and are not important for the initial UI
	{ "stevearc/dressing.nvim", event = "VeryLazy" },

	 {
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			{"nvim-lua/plenary.nvim"},
			{ "nvim-telescope/telescope-file-browser.nvim" },
			-- {'nvim-telescope/telescope-ui-select.nvim'},
			{'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
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
						depth = 1
					}
				}
			}
			-- require("telescope").load_extension("ui-select")
			require("telescope").load_extension("file_browser")
			require('telescope').load_extension('fzf')
			require("telescope").load_extension("live_grep_args")
			require('vd.keymaps').telescope_keymaps()
		end
	},

	 "tpope/vim-commentary",

	 "tpope/vim-surround",

	 {
		"TimUntersberger/neogit",
		cmd = 'Neogit',
		config = function()
			require('neogit').setup{
				integrations = { diffview = true },
			}
		end
	},

	 "sindrets/diffview.nvim",

	 {
		'lewis6991/gitsigns.nvim',
		tag = 'release',
		config = function()
			require('gitsigns').setup()
		end
	},

	 {
		'kyazdani42/nvim-tree.lua',
		dependencies = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		init = function()
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
	},

	 {
		'akinsho/bufferline.nvim',
		tag = "v3.0.0",
		dependencies = 'kyazdani42/nvim-web-devicons',
		config = function()
			vim.opt.termguicolors = true
			require("bufferline").setup{
				options = {
					numbers = "ordinal",
					diagnostics = "nvim_lsp"
					}
				}
		end
	},

	 {
		'nvim-treesitter/nvim-treesitter',
		event = 'BufRead',
		build = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
		config = function()
			require'nvim-treesitter.configs'.setup {
				-- A list of parser names, or "all"
				ensure_installed = { "c", "lua", "python", "cpp" },
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
	},
	 { "nvim-treesitter/nvim-treesitter-textobjects",
		event = 'BufRead',
		config = function ()
		require('nvim-treesitter.configs').setup({
			textobjects = {
				select = {
					enable = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
					},
				}
			}
		})
	end },

	 { "ms-jpq/coq_nvim", enabled = false, setup = require('vd.lspsetup').setup_coq },
	 { 'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-vsnip',
			'hrsh7th/vim-vsnip',
		},
		config = require('vd.lspsetup').config_nvimcmp
	},
	 { "neovim/nvim-lspconfig", config = require('vd.lspsetup').config_lspconfig },

	 {
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		config = function()
			require('neorg').setup {
				load = {
					["core.defaults"] = {}
				}
			}
		end,
	},

	 {
		"j-hui/fidget.nvim",
		config = function()
			require"fidget".setup{}
		end
	},

	 {
		"sbdchd/neoformat",
		init = function()
			vim.g.neoformat_cpp_clangformat = { exe =  'clang-format', }
			vim.g.neoformat_enabled_cpp = {'clangformat'}
			vim.g.neoformat_enabled_c = {'clangformat'}
		end
	},

	 { "chrisbra/csv.vim", ft = { "csv" } },

	-- SessionLoad
	-- SessionSave
	-- SessionStop
	 {'natecraddock/sessions.nvim', config = function ()
		require("sessions").setup({
			session_filepath = "./.session",
		})

		require("vd.autocmds").au_session()
	end},


	 {'dstein64/vim-startuptime', enabled=false},

	-- TODO: Resize support
	 { "aserowy/tmux.nvim", config = function ()
		require("tmux").setup{
			navigation = {
				cycle_navigation = false,
			},
		-- 	resize = {
		-- 		-- enables default keybindings (A-hjkl) for normal mode
		-- 		enable_default_keybindings = false,

		-- 		-- sets resize steps for x axis
		-- 		resize_step_x = 1,

		-- 		-- sets resize steps for y axis
		-- 		resize_step_y = 1,
		-- 	}
		}
		require("vd.keymaps").tmux_keymaps()
	end},

	{
		'glepnir/lspsaga.nvim',
		branch = "main",
		cmd = "Lspsaga",
		config = function ()
			require("lspsaga")
		end
	}
}

local opt = {
	-- ui = {
	-- 	custom_keys = {
	-- 		-- open lazygit log
	-- 		["<leader>l"] = function(plugin)
	-- 			require("lazy.util").open_cmd({ "lazygit", "log" }, { cwd = plugin.dir, terminal = true, close_on_exit = true, enter = true})
	-- 		end,

	-- 		["<leader>t"] = function(plugin)
	-- 			require("lazy.util").open_cmd({ vim.go.shell }, {
	-- 				cwd = plugin.dir,
	-- 				terminal = true,
	-- 				close_on_exit = true,
	-- 				enter = true,
	-- 			})
	-- 		end,
	-- 	},
	-- }
}

require("lazy").setup(plugins, opt)
require("vd.keymaps").lazy_keymaps()
