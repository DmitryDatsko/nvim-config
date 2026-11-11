vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local wk = require("which-key")
wk.setup({
    preset = "helix",
    delay = 300,
    win = {
        padding = { 1, 2 },
    },
    filter = function(mapping)
        return mapping.desc and mapping.desc ~= ""
    end,
})

vim.keymap.set("n", "<leader>?", function()
    wk.show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })
