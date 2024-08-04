return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    cmd = {
      "ToggleTerm",
      "ToggleTermSetName",
      "ToggleTermToggleAll",
      "ToggleTermSendVisualLines",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualSelection",
    },
    opts = {
      hide_numbers = true,
      start_in_insert = true,
      persist_size = true,
      close_on_exit = true,
      direction = "horizontal",
      shell = vim.o.shell,
      autochdir = true,
      auto_scroll = true,
      winbar = { enabled = false },
      float_opts = {
        winblend = 0,
        title_pos = "center",
        border = border,
      },
      shade_filetypes = {},
      shade_terminal = false,
      shading_factor = 0.1,
      size = function(term)
        if term.direction == "horizontal" then
          return 12
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      local lazydocker = Terminal:new({
        cmd = "lazydocker",
        dir = "git_dir",
        hidden = true,
        direction = "float",
        close_on_exit = true,
      })

      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        hidden = true,
        direction = "float",
        close_on_exit = true,
        float_opts = { width = vim.o.columns, height = vim.o.lines },
      })

      local gh_dash = Terminal:new({
        cmd = "gh dash",
        hidden = true,
        direction = "float",
        float_opts = {
          height = function()
            return math.floor(vim.o.lines * 0.8)
          end,
          width = function()
            return math.floor(vim.o.columns * 0.95)
          end,
        },
        close_on_exit = true,
      })

      local map = vim.keymap.set

      map("n", "<localleader>th", function()
        gh_dash:toggle()
      end, { desc = "ToggleTerm: GitHub Dashboard" })

      map("n", "<localleader>tg", function()
        lazygit:toggle()
      end, { desc = "ToggleTerm: LazyGit" })

      map("n", "<localleader>td", function()
        lazydocker:toggle()
      end, { desc = "ToggleTerm: Lazy Docker" })
    end,

    keys = {
      { [[<C-\>]], "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal (toggleterm)" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<localleader>t", group = "Terminals", icon = " " },
      },
    },
  },
}
