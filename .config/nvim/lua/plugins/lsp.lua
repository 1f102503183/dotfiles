-- lua/plugins/lsp.lua (修正版)
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
    require("mason").setup()
    
    -- ステップ2: 次にmason-lspconfig.nvimをセットアップする
    require("mason-lspconfig").setup()
    
    -- ここに各言語のLSP設定を記述する
    local lspconfig = require("lspconfig")
    
    -- 例: RustのLSPを有効化
    lspconfig.rust_analyzer.setup({})
    
    -- 例: TypeScriptのLSPを有効化
    lspconfig.tsserver.setup({})

    -- JavaのLSP設定をここに追加
    lspconfig.jdtls.setup({})

  end,
}
