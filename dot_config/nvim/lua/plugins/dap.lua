local dap_conf = require("util.dap")
local dap_icons = require("util.icons").dap

return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>d", group = "debug", icon = " ", mode = { "n", "v" } },
        { "<leader>dw", group = "Widgets", icon = "󰜬 ", mode = { "n", "v" } },
        { "<leader>db", group = "Breakpoint", icon = " " },
        { "<leader>dr", group = "Repl", icon = "󱘳 " },
        { "<leader>du", group = "Dap UI", icon = "󰊪 ", mode = { "n", "v" } },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = dap_conf.dap_core_keymaps,
    config = function()
      dap_conf.dap_core_cmds()

      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(dap_icons) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      -- Extends dap.configurations with entries read from .vscode/launch.json
      if vim.fn.filereadable(".vscode/launch.json") then
        vscode.load_launchjs()
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>dut", function() require("dapui").toggle({ }) end, desc = "Dap UI: Toggle" },
      { "<leader>duc", function() require("dapui").close() end, desc = "Dap UI: Close" },
      { "<leader>due", function() require("dapui").eval() end, desc = "Dap UI: Eval", mode = {"n", "v"} },
    },
    opts = {
      windows = { indent = 2 },
      floating = {
        border = border,
        mappings = { close = { "q", "<esc>" } },
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "right",
          size = 20,
        },
        {
          elements = {
            { id = "repl", size = 0.9 },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {},
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "LiadOz/nvim-dap-repl-highlights",
      opts = {},
    },
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dap_repl" })
      end
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "rcarriga/cmp-dap" },
    opts = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.setup.filetype({ "dap-repl", "dapui_watches" }, { sources = { { name = "dap" } } })
    end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    cond = LazyVim.has("nvim-dap"),
    config = function()
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("dap")
      end)
    end,
    --stylua: ignore
    keys = {
      { "<leader>dm", "<cmd>Telescope dap commands<cr>", desc = "Commands (telescope)" },
      { "<leader>df", "<cmd>Telescope dap frames<cr>", desc = "Frames (telescope)" },
      { "<leader>dM", "<cmd>Telescope dap configurations<cr>", desc = "Configurations (telescope)" },
      { "<leader>dL", "<cmd>Telescope dap list_breakpoints<cr>", desc = "List Breakpoints (telescope)" },
      { "<leader>dv", "<cmd>Telescope dap variables<cr>", desc = "Variables (telescope)" },
    },
  },
}
