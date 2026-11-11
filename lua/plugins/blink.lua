vim.pack.add({
	"https://github.com/rafamadriz/friendly-snippets",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
})

require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},

	appearance = {
		nerd_font_variant = "mono", -- Nerd Font Mono
	},

	sources = {
		default = { "lsp", "path", "snippets" },
	},

	completion = {
		list = {
			selection = { preselect = true, auto_insert = false },
		},
		accept = {
			auto_brackets = { enabled = true },
		},
		menu = {
			border = "single",
			max_height = 15,
			draw = {
				columns = {
					{ "label" },
					{ "kind_icon", "kind", gap = 1 },
					{ "label_description" },
				},
				components = {
					kind_icon = {
						ellipsis = false,
						text = function(ctx)
							local icon = require("mini.icons").get("lsp", ctx.kind)
							return icon
						end,
						highlight = function(ctx)
							local _, hl = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
					kind = {
						highlight = function(ctx)
							local _, hl = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
				},
			},
		},
		documentation = {
			auto_show = true,
			window = { border = "single" },
		},
	},

	signature = { enabled = true, window = { border = "single" } },
})

-- capabilities for all LSP-servers, including roslyn
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})
