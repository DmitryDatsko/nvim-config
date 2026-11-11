vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.WARN] = "󰊠 ",
            [vim.diagnostic.severity.ERROR] = "󰊠 ",
            [vim.diagnostic.severity.INFO] = "󰊠 ",
            [vim.diagnostic.severity.HINT] = "󰊠 ",
        },
    },
})
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.scrolloff = 10

vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.winborder = "rounded"

vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.title = true
vim.opt.fillchars:append({ diff = "/" })

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.path:append("**")
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore = { "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" }

vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")

vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0

vim.opt.splitbelow = true
vim.opt.splitright = true

require("vim._core.ui2").enable({
	msg = {
		target = "msg",
		targets = {
			emsg = "pager",
			echoerr = "pager",
			lua_error = "pager",
			rpc_error = "pager",
			list_cmd = "pager",
			verbose = "pager",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "pager",
			progress = "pager",
			search_count = "cmd",
			search_cmd = "cmd",
			completion = "cmd",
			wildlist = "cmd",
			confirm = "cmd",
			typed_cmd = "cmd",
		},
		msg = { height = 0.3, timeout = 5000 },
		pager = { height = 0.5 },
	},
})
