return {
    'nvim-treesitter/nvim-treesitter',
    -- dependencies = {
    --     'nvim-treesitter/nvim-treesitter-textobjects',
    -- },
    build = ':TSUpdate',

    config = vim.defer_fn(function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'haskell', 'zig' },

            auto_install = false,

            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Tab>", -- set to `false` to disable one of the mappings
                    node_incremental = "<Tab>",
                    node_decremental = "<S-Tab>",
                },
            },
        }
    end, 0)

}
