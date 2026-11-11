vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("PackHooks", { clear = true }),
    desc = "Update tree-sitter parsers after plugin changes",
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name ~= "nvim-treesitter" or (kind ~= "install" and kind ~= "update") then
            return
        end
        if not ev.data.active then
            vim.cmd.packadd(name)
        end
        vim.cmd.TSUpdate()
    end,
})
