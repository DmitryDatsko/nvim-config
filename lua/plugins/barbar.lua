vim.pack.add({ "https://github.com/romgrk/barbar.nvim" })

require("barbar").setup({
	animation = true,
	auto_hide = false,
	tabpages = true,
	clickable = false,
	focus_on_close = "previous",
	insert_at_end = true,
	hide = { extensions = true },
	highlight_alternate = false,
	highlight_visible = false,
	highlight_inactive_file_icons = true,
	maximum_padding = 1,
	minimum_padding = 1,
	maximum_length = 20,
	semantic_letters = true,
	icons = {
		preset = "default",
		buffer_index = false,
		buffer_number = false,
		button = "",
		modified = { button = "" },
		pinned = { button = "" },
		inactive = { button = "" },
		separator = { left = "▎", right = "" },
		separator_at_end = false,
		filetype = { enabled = true, custom_colors = false },
		diagnostics = {
			[vim.diagnostic.severity.ERROR] = { enabled = true },
			[vim.diagnostic.severity.WARN] = { enabled = true },
			[vim.diagnostic.severity.INFO] = { enabled = false },
			[vim.diagnostic.severity.HINT] = { enabled = false },
		},
		gitsigns = {
			added = { enabled = false },
			changed = { enabled = false },
			deleted = { enabled = false },
		},
	},
})

vim.keymap.set("n", "<Tab>", "<Cmd>BufferNext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bp", "<Cmd>BufferPick<CR>", { silent = true, desc = "Pick buffer" })
vim.keymap.set("n", "<leader>b<", "<Cmd>BufferMovePrevious<CR>", { silent = true, desc = "Move buffer left" })
vim.keymap.set("n", "<leader>b>", "<Cmd>BufferMoveNext<CR>", { silent = true, desc = "Move buffer right" })
vim.keymap.set("n", "<leader>bd", "<Cmd>BufferClose<CR>", { silent = true, desc = "Close buffer" })
vim.keymap.set("n", "<leader>bu", "<Cmd>BufferRestore<CR>", { silent = true, desc = "Restore last closed buffer" })
