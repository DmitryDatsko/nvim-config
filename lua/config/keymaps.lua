local map = vim.keymap.set

map("n", "<ESC>", ":nohl<CR>", { desc = "clear search highlights", silent = true })
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("x", "<leader>/", "gc", { desc = "toggle comment", remap = true })

map("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })

map("n", "n", "nzzzv", { desc = "Next match, center and open fold" })
map("n", "N", "Nzzzv", { desc = "Previous match, center and open fold" })

map("v", "<", "<gv", { silent = true, desc = "Indent left, keep selection" })
map("v", ">", ">gv", { silent = true, desc = "Indent right, keep selection" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>ss", "<Cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<C-w>h", { desc = "Window left" })
map("n", "<leader>sj", "<C-w>j", { desc = "Window below" })
map("n", "<leader>sk", "<C-w>k", { desc = "Window above" })
map("n", "<leader>sl", "<C-w>l", { desc = "Window right" })

map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Disable keyboard arrows
map({ "n", "i", "x" }, "<Up>", "<Nop>", { desc = "Disable Up arrow" })
map({ "n", "i", "x" }, "<Down>", "<Nop>", { desc = "Disable Down arrow" })
map({ "n", "i", "x" }, "<Left>", "<Nop>", { desc = "Disable Left arrow" })
map({ "n", "i", "x" }, "<Right>", "<Nop>", { desc = "Disable Right arrow" })
