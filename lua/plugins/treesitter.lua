vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").install({
    "astro",
    "bash",
    "c",
    "cmake",
    "cpp",
    "css",
    "diff",
    "fish",
    "gitignore",
    "go",
    "graphql",
    "html",
    "http",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "php",
    "printf",
    "python",
    "query",
    "regex",
    "rust",
    "scss",
    "sql",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "dockerfile",
    "c_sharp",
    "razor",
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("Treesitter", { clear = true }),
    callback = function(ev)
        if not vim.treesitter.get_parser(ev.buf) then
            return
        end
        vim.treesitter.start(ev.buf)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldlevel = 99
    end,
})
