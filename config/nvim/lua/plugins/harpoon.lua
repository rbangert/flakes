return {
  {
    "theprimeagen/harpoon",
    keys = {
      {
        "<leader>h",
        desc = "harpoon",
      },
      {
        "<leader>hm",
        "<cmd>lua require('harpoon.mark').add_file()<cr>",
        desc = "Mark Buffer",
      },
      {
        "<leader>hh",
        "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
        desc = "Quick Menu",
      },
    },
  },
}
