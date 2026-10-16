return {
    "dynamotn/swapson.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
        pip = {
            enabled = true,
            tool = "uv",
        },
    },
}
