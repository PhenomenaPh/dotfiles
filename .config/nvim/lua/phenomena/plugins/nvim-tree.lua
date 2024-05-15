return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    require("neo-tree").setup({
      window = {
        width = 35
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    })

    local keymap = vim.keymap 

    keymap.set("n", "<leader>ee", "<cmd>Neotree filesystem reveal left<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ec", "<cmd>Neotree close<CR>", { desc = "Toggle file explorer" })
  end
}

