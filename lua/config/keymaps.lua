local map = vim.keymap.set

map("n", "<ESC>", ":nohl<CR>", { desc = "clear search highlights", silent = true })
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("x", "<leader>/", "gc", { desc = "toggle comment", remap = true })

map("n", "n", "nzzzv", { desc = "Next match, center and open fold" })
map("n", "N", "Nzzzv", { desc = "Previous match, center and open fold" })

map("v", "<", "<gv", { silent = true, desc = "Indent left, keep selection" })
map("v", ">", ">gv", {silent = true, desc = "Indent right, keep selection" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

vim.keymap.set("n", "<leader>te", "<Cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tx", "<Cmd>tabclose<CR>", { desc = "Close tab" })

vim.keymap.set("n", "<leader>ss", "<Cmd>split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>sh", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<leader>sj", "<C-w>j", { desc = "Window below" })
vim.keymap.set("n", "<leader>sk", "<C-w>k", { desc = "Window above" })
vim.keymap.set("n", "<leader>sl", "<C-w>l", { desc = "Window right" })

-- Disable keyboard arrows
vim.keymap.set({ "n", "i", "x" }, "<Up>", "<Nop>", { desc = "Disable Up arrow" })
vim.keymap.set({ "n", "i", "x" }, "<Down>", "<Nop>", { desc = "Disable Down arrow" })
vim.keymap.set({ "n", "i", "x" }, "<Left>", "<Nop>", { desc = "Disable Left arrow" })
vim.keymap.set({ "n", "i", "x" }, "<Right>", "<Nop>", { desc = "Disable Right arrow" })
