return {
  "dynamotn/swapson.nvim",
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    npm = {
      enabled = true,
      tool = "bun",
    },
    pip = {
      enabled = true,
      tool = "uv",
    },
  },
}
