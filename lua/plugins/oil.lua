return {
    'stevearc/oil.nvim',
    config = function()
        require("oil").setup {
            keymaps = {
                ["<C-h>"] = false,
            }
        }
        vim.keymap.set("n", "-", "<CMD>Oil --float<CR>")
    end
}
