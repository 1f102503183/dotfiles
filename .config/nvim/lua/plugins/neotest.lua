return {
    --neotestの設定
        {
            "nvim-neotest/neotest",
            dependencies = {
                "nvim-neotest/nvim-nio", 
                "nvim-lua/plenary.nvim",
                "antoinemadec/FixCursorHold.nvim",
                "nvim-tresitter/nvim-treesitter",
                -- add test runner
                "rcasia/neotest-java",
            },

            opts = { adapters = { "neotest-java" }, },
            
        },
}
