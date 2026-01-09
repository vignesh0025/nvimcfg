return {
	"saghen/blink.cmp",
	dependencies = { "fang2hou/blink-copilot" },
	enabled = true,
	version = '1.*',
	opts = {
		keymap = { preset = 'super-tab' },
		sources = {
			default = { "copilot",'lsp', 'buffer', 'snippets', 'path'  },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},
	}
}
