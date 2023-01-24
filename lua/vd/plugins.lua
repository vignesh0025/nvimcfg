local vconfig = require("config_enable")

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

vim.opt.rtp:prepend(lazypath)

local plugins = {

	{
		"EdenEast/nightfox.nvim",
		config = function ()
			vim.cmd([[colorscheme terafox]])
		end
	},

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
				},
				sections = {
					lualine_x = {
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = { fg = "#ff9e64" },
						},
					},
				},
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
					path_display = function(_, path)
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

	{
		"sindrets/diffview.nvim",
		config = function ()
			if vconfig.plugin.diffview_config then
				require("diffview").setup(vconfig.plugin.diffview_config)
			else
				require("diffview").setup()
			end
		end
	},

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
				ensure_installed = { "c", "lua", "python", "cpp", "vim" },
				sync_install = false,
				highlight = {
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

	{
		"folke/neodev.nvim",
		enabled = vconfig.plugin.neodev_enabled
	},

	 { "ms-jpq/coq_nvim", enabled = false, setup = require('vd.lspsetup').setup_coq },
	 { 'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'onsails/lspkind.nvim',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-nvim-lsp',
			{
				'L3MON4D3/LuaSnip',
				dependencies = {'honza/vim-snippets'},
				config = function()
					require("luasnip").config.set_config({
					enable_autosnippets = true,
					updateevents = "TextChanged,TextChangedI",
					store_selection_keys = "<Tab>",
					ext_opts = {
						[require("luasnip.util.types").choiceNode] = {
							active = {
								virt_text = { { "●", "GruvboxOrange" } },
							},
						}
					}
				})
				require("luasnip.loaders.from_snipmate").lazy_load() -- Loads 'Snippets' folder in RTP
				require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/lua_snippets"}) -- Loads lua_snippets in cfg
				end
			},
			'saadparwaiz1/cmp_luasnip'
		},
		config = require('vd.lspsetup').config_nvimcmp
	},

	{ "williamboman/mason.nvim", enabled = vconfig.plugin.mason_enabled },
	{ "williamboman/mason-lspconfig.nvim", enabled = vconfig.plugin.mason_enabled },
	{ "neovim/nvim-lspconfig", config = require('vd.lspsetup').config_lspconfig },

	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		enabled = vconfig.plugin.neorg_enabled,
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
			require"fidget".setup{
				ui = {
					-- currently only round theme
					theme = 'moon',
				}
			}
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
	{
		"aserowy/tmux.nvim",
		config = function ()
			require("tmux").setup{
				navigation = {
					cycle_navigation = false,
				},
				copy_sync = {
					enable = false,
					redirect_to_clipboard = false
				}
			}
			require("vd.keymaps").tmux_keymaps()
		end
	},

	{
		'glepnir/lspsaga.nvim',
		branch = "main",
		config = function ()
			require("lspsaga").setup({
				lightbulb = {
					enable = false
				},
			})
		end
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function ()
			local null_ls = require("null-ls")

			local srcs = {
				null_ls.builtins.code_actions.gitsigns,
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.diagnostics.cppcheck,
			}

			local addn_srcs = vconfig.get_addn_nulls_srcs()
			if addn_srcs then
				srcs = vim.tbl_extend("force",srcs, addn_srcs)
			end

			null_ls.setup({
				sources = srcs
			})
		end
	},

	{
		'folke/zen-mode.nvim',
		config = function()
			require('zen-mode').setup()
		end,
		 keys = {
			 { "<leader>z", "<cmd>ZenMode<cr>", desc = "NeoTree" },
		 },
		dependencies = {
			{ 'folke/twilight.nvim', config = function() require('twilight').setup() end }
		},
		cmd = 'ZenMode'
	},
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
	diff = {
		cmd = "diffview.nvim"
	}
}

require("lazy").setup(plugins, opt)
require("vd.keymaps").lazy_keymaps()
