return  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    keys = {
        {"<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle File Tree"},
    },
    config = function()
        require("neo-tree").setup{
            filesystem = {
                filtered_items = {
                    visible = true,      -- show hidden files
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
        }
    end,
  }
