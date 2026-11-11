vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterFolds", { clear = true }),
    callback = function(ev)
        if not vim.treesitter.get_parser(ev.buf) then
            return
        end
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldlevel = 99
    end,
})
