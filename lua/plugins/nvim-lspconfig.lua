local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

return {
    'neovim/nvim-lspconfig',
    dependencies = {
        {
            'williamboman/mason.nvim',
            opts = {
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"

                    }
                }
            }
        },
        {
            'williamboman/mason-lspconfig.nvim',
            opts = {
                ensure_installed = {
                    "rust_analyzer", "lua_ls", "clangd", "hls", "zls"
                },
                handlers = {

                    ["rust_analyzer"] = function()
                        require("lspconfig")["rust_analyzer"].setup {
                            capabilities = capabilities,
                            settings = {
                                ["rust-analyzer"] = {
                                    cargo = {
                                        allFeatures = true,
                                    },
                                },
                            },
                        }
                    end,
                    ["lua_ls"] = function()
                        require("lspconfig")["lua_ls"].setup {
                            settings = {
                                workspace = { checkThirdParty = false },
                                telemetry = { enable = false }
                            },
                            capabilities = capabilities
                        }
                    end,
                    ["clangd"] = function()
                        require("lspconfig")["clangd"].setup {
                            capabilities = capabilities
                        }
                    end,
                    ["hls"] = function()
                        require("lspconfig")["hls"].setup {
                            capabilities = capabilities
                        }
                    end,
                    ["zls"] = function()
                        require("lspconfig")["zls"].setup {
                            capabilities = capabilities
                        }
                    end
                },

            }

        },
        {
            'j-hui/fidget.nvim',
            tag = "v1.0.0",
            opts = {
                notification = { window = { border = "rounded" } } }
        },
    },

    -- opts = {
    --     diagnostics = {
    --         float = {
    --             border = "rounded",
    --         },
    --     },
    -- },
    -- opts = function(_, opts)
    --     -- keys go here
    --     opts.diagnostics = {
    --         float = {
    --             border = "rounded",
    --         },
    --     }
    -- end,

    config = function()
        require('lspconfig.ui.windows').default_options.border = 'rounded'
        -- require('lspconfig.diagnostics.float').

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
                border = "rounded",
            }
        )

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
            end,
        })
    end

}
