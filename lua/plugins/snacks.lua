vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
	picker = {
		enabled = true,
		sources = {
			files = { hidden = true },
			grep = { hidden = true },
		},
	},
	notifier = { enabled = true },
})

local picker = require("snacks").picker
vim.keymap.set("n", ";f", picker.files, { silent = true, desc = "Find files including hidden" })
vim.keymap.set("n", ";r", picker.grep, { silent = true, desc = "Live grep including hidden files" })
vim.keymap.set("n", ";;", picker.resume, { silent = true, desc = "Resume last picker" })
vim.keymap.set("n", "\\\\", picker.buffers, { silent = true, desc = "List open buffers" })
vim.keymap.set("n", ";e", picker.diagnostics, { silent = true, desc = "List diagnostics" })
vim.keymap.set("n", ";n", picker.notifications, { silent = true, desc = "Notification history" })
vim.keymap.set("n", ";h", picker.git_diff, { silent = true, desc = "Git diff hunks" })
vim.keymap.set("n", ";s", function() picker.lsp_symbols() end, { silent = true, desc = "List of buffer symbols" })
vim.keymap.set("n", ";w", function() picker.lsp_workspace_symbols() end, { silent = true, desc = "List of workspace symbols" })
