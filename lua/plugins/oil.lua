return {
    'stevearc/oil.nvim',
    config = function()
        require("oil").setup {
            keymaps = {
                ["<C-h>"] = false,
            },
            view_options = {
                show_hidden = true
            }
        }
        vim.keymap.set("n", "-", "<CMD>Oil --float<CR>")
    end
}
