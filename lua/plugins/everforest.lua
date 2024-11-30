return {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.everforest_background = "hard" -- Choose 'hard', 'medium', or 'soft'
        vim.g.everforest_enable_italic = 1
        vim.g.everforest_disable_italic_comment = 0
        vim.g.everforest_diagnostic_text_highlight = 1
        vim.g.everforest_diagnostic_line_highlight = 1
        vim.g.everforest_diagnostic_virtual_text = "colored"

        vim.cmd("colorscheme everforest") -- Apply the colorscheme

        -- local palette = {
        --     red = "#e67e80",
        --     bg_red = "#514045", -- Example for a red background
        -- }

        -- vim.api.nvim_set_hl(0, "HoverBorder", { fg = palette.red })
        -- vim.api.nvim_set_hl(0, "LspInfoBorder", { fg = palette.red })
        -- vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = palette.red })
        -- vim.api.nvim_set_hl(0, "FloatBorder", { fg = palette.red })
        -- vim.api.nvim_set_hl(0, "NormalFloat", { fg = palette.red })
        -- vim.api.nvim_set_hl(0, "StatusLine", { bg = palette.bg_red, fg = palette.red })

        -- require("everforest").setup({
        --     background = "hard",
        --     on_highlights = function(hl, palette)
        --         hl.HoverBorder = { fg = palette.red }
        --         hl.LspInfoBorder = { fg = palette.red }
        --         hl.TelescopeBorder = { fg = palette.red }
        --         hl.FloatBorder = { fg = palette.red }
        --         hl.StatusLine = { bg = palette.bg_red, fg = palette.red }
        --     end
        -- })

        -- require("everforest").load()
    end,
}
