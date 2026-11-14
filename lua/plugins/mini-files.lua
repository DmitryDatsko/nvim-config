vim.pack.add({ "https://github.com/nvim-mini/mini.files" })

local files = require("mini.files")
files.setup({})
vim.keymap.set("n", "<leader>e", files.open, { silent = true, desc = "Open file explorer" })
