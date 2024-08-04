return {
  {
    "lewis6991/hover.nvim",
    init = function()
      -- Require providers
      require("hover.providers.lsp")
      -- require('hover.providers.gh')
      -- require('hover.providers.gh_user')
      -- require('hover.providers.jira')
      -- require("hover.providers.dap")
      -- require('hover.providers.fold_preview')
      require("hover.providers.diagnostic")
      -- require('hover.providers.man')
      require("hover.providers.dictionary")
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "K", false }
    end,
    opts = {
      preview_opts = { border = border },
      preview_window = false,
      title = true,
      mouse_providers = { "LSP" },
      mouse_delay = 500,
    },
    config = function(_, opts)
      require("hover").setup(opts)

      local map = vim.keymap.set

      map("n", "K", require("hover").hover, { desc = "Hover" })
      map("n", "gK", require("hover").hover_select, { desc = "Hover Select" })
      map("n", "<C-p>", function()
        require("hover").hover_switch("previous")
      end, { desc = "[hover] Previous Source" })
      map("n", "<C-n>", function()
        require("hover").hover_switch("next")
      end, { desc = "[hover] Next Source" })

      map("n", "<MouseMove>", require("hover").hover_mouse, { desc = "[hover] Mouse" })
      vim.o.mousemoveevent = true
    end,
  },
}
