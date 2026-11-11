vim.pack.add { "https://github.com/neanias/everforest-nvim" }
require("everforest").setup({
    italics = true,
    ui_contrast = "high",
    on_highlights = function(hl, palette)
        hl.DiagnosticError = { fg = palette.none, bg = palette.none, sp = palette.red }
        hl.DiagnosticWarn = { fg = palette.none, bg = palette.none, sp = palette.yellow }
        hl.DiagnosticInfo = { fg = palette.none, bg = palette.none, sp = palette.blue }
        hl.DiagnosticHint = { fg = palette.none, bg = palette.none, sp = palette.green }
  end,
})
vim.cmd.colorscheme("everforest")
