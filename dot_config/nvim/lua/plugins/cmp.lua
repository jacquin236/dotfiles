local completion = require("util.completion")

return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      { "hrsh7th/cmp-path", enabled = false },
      "https://codeberg.org/FelipeLema/cmp-async-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      "f3fora/cmp-spell",
      "rafamadriz/friendly-snippets",
      { "garymjr/nvim-snippets", opts = { friendly_snippets = true } },
      {
        "uga-rosa/cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
          paths = completion.dictionary_find(),
          first_case_insensitive = true,
          exact_length = 2,
          document = { enable = false },
        },
      },
      {
        "Gelio/cmp-natdat",
        ft = { "norg", "org", "markdown" },
        opts = { cmp_kind_text = "NatDat" },
        config = function(_, opts)
          require("cmp_natdat").setup(opts)
          require("lspkind").init({
            symbol_map = { NatDat = "🗓️" },
          })
        end,
      },
    },
    keys = {
      { "<leader>iC", "<cmd>CmpStatus<cr>", desc = "Cmp" },
    },
    opts = function(_, opts)
      opts.sources = completion.sources
      opts.window = completion.window
      opts.formatting = completion.formatting
      opts.performance = completion.performance
      opts.sorting = completion.sorting
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      cmp.setup.cmdline({ "/", "?" }, {
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" }, { name = "async_path" } },
      })

      cmp.setup.cmdline(":", {
        completion = { completeopt = "menu,menuone,noselect,noinsert" },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "cmdline_history" },
          { name = "async_path" },
        }),
      })
    end,
  },
}
