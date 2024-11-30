return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim', "nvim-telescope/telescope-frecency.nvim", 'nvim-telescope/telescope-ui-select.nvim' },
    extensions = { 'ui-select' },
    config = function()
        local builtin = require('telescope.builtin')

        require('telescope').setup({
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                    }
                },
            },
        })

        require("telescope").load_extension("ui-select")

        vim.keymap.set('n', "<leader>ff", builtin.find_files)
        vim.keymap.set('n', "<leader>lg", builtin.live_grep)
        vim.keymap.set('n', "<leader>gs", builtin.grep_string)
        vim.keymap.set('n', "<leader>bb", builtin.buffers)
        vim.keymap.set('n', "<leader>tt", builtin.treesitter)

        vim.keymap.set('n', "gr", builtin.lsp_references)
        vim.keymap.set('n', "gi", builtin.lsp_implementations)
        vim.keymap.set('n', "gd", builtin.lsp_definitions)
        vim.keymap.set('n', "gt", builtin.lsp_type_definitions)
    end
}
