return {
    {
        "saghen/blink.cmp",
        build = "cargo build --release",
        opts = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "rafamadriz/friendly-snippets",
        },
        version = "1.*",
    },
}
