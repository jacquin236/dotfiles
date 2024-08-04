return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<Cmd>UndotreeToggle<CR>", desc = "Undotree Toggle" } },
    config = function()
      vim.g.undotree_TreeNodeShape = "◉"
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      table.insert(opts.options.offsets, 2, {
        {
          text = "  UNDOTREE",
          filetype = "undotree",
          highlight = "PanelHeading",
          separator = true,
        },
      })
    end,
  },
}
