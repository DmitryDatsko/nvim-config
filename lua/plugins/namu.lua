vim.pack.add({ "https://github.com/bassamsdata/namu.nvim" })

require("namu").setup({
	namu_symbols = {
		enable = true,
		options = {
			display = {
				format = "tree_guides",
				mode = "icon",
				padding = 2,
			},
			AllowKinds = {
				default = {
					"Function",
					"Method",
					"Class",
					"Module",
					"Property",
					"Variable",
				},
			},
			window = {
				auto_size = true,
				border = vim.o.winborder,
			},
			preview = {
				highlight_on_move = true,
			},
			movement = {
				next = { "<C-n>", "<Down>" },
				previous = { "<C-p>", "<Up>" },
				close = { "<Esc>" },
				select = { "<CR>" },
				delete_word = {},
				clear_line = {},
			},
		},
	},
	ui_select = { enable = false },
})

vim.keymap.set("n", "<leader>ns", "<Cmd>Namu symbols<CR>", { desc = "LSP symbols (buffer)" })
vim.keymap.set("n", "<leader>nw", "<Cmd>Namu workspace<CR>", { desc = "LSP symbols (workspace)" })
vim.keymap.set("n", "<leader>nb", "<Cmd>Namu watchtower<CR>", { desc = "Symbols across open buffers" })
vim.keymap.set("n", "<leader>nd", "<Cmd>Namu diagnostics<CR>", { desc = "Diagnostics for buffer or workspace" })
