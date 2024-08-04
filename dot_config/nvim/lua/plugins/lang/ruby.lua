LazyVim.on_very_lazy(function()
  vim.filetype.add({
    filename = {
      Brewfile = "ruby",
      Podfile = "ruby",
    }
  })
end)

return {
  {
    "weizheheng/ror.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "rcarriga/nvim-notify",
    },
    ft = { "ruby", "eruby" },
    opts = {},
    keys = {
      {
        "<localleader>R",
        function()
          require("ror.commands").list_commands()
        end,
        desc = "RoR Menu (ruby)",
      },
    },
  },
}
