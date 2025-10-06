return {
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "html", "javascriptreact", "typescriptreact", "jsx", "tsx" },
        config = function()
            require("nvimts-autotag").setup({
                enable_close = true,
            })
        end
    },
}
