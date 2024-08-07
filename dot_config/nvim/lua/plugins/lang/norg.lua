local norg_func = require("util.neorg")
local list_workspaces = norg_func.list_workspaces

LazyVim.on_very_lazy(function()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("norg_conceal", { clear = true }),
    pattern = { "norg" },
    callback = function()
      vim.opt_local.conceallevel = 2
      vim.opt_local.foldlevel = 99
    end
  })
end)

return {
  {
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
    },
    lazy = false,
    version = "*",
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},

          ["core.completion"] = { config = { engine = "nvim-cmp" } },
          ["core.concealer"] = {
            config = { icon_preset = "diamond", icons = { code_block = { spell_check = false } } },
          },
          ["core.dirman"] = {
            config = {
              workspaces = list_workspaces({
                "notes",
                "works",
                "projects",
                "ideas",
              }),
              default_workspace = "default",
            },
          },
          ["core.esupports.metagen"] = {},
          ["core.export"] = {},
          ["core.export.markdown"] = {},
          ["core.integrations.telescope"] = { config = { insert_file_link = { show_title_preview = true } } },
          ["core.integrations.treesitter"] = {},
          ["core.highlights"] = {},
          ["core.journal"] = {},
          ["core.keybinds"] = {
            config = { default_keybinds = false },
          },
        },
      })
    end,
    keys = norg_func.keybinds,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      cmp.setup.filetype("norg", {
        sources = {
          { name = "neorg",      group_index = 1 },
          { name = "dictionary", group_index = 1 },
          { name = "spell",      group_index = 1 },
          { name = "emoji",      group_index = 1 },
          { name = "natdat",     group_index = 1 },
          { name = "buffer",     group_index = 2 },
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>n", group = "notes/neorg", icon = "󱞁 " },
        { "<localleader>n", group = "Neorg", icon = "𝗡" },
      },
    },
  },
}
