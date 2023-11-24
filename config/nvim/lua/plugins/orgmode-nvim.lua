return {
  {
    "nvim-orgmode/orgmode",
    config = function()
      require("orgmode").setup({})
    end,
    init = function()
      require("orgmode").setup_ts_grammar()

      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          disable = { "org" },
          additional_vim_regex_highlighting = { "org" },
        },
        ensure_installed = { "org" },
      })

      require("orgmode").setup({
        org_agenda_files = { "~/p/org/*", "~/s/orgs/**/*" },
        org_default_notes_file = "~/p/org/refile.org",
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      require("cmp").setup({
        sources = {
          { name = "orgmode" },
        },
      })
    end,
  },
}
