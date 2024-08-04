return {
  {
    "xiyaowong/nvim-transparent",
    lazy = false,
    cmd = { "TransparentEnable", "TransparentToggle", "TransparentDisable" },
    keys = {
      { "<leader>uy", "<Cmd>TransparentToggle<CR>", desc = "Toggle Transparent" },
    },
    config = function()
      local transparent = require("transparent")
      transparent.clear_prefix("NeoTree")
      transparent.setup({
        extra_groups = {
          "NormalFloat",
          "OctoEditable",
          "EndOfBuffer",
        },
        exclude_groups = {
          "CursorLine",
        },
      })
    end,
  },
}
