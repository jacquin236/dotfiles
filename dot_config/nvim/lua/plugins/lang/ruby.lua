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
  {
    "vim-ruby/vim-ruby",
    ft = { "ruby", "eruby" },
    config = function()
      vim.g.ruby_indent_access_modifier_style = 'indent'
      vim.g.ruby_indent_block_style = 'expression'
      vim.g.ruby_indent_assignment_style = 'variable'
      vim.g.ruby_indent_hanging_elements = 0
      vim.g.rubycomplete_rails = 1
      vim.g.rubycomplete_load_gemfile = 1
    end
  },
}
