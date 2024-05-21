local vconfig = require("config_enable")
local vautocmds = require("vd.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"jbyuki/one-small-step-for-vimkind",
		},
		config = function()
			require("dapui").setup()

			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			dap.configurations.lua = {
				{
					type = 'nlua',
					request = 'attach',
					name = "Attach to running Neovim instance",
				}
			}

			dap.adapters.nlua = function(callback, config)
				callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
			end

			require('vd.keymaps').dap_keymaps()
		end
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end
	},

	{
		'mrcjkb/rustaceanvim',
		version = '^4', -- Recommended
		ft = { 'rust' },
	},

	{ "catppuccin/nvim", name = "catppuccin" },

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vautocmds.colorscheme_autocmds()
			-- vim.cmd("colorscheme kanagawa")
		end
	},

	{
		"dasupradyumna/midnight.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			vautocmds.colorscheme_autocmds()
			vim.cmd("colorscheme midnight")
		end
	},

	{
		'lukas-reineke/indent-blankline.nvim',
		event = { "BufReadPre", "BufNewFile" },
		main = "ibl",
		opts = {}
	},

	'wellle/targets.vim', -- Nice Plugin to add more selection

	'tpope/vim-unimpaired',

	{
		"ellisonleao/gruvbox.nvim",
		enabled = false,
		config = function()
			vim.o.background = "dark"
			-- vim.cmd([[colorscheme gruvbox]])
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- require("tokyonight").setup({
			-- 	style = "night",
			-- 	theme = 'tokyonight'
			-- })
			-- vim.cmd [[colorscheme tokyonight]]
		end
	},

	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function ()
			vim.cmd [[colorscheme everforest]]
		end
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}
	},

	{
		'nvim-lualine/lualine.nvim',
		event = "VeryLazy",
		dependencies = { 'kyazdani42/nvim-web-devicons' },
		config = function()
			require('lualine').setup {
				extensions = { 'quickfix' },
				options = {
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

			require("vd.autocmds").setup_dirchanged_autocmd()
		end
	},

	-- you can use the VeryLazy event for things that can
	-- load later and are not important for the initial UI
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	{
		"rcarriga/nvim-notify",
		enabled = false,
		event = "VeryLazy",
		config = function()
			vim.notify = require("notify")
		end
	},

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			{ "nvim-lua/plenary.nvim",                       lazy = true },
			{ "nvim-telescope/telescope-file-browser.nvim" },
			-- {'nvim-telescope/telescope-ui-select.nvim'},
			{ 'nvim-telescope/telescope-fzf-native.nvim',    build = 'make' },
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
		config = function()
			local telescopeConfig = require("telescope.config")

			local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

			table.insert(vimgrep_arguments, "--hidden")
			table.insert(vimgrep_arguments, "--glob")
			table.insert(vimgrep_arguments, "!{**/.git/*,**/.cache/*}")
			table.insert(vimgrep_arguments, "-L")

			require('telescope').setup {
				defaults = {
					vimgrep_arguments = vimgrep_arguments,
					winblend = 20,
					path_display = function(_, path)
						local tutils = require("telescope.utils")
						local tail = tutils.path_tail(path)
						local head = vim.fn.fnamemodify(path, ":~:h")
						-- head = (head == '.') and '' or '('..head..')'
						if head == '.' then
							head = ''
						else
							local get_status = require('telescope.state').get_status
							local status = get_status(vim.api.nvim_get_current_buf())
							local len = vim.api.nvim_win_get_width(status.results_win) - string.len(tail) - 7
							head = require('plenary.strings').truncate(head, len, nil, -1)
							head = '(' .. head .. ')'
							if string.sub(head, 1, 1) == '/' then
								head = head .. '/'
							end
						end
						return string.format("%s %s", tail, head)
					end,
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close
						},
					}
				},
				pickers = {
					find_files = {
						find_command = { "fd", "-L", "--type", "f", "--hidden", "--strip-cwd-prefix", "--exclude", ".git", "--exclude", ".cache" },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {}
					},
					["file_browser"] = {
						depth = 1,
						display_stat = false
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

	{
		'ThePrimeagen/harpoon',
		config = function()
			require('telescope').load_extension('harpoon')
		end,
		dependencies = { { 'ThePrimeagen/harpoon', lazy = true } },
		keys = {
			{
				",ae",
				function()
					vim.cmd("lua require('harpoon.mark').add_file()")
					vim.notify("Harpooned")
				end,
				desc = "Add Harpoon Mark"
			},
			{ ",e", "<cmd>Telescope harpoon marks<cr>", desc = "Show Harpoon Marks" },
		},
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require('Comment').setup()
		end
	},

	"tpope/vim-surround",

	{
		'NeogitOrg/neogit',
		branch = "nightly",
		dependencies = 'nvim-lua/plenary.nvim',
		cmd = 'Neogit',
		config = function()
			require('neogit').setup {
				integrations = { diffview = true },
			}
		end
	},

	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		keys = require('vd.keymaps').diffview_keymaps(),
		config = function()
			local actions = require("diffview.actions")
			local config = {
				keymaps = {
					view = {
						{ "n", "<c-u>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
						{ "n", "<c-d>", actions.scroll_view(0.25),  { desc = "Scroll the view down" } },
						{ "n", ",t",    actions.toggle_files,       { desc = "Toggle the file panel" } }
					},
					file_panel = {
						{ "n", "<c-u>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
						{ "n", "<c-d>", actions.scroll_view(0.25),  { desc = "Scroll the view down" } },
						{ "n", ",t",    actions.toggle_files,       { desc = "Toggle the file panel" } }
					}
				}
			}
			local c = vim.tbl_deep_extend("force", config, vconfig.plugin.diffview_config)
			require("diffview").setup(c)
		end
	},

	{
		'lewis6991/gitsigns.nvim',
		tag = 'release',
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require('gitsigns').setup()
			require('vd.keymaps').gitsigns_keymaps()
		end
	},

	{
		'akinsho/bufferline.nvim',
		event = "VeryLazy",
		version = "*",
		dependencies = 'kyazdani42/nvim-web-devicons',
		opts = {
			-- Options are passed as require('bufferline').setup(opts)
			options = {
				separator_style = "slant",
				numbers = "ordinal",
				diagnostics = "nvim_lsp"
			}
		}
	},

	{
		'nvim-treesitter/nvim-treesitter',
		event = 'BufReadPost',
		build = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
		config = function()
			require 'nvim-treesitter.configs'.setup {
				ensure_installed = { "c", "lua", "python", "cpp", "vim", "markdown", "vimdoc", "markdown_inline" },
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

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = 'BufRead',
		config = function()
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
		end
	},

	{
		"folke/neodev.nvim",
		enabled = vconfig.plugin.neodev_enabled
	},

	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'onsails/lspkind.nvim',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-nvim-lsp',
			{
				'L3MON4D3/LuaSnip',
				version = "v1.*",
				dependencies = { 'honza/vim-snippets' },
				config = function()
					require("luasnip").config.set_config({
						enable_autosnippets = true,
						updateevents = "TextChanged,TextChangedI",
						delete_check_events = "TextChanged",
						store_selection_keys = "<Tab>",
						ext_opts = {
							[require("luasnip.util.types").choiceNode] = {
								active = {
									virt_text = { { "●", "GruvboxOrange" } },
								},
							}
						}
					})
					require("luasnip.loaders.from_snipmate").lazy_load()                      -- Loads 'Snippets' folder in RTP
					require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua_snippets" }) -- Loads lua_snippets in cfg
				end
			},
			'saadparwaiz1/cmp_luasnip'
		},
		config = require('vd.lspsetup').config_nvimcmp
	},

	{ "williamboman/mason.nvim",           enabled = vconfig.plugin.mason_enabled },
	{ "williamboman/mason-lspconfig.nvim", enabled = vconfig.plugin.mason_enabled },
	{ "neovim/nvim-lspconfig",             config = require('vd.lspsetup').config_lspconfig },

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
		opts = {}
	},

	{ "chrisbra/csv.vim",         ft = { "csv" } },

	-- SessionLoad
	-- SessionSave
	-- SessionStop
	{
		'natecraddock/sessions.nvim',
		config = function()
			require("sessions").setup({
				session_filepath = "./.session",
			})

			require("vd.autocmds").au_session()
		end
	},


	{ 'dstein64/vim-startuptime', enabled = false },

	-- TODO: Resize support
	{
		"aserowy/tmux.nvim",
		event = "VeryLazy",
		config = function()
			require("tmux").setup {
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
		event = "BufRead",
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					enable = false
				},
				scroll_preview = {
					scroll_down = "<C-d>",
					scroll_up = "<C-u>"
				}
			})
		end,
		keys = {
			{ ",lr",  "<cmd>Lspsaga lsp_finder<cr>",            desc = "Saga lsp_finder" },
			{ ",lo",  "<cmd>Lspsaga outline<cr>",               desc = "Saga outline" },
			{ ",lk",  "<cmd>Lspsaga hover_doc<cr>",             desc = "Saga hover" },
			{ ",ld",  "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Show line diagnostics" },
			{ ",lca", "<cmd>Lspsaga code_action<cr>",           desc = "Show line diagnostics" },
		},
		dependencies = { 'kyazdani42/nvim-web-devicons' },
	},

	{ "nvim-treesitter/nvim-treesitter-context" },

	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

			local srcs = {
				null_ls.builtins.code_actions.gitsigns,
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.diagnostics.cppcheck,
			}

			local addn_srcs = vconfig.get_addn_nulls_srcs()
			if addn_srcs then
				srcs = vim.tbl_extend("force", srcs, addn_srcs)
			end

			null_ls.setup({
				on_init = function(new_client, _)
					new_client.offset_encoding = 'utf-32'
				end,
				sources = srcs
			})
		end
	},

	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					rust = { "rustfmt" }

				},
			})

			require("vd.keymaps").conform_keymaps(conform)
		end,
	},

	{
		'folke/zen-mode.nvim',
		config = function()
			require('zen-mode').setup()
		end,
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "ZenMode" },
		},
		dependencies = {
			{ 'folke/twilight.nvim', config = function() require('twilight').setup() end }
		},
		cmd = 'ZenMode'
	},

	{
		"luukvbaal/statuscol.nvim",
		config = function()
			require('statuscol').setup()
		end
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}
	},

	{
		"vignesh0025/nvim-todo-toggle-comment",
		config = function ()
			require("nvim-todo-toggle-comment").setup()
		end,
		dev = false
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
	diff = {
		cmd = "diffview.nvim"
	}
}

require("lazy").setup(plugins, opt)
require("vd.keymaps").lazy_keymaps()
