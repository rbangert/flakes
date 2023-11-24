return {
  {
    "onsails/lspkind-nvim",
    lazy = false,
    event = { "VeryLazy" },
    config = function()
      require("lspkind").init({
        -- preset = "codicons",
        symbol_map = {
          Copilot = "",
        },
      })
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
  },
}
