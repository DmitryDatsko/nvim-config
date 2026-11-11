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
vim.o.mouse = ""
vim.o.clipboard = "unnamedplus"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true

vim.o.linebreak = true
vim.o.breakindent = true
vim.o.scrolloff = 10

vim.o.signcolumn = "yes"
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.winborder = "rounded"

vim.o.pumheight = 10
vim.o.pumblend = 10
vim.o.showmatch = true
vim.o.matchtime = 2
vim.o.title = true
vim.opt.fillchars:append({ diff = "/" })

vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.path:append("**")
vim.o.wildmode = "longest:full,full"
vim.o.wildignore = "*/node_modules/*,*.o,*.obj,*.pyc,*.class,*.jar"

vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~/.cache/nvim/undodir")

vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 0

vim.o.splitbelow = true
vim.o.splitright = true

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
