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
            }
        })

        -- ステップ2: 次にmason-lspconfig.nvimをセットアップする
        require("mason-lspconfig").setup()

        -- LSP設定の共通部分を定義
        local lspconfig = require("lspconfig")
        local on_attach = function(client, bufnr)
            -- フォーマット機能
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("LspFormatting", {}),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = true })
                    end,
                })
            end
        end

        -- 各言語のLSPサーバーを有効化
        lspconfig.rust_analyzer.setup({ on_attach = on_attach })
        lspconfig.pyright.setup({ on_attach = on_attach })
        lspconfig.tsserver.setup({ on_attach = on_attach })
        lspconfig.lua_ls.setup({ on_attach = on_attach })
    end, }
