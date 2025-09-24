return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "markdown", "css", "bash", "html", "java", "python", "rust", "typescript", "javascript" },
            sync_install = true,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            textobjects = { select = { enable = true }, },
        })
    end,
}
