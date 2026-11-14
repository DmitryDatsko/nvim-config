vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/NicholasMata/nvim-dap-cs" },
})

local dap = require("dap")
local dapui = require("dapui")

require("dapui").setup()
require("dap-cs").setup()

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

vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start or continue debugging" })
vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Stop debugging" })
vim.keymap.set("n", "<C-S-F5>", dap.restart, { desc = "Restart debugging" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step into" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Step out" })
