return {
  {
    "vimwiki/vimwiki",
    branch = "dev",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.vimwiki_list = { { path = "~/p/wiki", syntax = "markdown", ext = ".md" } }
    end,
  },
  {
    "tools-life/taskwiki",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.taskwiki_settings = {
        taskwiki_taskrc_location = "path/to/config",
        taskwiki_data_location = "path/to/taskwarrior/directory/",
      }
    end,
  },
  { "powerman/vim-plugin-AnsiEsc" },
  { "majutsushi/tagbar" },
  { "farseer90718/vim-taskwarrior" },
  { "jmcantrell/vim-virtualenv" },
}
