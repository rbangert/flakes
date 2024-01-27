return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
        lua = { "stylua" },
        html = { "djlint" },
        javascript = { "prettier" },
        json = { "fixjson" },
        go = { "goimports", "gofmt", "gofumpt" },
        markdown = { "mdformat" },
      },
    },
  },
}
