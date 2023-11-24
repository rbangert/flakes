return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,
          auto_trigger = false,
          debouce = 75,
        },
        panel = { enabled = false },
      })
    end,
  },
}
