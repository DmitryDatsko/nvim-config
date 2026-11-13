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
local keymap = vim.keymap

local map = function(keymaps)
	for _, keymap_entry in ipairs(keymaps) do
		local lhs = keymap_entry[1]
		local rhs = keymap_entry[2]
		local mode = keymap_entry.mode or "n"
		local opts = {
			desc = keymap_entry.desc,
			silent = keymap_entry.silent ~= false,
			noremap = keymap_entry.noremap ~= false,
			expr = keymap_entry.expr,
			nowait = keymap_entry.nowait,
			buffer = keymap_entry.buffer,
		}
		keymap.set(mode, lhs, rhs, opts)
	end
end

local picker = require("snacks").picker

-- LSP
map({
	{ "gI", picker.lsp_implementations, desc = "Goto Source Definition / Implementation" },
	{
		"gd",
		function()
			picker.lsp_definitions({ jump = { reuse_win = false } })
		end,
		desc = "LSP Goto Definition",
	},
	{ "gD", picker.lsp_declarations, desc = "LSP Goto Declaration" },
	{ "gy", picker.lsp_type_definitions, desc = "LSP Goto T[y]pe Definition" },
	{ "gr", picker.lsp_references, desc = "LSP Goto References" },
	{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
	{ "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "i" },
{
       "<C-j>",
       function()
           vim.diagnostic.jump({
               count = 1,
               on_jump = function(diagnostic, bufnr)
                   if diagnostic then
                       vim.diagnostic.open_float({
                           bufnr = bufnr,
                           scope = "cursor",
                           focus = false,
                       })
                   end
               end,
           })
       end,
       desc = "Jump to next diagnostic",
   },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" } },
	{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
})

-- Snacks
map({
	{ "<leader>cl", picker.lsp_config, desc = "Lsp Info" },
	{ "<leader>cR", function() require("snacks").rename.rename_file() end, desc = "Rename File" },
	{ ";f", picker.files, desc = "Find files"},
	{ ";r", picker.grep, desc = "Live grep" },
	{ ";;", picker.resume, desc = "Resume picker" },
{
       "\\\\",
       function()
           picker.buffers({ confirm = "drop" })
       end,
       desc = "List buffers",
   },
	{ ";e", picker.diagnostics, desc = "Diagnostics" },
	{ ";c", picker.lsp_incoming_calls, desc = "LSP incoming calls" },
	{ ";n", picker.notifications, desc = "Notifications" },
	{ ";h", picker.git_diff, desc = "Git diff hunks" },
	{
		";s",
		function()
			picker.lsp_symbols()
		end,
		desc = "list of buffer symbols",
	},
	{
		";w",
		function()
			picker.lsp_workspace_symbols()
		end,
		desc = "List of workspace symbols",
	},
})
