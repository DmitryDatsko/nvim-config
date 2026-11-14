vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "Hightlight selection on yank",
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("RoslynFeatures", { clear = true }),
	desc = "Enable Roslyn inlay hints and code lenses",
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client or client.name ~= "roslyn" then
			return
		end
		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
		if client:supports_method("textDocument/codeLens") then
			vim.lsp.codelens.enable(true, { bufnr = ev.buf })
		end
	end,
})

local files = require("mini.files")
local function synchronize_files()
	local before = {}
	for _, buffer in ipairs(vim.fn.getbufinfo()) do
		before[buffer.bufnr] = buffer
	end

	if not files.synchronize() then
		return
	end

	-- Save changes from this sync without committing earlier unsaved work.
	for _, buffer in ipairs(vim.fn.getbufinfo({ bufmodified = 1 })) do
		local previous = before[buffer.bufnr]
		if
			vim.bo[buffer.bufnr].buftype == ""
			and buffer.name ~= ""
			and (not previous or buffer.changedtick ~= previous.changedtick)
		then
			if previous and previous.changed == 1 then
				vim.notify("Not auto-saving previously modified file: " .. buffer.name, vim.log.levels.WARN)
			else
				local ok, err = pcall(vim.api.nvim_buf_call, buffer.bufnr, function()
					vim.cmd.update({ mods = { silent = true } })
				end)
				if not ok then
					vim.notify(err, vim.log.levels.ERROR)
				end
			end
		end
	end
end

vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("MiniFilesSync", { clear = true }),
	pattern = "MiniFilesBufferCreate",
	callback = function(event)
		vim.keymap.set("n", "=", synchronize_files, {
			buffer = event.data.buf_id,
			silent = true,
			desc = "Synchronize files and save LSP edits",
		})
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.opt_local.formatoptions:remove({ "o", "r" })
	end,
})
