return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    { "sindrets/diffview.nvim", optional = true },
  },
  cmd = { "Neogit" },
  opts = {
    disable_signs = false,
    disable_hint = true,
    disable_commit_confirmation = true,
    disable_builtin_notifications = true,
    disable_insert_on_commit = false,
    signs = {
      section = { "", "󰘕" }, -- "󰁙", "󰁊"
      item = { "▸", "▾" },
      hunk = { "󰐕", "󰍴" },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>gnt", "<cmd>Neogit<cr>",                                     desc = "Toggle Neogit" },
    { "<leader>gns", function() require("neogit").open() end,               desc = "Status Buffer" },
    { "<leader>gnc", function() require("neogit").open({ "commit" }) end,   desc = "Commit Buffer" },
    { "<leader>gnp", function() require("neogit").popups.pull.create() end, desc = "Pull Popup" },
    { "<leader>gnP", function() require("neogit").popups.push.create() end, desc = "Push Popup" },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>gn", group = "Neogit", icon = " " },
      },
    },
  },
}
