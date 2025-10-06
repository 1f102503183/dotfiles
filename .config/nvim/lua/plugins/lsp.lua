return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- 補完機能
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",

        -- LSPサーバー管理
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        -- ステップ1: まずmason.nvimをセットアップする
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            },
            ensure_installed = {
                "lua_ls",
                "rust-analyzer",
                "pyright",
                "typescript-language-server",
                "jdtls",
                "html",
                "cssls",
                "prettier",
            }
        })

        -- ステップ2: 次にmason-lspconfig.nvimをセットアップする
        require("mason-lspconfig").setup()

        -- LSP設定の共通部分を定義
        local lspconfig = require("lspconfig")
        local on_attach = function(client, bufnr)
            -- Formatting Autocommand (already there)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("LspFormatting", {}),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = true })
                    end,
                })
            end

            -- Keymaps for LSP functionality
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)          -- Go to Definition
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                -- Show documentation
            vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts) -- Code Actions

            -- Diagnostics (real-time error display)
            -- This sets up the visual cues for errors and warnings
            vim.diagnostic.config({
                signs = true,
                virtual_text = true,
                underline = true,
                update_in_insert = false,
            }, bufnr)
        end

        -- 各言語のLSPサーバーを有効化
        lspconfig.rust_analyzer.setup({ on_attach = on_attach })
        lspconfig.pyright.setup({ on_attach = on_attach })
        lspconfig.ts_ls.setup({ on_attach = on_attach })
        lspconfig.lua_ls.setup({ on_attach = on_attach })
        lspconfig.html.setup({ on_attach = on_attach })
        lspconfig.cssls.setup({ on_attach = on_attach })
    end,
}
