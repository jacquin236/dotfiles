return {
  {
    "Saecki/crates.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = { enabled = true },
        crates = { enabled = true },
      },
      popup = {
        border = border,
        autofocus = true,
        style = "minimal",
      },
    },
    config = function(_, opts)
      require("crates").setup(opts)
    end,
    -- stylua: ignore
    keys = {
      { "<leader>prR", function() require("crates").reload() end, desc = "Reload" },
      { "<leader>pro", function() require("crates").toggle() end, desc = "Toggle" },

      { "<leader>pru", function() require("crates").update_crate() end, desc = "Update Crate" },
      { "<leader>pru", mode = "v", function() require("crates").update_crates() end, desc = "Update Crates" },
      { "<leader>pra", function() require("crates").update_all_crates() end, desc = "Update All Crates" },

      { "<leader>prU", function() require("crates").upgrade_crate() end, desc = "Upgrade Crate" },
      { "<leader>prU", mode = "v", function() require("crates").upgrade_crates() end, desc = "Upgrade Crates" },
      { "<leader>prA", function() require("crates").upgrade_all_crates() end, desc = "Upgrade All Crates" },

      { "<leader>prt", function() require("crates").expand_plain_crate_to_inline_table() end, desc = "Extract into Inline Table" },
      { "<leader>prT", function() require("crates").extract_crate_into_table() end, desc = "Extract into Table" },

      { "<leader>prh", function() require("crates").open_homepage() end, desc = "Homepage" },
      { "<leader>prr", function() require("crates").open_repository() end, desc = "Repo" },
      { "<leader>prd", function() require("crates").open_documentation() end, desc = "Documentation" },
      { "<leader>prc", function() require("crates").open_crates_io() end, desc = "crates.io" },
      { "<leader>prl", function() require("crates").open_lib_rs() end, desc = "lib.rs" },

      { "<leader>prv", function() require("crates").show_versions_popup() end, desc = "Versions popup" },
      { "<leader>prp", function() require("crates").show_dependencies_popup() end, desc = "De[p]endencies popup" },
      { "<leader>prf", function() require("crates").show_features_popup() end, desc = "Features popup" },
      { "<leader>prs", function() require("crates").show_crate_popup() end, desc = "Crate[s] details popup" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>p", group = "packages/dependencies", icon = " ", mode = { "n", "v" } },
        { "<leader>pr", group = "rust: Cargo.toml", icon = "📦", mode = { "n", "v" } },
      },
    },
  },
}
