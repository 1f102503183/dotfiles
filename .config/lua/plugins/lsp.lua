return {
  -------------------------------------------------------------
  -- 1. Mason プラグインとその連携プラグインの設定ブロック --
  -------------------------------------------------------------
  {
    'williamboman/mason.nvim',  -- (A) Masonプラグイン本体の指定
    dependencies = {            -- (B) Masonが依存する、または連携する他のプラグイン
      'williamboman/mason-lspconfig.nvim', -- Masonとnvim-lspconfigを連携させるプラグイン
      -- 他にも、formatter や linter の管理のための mason-tool-installer などが入ることもあります
    },
    config = function()         -- (C) Masonプラグインが読み込まれた後に実行される設定
      require('mason').setup()  -- (C-1) Masonプラグインの初期設定を実行

      -- (C-2) Masonとnvim-lspconfigの連携設定
      -- ここで、masonに「どのLSPサーバーを自動でインストールしてほしいか」を伝えます。
      require('mason-lspconfig').setup {
        ensure_installed = {    -- (C-2-a) これらのLSPサーバーを自動でインストールする
          'pyright',            -- Python用のLSPサーバー
          'html',               -- HTML用のLSPサーバー
          'cssls',              -- CSS用のLSPサーバー
          'tsserver',           -- JavaScript/TypeScript用のLSPサーバー
        },
      }
    end,
  },

  --------------------------------------------------
  -- 2. nvim-lspconfig プラグインの設定ブロック --
  --------------------------------------------------
  {
    'neovim/nvim-lspconfig',    -- (D) nvim-lspconfigプラグイン本体の指定
    dependencies = {            -- (E) nvim-lspconfigが依存する、または連携する他のプラグイン
      --'williamboman/mason-nvim-dap', -- デバッグツール (DAP) との連携プラグイン (これは任意で、LSP自体には必須ではありません)
    },
    config = function()         -- (F) nvim-lspconfigプラグインが読み込まれた後に実行される設定

      -- (F-1) 各LSPサーバーの基本的な設定
      -- ここで、各LSPサーバーをNeovimに「有効にする」と伝えます。
      -- 具体的なサーバーのパスなどは、mason-lspconfigがmason経由で自動的に解決してくれます。
      require('lspconfig').pyright.setup {}   -- Python (pyright) のLSPを有効化
      require('lspconfig').html.setup {}      -- HTMLのLSPを有効化
      require('lspconfig').cssls.setup {}     -- CSSのLSPを有効化
      require('lspconfig').tsserver.setup {}  -- JavaScript/TypeScriptのLSPを有効化

      -- (F-2) LSP機能に共通で適用される設定 (on_attach 関数)
      -- この関数は、LSPサーバーがファイルにアタッチ (接続) されたときに実行されます。
      -- 主に、LSPで提供される機能（定義へジャンプ、ホバー表示など）にキーマップを割り当てます。
      local on_attach = function(client, bufnr)
        -- 各LSP機能にキーマップを割り当てる例
        -- `bufnr` は現在のバッファ（ファイル）に限定するためのオプションです。
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition', buffer = bufnr }) -- 定義元へジャンプ
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to References', buffer = bufnr }) -- 参照箇所を検索
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation', buffer = bufnr })   -- カーソル下の要素のドキュメント表示
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename', buffer = bufnr })      -- 変数名などを一括リネーム
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action', buffer = bufnr }) -- コードアクション (エラー修正提案など)

        -- (F-3) ファイル保存時に自動フォーマット (任意)
        -- もしLSPサーバーがフォーマット機能に対応していれば、ファイル保存時に自動でコードを整形します。
        if client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', { -- ファイルを保存する直前に実行
                buffer = bufnr,                          -- 現在のバッファに限定
                callback = function()
                    vim.lsp.buf.format({ async = false }) -- フォーマットを実行 (async = false で同期的に実行)
                end,
            })
        end
      end

      -- (F-4) on_attach 関数を各LSPサーバーに適用
      -- 上で定義した on_attach 関数を、それぞれのLSPサーバーが起動するたびに実行するように設定します。
      require('lspconfig').pyright.setup({ on_attach = on_attach })
      require('lspconfig').html.setup({ on_attach = on_attach })
      require('lspconfig').cssls.setup({ on_attach = on_attach })
      require('lspconfig').tsserver.setup({ on_attach = on_attach })
    end,
  },

  --------------------------------------------------
  -- 3. nvim-cmp プラグインの設定ブロック (自動補完) --
  --------------------------------------------------
  {
    'hrsh7th/nvim-cmp',         -- (G) nvim-cmpプラグイン本体の指定 (自動補完用)
    dependencies = {            -- (H) nvim-cmpが補完候補を得るための「ソース」プラグイン
      'neovim/nvim-lspconfig',  -- LSPからの補完候補を得るために必要
      'hrsh7th/cmp-nvim-lsp',   -- LSPからの補完候補をnvim-cmpに提供するプラグイン
      'saadparwaiz1/cmp_luasnip', -- (任意) スニペットからの補完候補を得るためのプラグイン
      'L3MON4D3/LuaSnip',        -- (任意) スニペットエンジン本体
    },
    config = function()         -- (I) nvim-cmpプラグインが読み込まれた後に実行される設定
      local cmp = require('cmp')       -- nvim-cmpモジュールを読み込む
      local luasnip = require('luasnip') -- LuaSnipモジュールを読み込む

      cmp.setup({                 -- (I-1) nvim-cmp の全体設定
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- スニペットを展開する関数 (LuaSnipを使う場合)
          end,
        },
        mapping = cmp.mapping.preset.insert({ -- (I-2) 補完メニュー操作のキーマップ設定
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),  -- ドキュメントを上にスクロール
          ['<C-f>'] = cmp.mapping.scroll_docs(4),   -- ドキュメントを下にスクロール
          ['<C-Space>'] = cmp.mapping.complete(),    -- 手動で補完を起動
          ['<C-e>'] = cmp.mapping.abort(),          -- 補完メニューを閉じる
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enterで選択中の候補を確定
        }),
        sources = cmp.config.sources({        -- (I-3) 補完候補の「情報源」設定
          { name = 'nvim_lsp' },    -- LSPサーバーから補完候補を取得 (これがLSPとの連携部分)
          { name = 'luasnip' },     -- スニペットから補完候補を取得
        }, {
          { name = 'buffer' },      -- 現在開いているファイル（バッファ）内の単語からも補完候補を取得
        })
      })
    end,
  },

  -- (他のプラグイン設定があれば、この下にあるかもしれません)
}
