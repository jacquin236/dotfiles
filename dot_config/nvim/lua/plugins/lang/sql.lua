local sql_ft = { "sql", "mysql", "plsql" }

return {
  { "folke/which-key.nvim", opts = { spec = { { "<leader>D", group = "database", icon = " " } } } },
  {
    "kndndrj/nvim-dbee",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "Dbee",
    build = function()
      require("dbee").install()
    end,
    opts = {},
    config = function(_, opts)
      require("dbee").setup(opts)
    end,
    -- stylua: ignore
    keys = {
      { "<leader>Db", function() require("dbee").open() end, desc = "[dbee] Open UI" },
      { "<leader>DB", function() require("dbee").close() end, desc = "[dbee] Close UI" },
      { "<leader>Dd", function() require("dbee").toggle() end, desc = "[dbee] Toggle UI" },
      { "<leader>Dc", function() require("dbee").store("csv", "file", { extra_arg = "/home/bubblegum/database/file.csv" }) end, desc = "[dbee] Save CSV to File" },
      { "<leader>DC", function() require("dbee").store("csv", "buffer", { extra_arg = 0 }) end, desc = "[dbee] Save CSV to Current Buffer" },
      { "<leader>Dj", function() require("dbee").store("json", "file", { extra_arg = "/home/bubblegum/database/file.json" }) end, desc = "[dbee] Save JSON to File" },
      { "<leader>DJ", function() require("dbee").store("json", "buffer", { extra_arg = 0 }) end, desc = "[dbee] Save JSON to Current Buffer" },
    },
  },
  {
    "MattiasMTS/cmp-dbee",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "kndndrj/nvim-dbee",
    },
    opts = {},
    ft = sql_ft,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = sql_ft,
        callback = function()
          local cmp = require("cmp")
          local sources = vim.tbl_map(function(source)
            return { name = source.name }
          end, cmp.get_config().sources)

          table.insert(sources, { name = "cmp-dbee" })
          cmp.setup.buffer({ sources = sources })
        end,
      })
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "jsborjesson/vim-uppercase-sql", ft = sql_ft },
    },
    keys = {
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add Connection" },
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find Buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
    },
  },
  {
    "nanotee/sqls.nvim",
    keys = {
      { "<leader>De", "<cmd>SqlsExecuteQuery<cr>", desc = "Execute Query" },
      { "<leader>DE", "<cmd>SqlsExecuteQueryVertical<cr>", desc = "Execute Query (vertical)" },
      { "<leader>Ds", "<cmd>SqlsShowDatabases<cr>", desc = "Show Databases" },
      { "<leader>DS", "<cmd>SqlsShowConnections<cr>", desc = "Show Connections" },
      { "<leader>Dv", "<cmd>SqlsSwitchDatabase<cr>", desc = "Switch Database" },
      { "<leader>DV", "<cmd>SqlsSwitchConnection<cr>", desc = "Switch Connection" },
      { "<leader>DR", "<cmd>SqlsShowSchemas<cr>", desc = "Show Schemas" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "nanotee/sqls.nvim" },
    opts = {
      servers = {
        sqls = {
          on_attach = function(client, bufnr)
            require("sqls").on_attach(client, bufnr)
          end,
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      table.insert(opts.options.offsets, 3, {
        {
          text = "󰆼 DATABASE VIEWER",
          filetype = "dbui",
          highlight = "PanelHeading",
          separator = true,
        },
      })
    end,
  },
}
