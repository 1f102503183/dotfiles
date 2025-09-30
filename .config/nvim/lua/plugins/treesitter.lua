return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    priority = 100, -- read faster than other plugins
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "markdown", "css", "bash", "html", "java", "python", "rust", "typescript", "javascript" },
            sync_install = true,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            textobjects = { select = { enable = true }, },
            additional_vim_regex_highlighting = false,
        })
    end,
}
